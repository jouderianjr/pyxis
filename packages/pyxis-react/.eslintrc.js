/* jshint node: true */
module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: ['plugin:react/recommended', 'airbnb', 'plugin:@typescript-eslint/recommended', 'plugin:storybook/recommended'],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaFeatures: {
      jsx: true
    },
    ecmaVersion: 12,
    sourceType: 'module'
  },
  plugins: ['jest', 'react', 'react-hooks', '@typescript-eslint'],
  rules: {
    '@typescript-eslint/no-empty-function': 'off',
    '@typescript-eslint/no-shadow': ['error'],
    '@typescript-eslint/no-use-before-define': ['error'],
    'import/extensions': ['error', 'ignorePackages', {
      ts: 'never',
      tsx: 'never'
    }],
    'jsx-a11y/label-has-associated-control': 'off',
    'max-len': ['error', {
      code: 130
    }],
    'no-shadow': 'off',
    'no-use-before-define': 'off',
    'react-hooks/exhaustive-deps': 'warn',
    'react-hooks/rules-of-hooks': 'error',
    'react/button-has-type': 'off',
    'react/jsx-filename-extension': ['warn', {
      extensions: ['.tsx']
    }],
    'react/jsx-props-no-spreading': 'off',
    'react/jsx-sort-props': [1],
    'react/prop-types': 'off',
    'react/react-in-jsx-scope': 'off',
    'react/require-default-props': 'off'
  },
  settings: {
    'import/resolver': {
      typescript: {
        extensions: ['.ts', '.tsx']
      }
    }
  }
};