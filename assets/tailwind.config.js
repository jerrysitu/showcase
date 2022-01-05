module.exports = {
  content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss-neumorphism"),
  ],
};
