module.exports = {
  root: true,
  env: { 
    browser: true, 
    es2022: true,
    node: true
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react/jsx-runtime',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    'plugin:import/recommended',
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs', 'coverage'],
  parserOptions: { 
    ecmaVersion: 2022,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true
    }
  },
  settings: { 
    react: { version: '18.2' },
    'import/resolver': {
      node: {
        extensions: ['.js', '.jsx', '.ts', '.tsx']
      }
    }
  },
  plugins: ['react-refresh', 'jsx-a11y', 'import'],
  rules: {
    // React rules
    'react-refresh/only-export-components': [
      'warn',
      { allowConstantExport: true },
    ],
    'react/prop-types': 'off',
    'react/jsx-key': 'error',
    'react/jsx-no-duplicate-props': 'error',
    'react/jsx-no-undef': 'error',
    'react/no-array-index-key': 'warn',
    'react/no-unused-state': 'warn',
    
    // JavaScript rules
    'no-unused-vars': 'warn',
    'no-console': ['warn', { allow: ['warn', 'error'] }],
    'prefer-const': 'error',
    'no-var': 'error',
    
    // Import rules
    'import/order': ['error', {
      groups: ['builtin', 'external', 'internal', 'parent', 'sibling', 'index'],
      'newlines-between': 'always'
    }],
    'import/no-unresolved': 'error',
    'import/no-duplicates': 'error',
    
    // Accessibility rules
    'jsx-a11y/click-events-have-key-events': 'warn',
    'jsx-a11y/no-static-element-interactions': 'warn',
    'jsx-a11y/alt-text': 'warn',
    'jsx-a11y/no-autofocus': 'warn'
  },
  overrides: [
    {
      files: ['**/*.test.{js,jsx}', '**/*.spec.{js,jsx}'],
      env: {
        jest: true
      },
      extends: ['plugin:testing-library/react'],
      plugins: ['testing-library'],
      rules: {
        'no-console': 'off'
      }
    }
  ]
}
