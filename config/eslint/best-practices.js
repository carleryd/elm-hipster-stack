module.exports = {
  rules: {
    // enforces getter/setter pairs in objects
    'accessor-pairs': 0,
    // treat var statements as if they were block scoped
    'block-scoped-var': 2,
    // specify the maximum cyclomatic complexity allowed in a program
    complexity: [0, 11],
    // require return statements to either always or never specify values
    'consistent-return': 2,
    // specify curly brace conventions for all control statements
    curly: [2, 'multi-line'],
    // require default case in switch statements
    'default-case': 2,
    // enforces consistent newlines before or after dots
    'dot-location': 0,
    // make sure for-in loops have an if statement
    'guard-for-in': 2,
    // disallow the use of alert, confirm, and prompt
    'no-alert': 1,
    // disallow use of arguments.caller or arguments.callee
    'no-caller': 2,
    // disallow lexical declarations in case/default clauses
    // http://eslint.org/docs/rules/no-case-declarations.html
    'no-case-declarations': 2,
    // disallow division operators explicitly at beginning of regular expression
    'no-div-regex': 0,
    // disallow else after a return in an if
    'no-else-return': 2,
    // disallow comparisons to null without a type-checking operator
    'no-eq-null': 0,
    // disallow use of eval()
    'no-eval': 2,
    // disallow adding to native types
    'no-extend-native': 2,
    // disallow unnecessary function binding
    'no-extra-bind': 2,
    // disallow fallthrough of case statements
    'no-fallthrough': 2,
    /**
     * disallow the use of leading or trailing decimal points in numeric
     * literals
     */
    'no-floating-decimal': 2,
    // disallow the type conversions with shorter notations
    'no-implicit-coercion': 0,
    // disallow use of eval()-like methods
    'no-implied-eval': 2,
    // disallow this keywords outside of classes or class-like objects
    'no-invalid-this': 0,
    // disallow usage of __iterator__ property
    'no-iterator': 2,
    // disallow use of labeled statements
    'no-labels': 2,
    // disallow unnecessary nested blocks
    'no-lone-blocks': 2,
    // disallow creation of functions within loops
    'no-loop-func': 2,
    // disallow use of multiple spaces
    'no-multi-spaces': 2,
    // disallow use of multiline strings
    'no-multi-str': 2,
    // disallow reassignments of native objects
    'no-native-reassign': 2,
    /**
     * disallow use of new operator when not part of the assignment or
     * comparison
     */
    'no-new': 2,
    // disallow use of new operator for Function object
    'no-new-func': 2,
    // disallows creating new instances of String,Number, and Boolean
    'no-new-wrappers': 2,
    // disallow use of (old style) octal literals
    'no-octal': 2,
    // disallow use of octal escape sequences in string literals, such as
    // var foo = 'Copyright \251';
    'no-octal-escape': 2,
    // disallow reassignment of function parameters
    // disallow parameter object manipulation
    // rule: http://eslint.org/docs/rules/no-param-reassign.html
    'no-param-reassign': [2, { props: true }],
    // disallow use of process.env
    'no-process-env': 0,
    // disallow usage of __proto__ property
    'no-proto': 2,
    // disallow declaring the same variable more then once
    'no-redeclare': 2,
    // disallow use of assignment in return statement
    'no-return-assign': 2,
    // disallow use of `javascript:` urls.
    'no-script-url': 2,
    // disallow comparisons where both sides are exactly the same
    'no-self-compare': 2,
    // disallow use of comma operator
    'no-sequences': 2,
    // restrict what can be thrown as an exception
    'no-throw-literal': 2,
    // disallow usage of expressions in statement position
    'no-unused-expressions': 2,
    // disallow unnecessary .call() and .apply()
    'no-useless-call': 0,
    // disallow use of void operator
    'no-void': 0,
    // disallow usage of configurable warning terms in comments: e.g. todo
    'no-warning-comments': [
      0,
      { terms: ['todo', 'fixme', 'xxx'], location: 'start' },
    ],
    // Restrict how comments are written.
    'spaced-comment': [2, 'always', {
      line: {
        markers: ['/'],
        exceptions: ['-', '+'],
      },
      block: {
        markers: ['!'],
        exceptions: ['*'],
      },
    }],
    // disallow use of the with statement
    'no-with': 2,
    // require immediate function invocation to be wrapped in parentheses
    // http://eslint.org/docs/rules/wrap-iife.html
    'wrap-iife': [2, 'outside'],
    // require or disallow Yoda conditions
    yoda: 2,
    // 8.1 When you must use function expressions, use arrow functions
    'prefer-arrow-callback': 2,
    'arrow-spacing': 2,
    // 8.2 Use implicit return on arrow functions. Also 8.4
    'arrow-parens': 2,
    // 'arrow-body-style': [2, 'always'], /If you dont want oneline haskeltype
    // functions uncomment this line.
    // 12.1 Use dot notation. Ex: luke.jedi
    'dot-notation': 2,
    // 13.2 Use const declaration once per variable, not once per several
    'one-var': [2, 'never'],
    // 15.1 === and !== over == and !=
    eqeqeq: 2,
    // 15.5.1 use {} inside case when declaring variable.
    'no-case-declarations': 2,
    // 15.5.2 split up ternary expression.
    'no-nested-ternary': 2,
    // 15.6 Avoid unnecessary ternary expressions.
    'no-unneeded-ternary': 2,
    // 16.2 STROUUSTROOOOUP!
    'brace-style': [2, 'stroustrup', { allowSingleLine: false }],
    // 18.1 Use soft tabs set to 2 spaces.
    indent: [2, 2, { SwitchCase: 1 }],
    // 18.2 Space before leading brace.
    'space-before-blocks': 2,
    // 18.3 Spaces everywhere!
    'keyword-spacing': 2,
    // 18.4 BAD: const x=y+5
    'space-infix-ops': 2,
    // 18.8 No new lines permitted in start and end of blocks
    'padded-blocks': [2, 'never'],
    // 18.9 No space in start and end of parentheses list.
    'space-in-parens': 2,
    // 18.10 No space in start and end of brackets.
    'array-bracket-spacing': [2, 'never'],
    // 18.11 Spacing inside curly braces.
    'object-curly-spacing': [2, 'always'],
    // 18.12 Max column length.
    'max-len': [2, 80],
    // 19.1 No leading commas.
    'comma-style': 2,
    // 19.2 Comma on every line, even last.
    'comma-dangle': [2, 'always-multiline'],
    // 20.1 SEMICOLONS EVERYWHERE.
    semi: 2,
    // 21.3 When to use Number and when to use parseInt
    radix: 2,
    // 22.2 camelCaseAllTheWay
    camelcase: 2,
    // 22.3 PascalCaseYourConstructorsOrClasses
    // 'new-cap': 2,  PROBLEM WITH IMMUTABLE.JS
    // Forbid usage of variables. Use let or const instead, ES6 style.
    'no-var': 2,
    // Avoid leaving behind console.log by marking them with warnings.
    'no-console': 1,
    // Forbid usage of restricted names such as NaN, Infinity, undefined, etc.
    'no-shadow-restricted-names': 2,
    // Forbid inexplicit declaration of global variables.
    // 'no-undef': [2, { typeof: true }],
  },
};
