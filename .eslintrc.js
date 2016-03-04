module.exports = {
  'parser': 'babel-eslint',
  'extends': [
    './config/eslint/react-rules.js',
    './config/eslint/best-practices.js',
    './config/eslint/other-rules.js',
  ],
  "plugins": [
    "react"
  ],
  'parserOptions': {
    'ecmaFeatures': {
      'arrowFunctions': true,
      'blockBindings': true,
      'classes': true,
      'defaultParams': true,
      'destructuring': true,
      'forOf': true,
      'generators': false,
      'modules': true,
      'objectLiteralComputedProperties': true,
      'objectLiteralDuplicateProperties': false,
      'objectLiteralShorthandMethods': true,
      'objectLiteralShorthandProperties': true,
      'restParams': true,
      'spread': true,
      'superInFunctions': true,
      'templateStrings': true,
      'jsx': true,
    },
    'ecmaVersion': 7,
    'sourceType': 'module',
    env: {
      node: 'true',
      jest: 'true'
    }
  }
}
