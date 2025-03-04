import globals from "globals";
import pluginJs from "@eslint/js";
import tsEslint from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";
import angularPlugin from "@angular-eslint/eslint-plugin";

/** @type {import('eslint').Linter.FlatConfig[]} */
export default [
  {
    files: ["**/*.{js,mjs,cjs,ts}"],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        project: "./tsconfig.json", // Ensure this points to your tsconfig
      },
      globals: globals.browser,
    },
    plugins: {
      "@typescript-eslint": tsEslint,
      "@angular-eslint": angularPlugin,
    },
    rules: {
      ...(pluginJs.configs.recommended?.rules || {}),
      ...(tsEslint.configs.recommended?.rules || {}),
      ...(angularPlugin.configs.recommended?.rules || {}),

      // Custom rules
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "@typescript-eslint/no-explicit-any": "warn",
      "no-console": "warn",
      "@angular-eslint/component-selector": [
        "error",
        {
          type: "element",
          prefix: "app",
          style: "kebab-case",
        },
      ],
    },
  },
  {
    files: ["*.html"],
    plugins: {
      "@angular-eslint/template": angularPlugin,
    },
    rules: {
      ...(angularPlugin.configs["recommended--extra"]?.rules || {}),
    },
  },
];
