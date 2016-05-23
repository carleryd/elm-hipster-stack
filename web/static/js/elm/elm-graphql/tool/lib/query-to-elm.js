/**
 * Copyright (c) 2016, John Hewson
 * All rights reserved.
 */
"use strict";
/// <reference path="../typings/node.d.ts" />
/// <reference path="../typings/request.d.ts" />
/// <reference path="../typings/graphql-types.d.ts" />
/// <reference path="../typings/graphql-language.d.ts" />
/// <reference path="../typings/graphql-utilities.d.ts" />
var fs = require('fs');
var path = require('path');
var request = require('request');
var language_1 = require("graphql/language");
var elm_ast_1 = require('./elm-ast');
var type_1 = require('graphql/type');
var utilities_1 = require('graphql/utilities');
var query_to_decoder_1 = require('./query-to-decoder');
var graphqlFile = process.argv[2];
if (!graphqlFile) {
    console.error('usage: query-to-elm graphql_file <endpoint_url>');
    process.exit(1);
}
var uri = process.argv[3] || 'http://localhost:8080/graphql';
var queries = fs.readFileSync(graphqlFile, 'utf8');
var queryDocument = language_1.parse(queries);
var basename = path.basename(graphqlFile);
var extname = path.extname(graphqlFile);
var filename = basename.substr(0, basename.length - extname.length);
var moduleName = 'GraphQL.' + filename;
var outPath = path.join(path.dirname(graphqlFile), filename + '.elm');
var url = uri + '?query=' + utilities_1.introspectionQuery.replace(/\n/g, '');
request(url, function (err, res, body) {
    if (err) {
        throw new Error(err);
    }
    else if (res.statusCode == 200) {
        var result = JSON.parse(body);
        var schema = utilities_1.buildClientSchema(result.data);
        var _a = translateQuery(uri, queryDocument, schema), decls = _a[0], expose = _a[1];
        var elm = elm_ast_1.moduleToElm(moduleName, expose, [
            'Task exposing (Task)',
            'Json.Decode exposing (..)',
            'Json.Encode exposing (encode)',
            'Http',
            'GraphQL exposing (apply, ID)'
        ], decls);
        fs.writeFileSync(outPath, elm);
    }
    else {
        throw new Error('HTTP status ' + res.statusCode);
    }
});
function translateQuery(uri, doc, schema) {
    var seenEnums = {};
    var expose = [];
    var fragmentDefinitionMap = {};
    var seenFragments = {};
    function walkQueryDocument(doc, info) {
        var decls = [];
        decls.push({ name: 'endpointUrl', parameters: [], returnType: 'String', body: { expr: "\"" + uri + "\"" } });
        for (var _i = 0, _a = doc.definitions; _i < _a.length; _i++) {
            var def = _a[_i];
            if (def.kind == 'OperationDefinition') {
                decls.push.apply(decls, walkOperationDefinition(def, info));
            }
            else if (def.kind == 'FragmentDefinition') {
                decls.push.apply(decls, walkFragmentDefinition(def, info));
            }
        }
        for (var name_1 in seenEnums) {
            var seenEnum = seenEnums[name_1];
            decls.unshift(walkEnum(seenEnum));
            decls.push(decoderForEnum(seenEnum));
            expose.push(seenEnum.name);
        }
        return [decls, expose];
    }
    function walkEnum(enumType) {
        return { name: enumType.name, constructors: enumType.getValues().map(function (v) { return v.name; }) };
    }
    function decoderForEnum(enumType) {
        // might need to be Maybe Episode, with None -> fail in the Decoder
        return { name: enumType.name.toLowerCase(), parameters: [],
            returnType: 'Decoder ' + enumType.name,
            body: { expr: 'customDecoder string (\\s ->\n' +
                    '        case s of\n' + enumType.getValues().map(function (v) {
                    return '            "' + v.name + '" -> Ok ' + v.name;
                }).join('\n') + '\n' +
                    '            _ -> Err "Unknown ' + enumType.name + '")'
            }
        };
    }
    function walkOperationDefinition(def, info) {
        info.enter(def);
        if (!info.getType()) {
            throw new Error("GraphQL schema does not define " + def.operation + " '" + def.name.value + "'");
        }
        seenFragments = {};
        if (def.operation == 'query' || def.operation == 'mutation') {
            var decls = [];
            // Name
            var name_2;
            if (def.name) {
                name_2 = def.name.value;
            }
            else {
                name_2 = 'AnonymousQuery';
            }
            var resultType = name_2[0].toUpperCase() + name_2.substr(1) + 'Result';
            // todo: Directives
            // SelectionSet
            var fields = walkSelectionSet(def.selectionSet, info);
            decls.push({ name: resultType, fields: fields });
            // VariableDefinition
            var parameters = [];
            for (var _i = 0, _a = def.variableDefinitions; _i < _a.length; _i++) {
                var varDef = _a[_i];
                var name_3 = varDef.variable.name.value;
                var schemaType = utilities_1.typeFromAST(schema, varDef.type);
                var type = inputTypeToString(schemaType);
                parameters.push({ name: name_3, type: type, schemaType: schemaType, hasDefault: varDef.defaultValue != null });
            }
            var funcName = name_2[0].toLowerCase() + name_2.substr(1);
            // include all fragment dependencies in the query
            var query = '';
            for (var name_4 in seenFragments) {
                query += language_1.print(seenFragments[name_4]) + ' ';
            }
            query += language_1.print(def);
            var decodeFuncName = resultType[0].toLowerCase() + resultType.substr(1);
            expose.push(funcName);
            expose.push(resultType);
            var parametersRecord = {
                name: 'params',
                type: '{ ' + parameters.map(function (p) { return p.name + ': ' + inputTypeToString(p.schemaType); }).join(', ') + ' }'
            };
            decls.push({
                name: funcName, parameters: [parametersRecord],
                returnType: "Task Http.Error " + resultType,
                body: {
                    // we use awkward variable names to avoid naming collisions with query parameters
                    expr: ("let graphQLQuery = \"\"\"" + query.replace(/\s+/g, ' ') + "\"\"\" in\n") +
                        "    let graphQLParams =\n" +
                        "            Json.Encode.object\n" +
                        "                [ " +
                        parameters.map(function (p) {
                            var encoder;
                            if (p.hasDefault) {
                                encoder = ("case params." + p.name + " of") +
                                    ("\n                            Just val -> " + encoderForType(p.schemaType) + " val") +
                                    "\n                            Nothing -> Json.Encode.null";
                            }
                            else {
                                encoder = encoderForType(p.schemaType) + ' params.' + p.name;
                            }
                            return "(\"" + p.name + "\", " + encoder + ")";
                        })
                            .join("\n                , ") + '\n' +
                        "                ]\n" +
                        "    in\n" +
                        ("    GraphQL.query endpointUrl graphQLQuery \"" + name_2 + "\" (encode 0 graphQLParams) " + decodeFuncName)
                }
            });
            decls.push({
                name: decodeFuncName, parameters: [],
                returnType: 'Decoder ' + resultType,
                body: query_to_decoder_1.decoderForQuery(def, info, schema, seenEnums, fragmentDefinitionMap) });
            info.leave(def);
            return decls;
        }
    }
    function encoderForType(type) {
        if (type instanceof type_1.GraphQLObjectType) {
            var fieldEncoders = [];
            var fields = type.getFields();
            for (var name_5 in fields) {
                var f = fields[name_5];
                fieldEncoders.push("(\"" + f.name + "\", " + encoderForType(f.type) + " " + f.name + ")");
            }
            return '(object [' + fieldEncoders.join(", ") + '])';
        }
        else if (type instanceof type_1.GraphQLList) {
            return 'list ' + encoderForType(type.ofType);
        }
        else if (type instanceof type_1.GraphQLNonNull) {
            return encoderForType(type.ofType);
        }
        else if (type instanceof type_1.GraphQLScalarType) {
            return 'Json.Encode.' + type.name.toLowerCase();
        }
        else {
            throw new Error('not implemented: ' + type.constructor.name); // todo: what?
        }
    }
    function walkFragmentDefinition(def, info) {
        info.enter(def);
        var name = def.name.value;
        fragmentDefinitionMap[name] = def;
        var decls = [];
        var resultType = name[0].toUpperCase() + name.substr(1) + 'Result';
        // todo: Directives
        // SelectionSet
        var fields = walkSelectionSet(def.selectionSet, info);
        decls.push({ name: resultType, fields: fields });
        info.leave(def);
        return decls;
    }
    function walkSelectionSet(selSet, info) {
        info.enter(selSet);
        var fields = [];
        var spreads = [];
        for (var _i = 0, _a = selSet.selections; _i < _a.length; _i++) {
            var sel = _a[_i];
            if (sel.kind == 'Field') {
                var field = sel;
                fields.push(walkField(field, info));
            }
            else if (sel.kind == 'FragmentSpread') {
                spreads.push(sel.name.value);
            }
            else if (sel.kind == 'InlineFragment') {
                // todo: InlineFragment
                throw new Error('not implemented: InlineFragment');
            }
        }
        // expand out all fragment spreads
        for (var _b = 0, spreads_1 = spreads; _b < spreads_1.length; _b++) {
            var spreadName = spreads_1[_b];
            var def = fragmentDefinitionMap[spreadName];
            seenFragments[spreadName] = def;
            var spreadFields = walkSelectionSet(def.selectionSet, info);
            fields = fields.concat(spreadFields);
        }
        info.leave(selSet);
        return fields;
    }
    function walkField(field, info) {
        info.enter(field);
        // Name
        var name = field.name.value;
        // Alias
        if (field.alias) {
            name = field.alias.value;
        }
        // todo: Arguments, such as `id: $someId`, where $someId is a variable
        var args = field.arguments; // e.g. id: "1000"
        // todo: Directives
        // SelectionSet
        if (field.selectionSet) {
            var isList = info.getType() instanceof type_1.GraphQLList;
            var fields = walkSelectionSet(field.selectionSet, info);
            info.leave(field);
            return { name: name, fields: fields, list: isList };
        }
        else {
            if (!info.getType()) {
                throw new Error('Unknown GraphQL field: ' + field.name.value);
            }
            var type = leafTypeToString(info.getType());
            info.leave(field);
            return { name: name, type: type };
        }
    }
    function leafTypeToString(type) {
        var prefix = '';
        // lists or non-null of leaf types only
        var t;
        if (type instanceof type_1.GraphQLList) {
            t = type.ofType;
            prefix = 'List ';
        }
        else if (type instanceof type_1.GraphQLNonNull) {
            t = type.ofType;
        }
        else {
            // implicitly nullable
            prefix = 'Maybe ';
            t = type;
        }
        type = t;
        // leaf types only
        if (type instanceof type_1.GraphQLScalarType) {
            return prefix + type.name;
        }
        else if (type instanceof type_1.GraphQLEnumType) {
            seenEnums[type.name] = type;
            return prefix + type.name;
        }
        else {
            throw new Error('not a leaf type: ' + type.name);
        }
    }
    // input types are defined in the query, not the schema
    function inputTypeToString(type) {
        var prefix = '';
        // lists or non-null of leaf types only
        if (type instanceof type_1.GraphQLList) {
            type = type.ofType;
            prefix = 'List ';
        }
        else if (type instanceof type_1.GraphQLNonNull) {
            type = type.ofType;
        }
        else {
            // implicitly nullable
            prefix = 'Maybe ';
        }
        if (type instanceof type_1.GraphQLEnumType) {
            seenEnums[type.name] = type;
            return prefix + type.name;
        }
        else if (type instanceof type_1.GraphQLScalarType) {
            return prefix + type.name;
        }
        else {
            throw new Error('not a leaf type: ' + type.constructor.name);
        }
    }
    return walkQueryDocument(doc, new utilities_1.TypeInfo(schema));
}
