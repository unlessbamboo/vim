/*
 * 参考: https://www.sunzhongwei.com/vim-editor-javascript-using-eslint-for-syntax-checking-when-saving?from=bottom
 */

module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es2021: true,
  },
  extends: "plugin:vue/vue3-essential",
  overrides: [],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: "latest",
  },
  plugins: ["vue", "@typescript-eslint"],
  rules: {},
};
