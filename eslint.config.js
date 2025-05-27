// eslint.config.js
module.exports = {
  overrides: [
    {
      files: ["**/{aura,lwc}/**/*.js"],
      extends: [
        "eslint:recommended", // Base ESLint recommendations
        "@salesforce/eslint-config-lwc", // Salesforce-specific LWC rules
      ],
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
      },
      rules: {
        // Add custom rules or override defaults here if needed
      },
    },
  ],
};
