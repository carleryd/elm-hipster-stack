/**
 * Copyright (c) 2016, John Hewson
 * All rights reserved.
 */
"use strict";
var type_1 = require('graphql/type');
var utilities_1 = require('graphql/utilities');
function decoderForQuery(def, info, schema, seenEnums, fragmentDefinitionMap) {
    function walkOperationDefinition(def, info) {
        info.enter(def);
        if (def.operation == 'query' || def.operation == 'mutation') {
            var decls = [];
            // Name
            var name_1;
            if (def.name) {
                name_1 = def.name.value;
            }
            else {
                name_1 = 'AnonymousQuery';
            }
            var resultType = name_1[0].toUpperCase() + name_1.substr(1) + 'Result';
            // todo: Directives
            // SelectionSet
            var expr = walkSelectionSet(def.selectionSet, info);
            //decls.push({ name: resultType, fields });
            // VariableDefinition
            var parameters = [];
            for (var _i = 0, _a = def.variableDefinitions; _i < _a.length; _i++) {
                var varDef = _a[_i];
                var name_2 = varDef.variable.name.value;
                var type = inputTypeToString(utilities_1.typeFromAST(schema, varDef.type));
                // todo: default value
                parameters.push({ name: name_2, type: type });
            }
            info.leave(def);
            //return decls;
            return { expr: 'map ' + resultType + ' ' + expr.expr };
        }
    }
    function walkSelectionSet(selSet, info) {
        info.enter(selSet);
        var fields = [];
        for (var _i = 0, _a = selSet.selections; _i < _a.length; _i++) {
            var sel = _a[_i];
            if (sel.kind == 'Field') {
                var field = sel;
                fields.push(walkField(field, info));
            }
            else if (sel.kind == 'FragmentSpread') {
                // expand out all fragment spreads
                var spreadName = sel.name.value;
                var def_1 = fragmentDefinitionMap[spreadName];
                fields.push(walkSelectionSet(def_1.selectionSet, info));
            }
            else if (sel.kind == 'InlineFragment') {
                // todo: InlineFragment
                throw new Error('not implemented: InlineFragment');
            }
        }
        info.leave(selSet);
        return { expr: fields.map(function (f) { return f.expr; }).join('\n        `apply` ') };
    }
    function getSelectionSetFields(selSet, info) {
        info.enter(selSet);
        var fields = [];
        for (var _i = 0, _a = selSet.selections; _i < _a.length; _i++) {
            var sel = _a[_i];
            if (sel.kind == 'Field') {
                var field = sel;
                var name_3 = field.name.value;
                if (field.alias) {
                    name_3 = field.alias.value;
                }
                fields.push(name_3);
            }
            else if (sel.kind == 'FragmentSpread') {
                // expand out all fragment spreads
                var spreadName = sel.name.value;
                var def_2 = fragmentDefinitionMap[spreadName];
                fields = fields.concat(getSelectionSetFields(def_2.selectionSet, info));
            }
            else if (sel.kind == 'InlineFragment') {
                // todo: InlineFragment
                throw new Error('not implemented: InlineFragment');
            }
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
        // Arguments (opt)
        var args = field.arguments; // e.g. id: "1000"
        // todo: Directives
        // SelectionSet
        if (field.selectionSet) {
            var prefix = '';
            if (info.getType() instanceof type_1.GraphQLList) {
                prefix = 'list ';
            }
            var fields = walkSelectionSet(field.selectionSet, info);
            info.leave(field);
            //return { name, fields };
            var fieldNames = getSelectionSetFields(field.selectionSet, info);
            var shape = "(\\" + fieldNames.join(' ') + " -> { " + fieldNames.map(function (f) { return f + ' = ' + f; }).join(', ') + " })";
            var left = '("' + name + '" :=\n';
            var right = '(map ' + shape + ' ' + fields.expr + '))';
            var indent = '        ';
            if (prefix) {
                return { expr: left + indent + '(' + prefix + right + ')' };
            }
            else {
                return { expr: left + indent + right };
            }
        }
        else {
            var isMaybe = !(info.getType() instanceof type_1.GraphQLList ||
                info.getType() instanceof type_1.GraphQLNonNull);
            var type = leafTypeToString(info.getType());
            info.leave(field);
            //return { name, type };
            var expr = { expr: '("' + name + '" := ' + type + ')' };
            if (isMaybe) {
                expr = { expr: '(maybe ' + expr.expr + ')' };
            }
            return expr;
        }
    }
    function leafTypeToString(type) {
        var prefix = '';
        // lists or non-null of leaf types only
        var t;
        if (type instanceof type_1.GraphQLList) {
            t = type.ofType;
            prefix = 'list ';
        }
        else if (type instanceof type_1.GraphQLNonNull) {
            t = type.ofType;
        }
        else {
            // implicitly nullable
            //prefix = 'Maybe ';
            t = type;
        }
        type = t;
        // leaf types only
        if (type instanceof type_1.GraphQLScalarType) {
            if (type.name == 'ID') {
                return prefix + 'string';
            }
            else {
                return prefix + type.name.toLowerCase();
            }
        }
        else if (type instanceof type_1.GraphQLEnumType) {
            return prefix + type.name.toLowerCase();
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
            return prefix + type.name;
        }
        else if (type instanceof type_1.GraphQLScalarType) {
            return prefix + type.name;
        }
        else {
            throw new Error('not a leaf type: ' + type.constructor.name);
        }
    }
    return walkOperationDefinition(def, info);
}
exports.decoderForQuery = decoderForQuery;
