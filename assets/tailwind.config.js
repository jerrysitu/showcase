const colors = require("tailwindcss/colors");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  purge: {
    enabled: process.env.MIX_ENV === "prod",
    content: ["../lib/**/*.eex", "../lib/**/*.leex", "../lib/**/*.ex"],
    options: {
      whitelist: [],
    },
  },
  darkmode: false,
  extend: {},
  theme: {
    filter: {
      // defaults to {}
      none: "none",
      grayscale: "grayscale(1)",
      invert: "invert(1)",
      sepia: "sepia(1)",
    },
    backdropFilter: {
      // defaults to {}
      none: "none",
      blur: "blur(20px)",
    },
    extend: {
      fontFamily: {
        sans: ['"Inter"', defaultTheme.fontFamily.sans],
      },
      maxHeight: {
        "(screen-36)": "calc(100vh - 9rem)",
        "(screen-32)": "calc(100vh - 8rem)",
        "(screen-28)": "calc(100vh - 7rem)",
        "(screen-24)": "calc(100vh - 6rem)",
        "(screen-12)": "calc(100vh - 3rem)",
        "(screen-16)": "calc(100vh - 4rem)",
        "(screen-60vh)": "calc(100vh - 60vh)", //40%
        "(screen-1/3)": "calc(100vh - 66vh)", //33%
        "(screen-1/2)": "calc(100vh - 50vh)", //50%
        "(screen-2/3)": "calc(100vh - 33vh)", //66%
        "(screen-2/3-8rem)": "calc(100vh - 33vh - 8rem)",
        "(screen-2/3-9rem)": "calc(100vh - 33vh - 9rem)",
        "(screen-2/3-10rem)": "calc(100vh - 33vh - 10rem)",
        "(screen-2/3-11rem)": "calc(100vh - 33vh - 11rem)",
        "(screen-2/3-12rem)": "calc(100vh - 33vh - 12rem)",
        "(screen-2/3-13rem)": "calc(100vh - 33vh - 13rem)",
        "(screen-2/3-14rem)": "calc(100vh - 33vh - 14rem)",
        "(screen-2/3-15rem)": "calc(100vh - 33vh - 15rem)",
        "(screen-2/3-16rem)": "calc(100vh - 33vh - 16rem)",
        "(screen-2/3-17rem)": "calc(100vh - 33vh - 17rem)",
        "(screen-1/3-14rem)": "calc(100vh - 66vh - 14rem)",
        "(screen-3/4)": "calc(100vh - 25vh)", //75%
        "(screen-3/5)": "calc(100vh - 40vh)", //60%
        "(screen-14rem)": "calc(100vh - 14rem)",
      },
      height: {
        "(screen-24)": "calc(100vh - 6rem)",
        "(screen-12)": "calc(100vh - 3rem)",
        "(screen-16)": "calc(100vh - 4rem)",
        "(screen-1/2)": "calc(100vh - 50vh)",
        "(screen-14rem)": "calc(100vh - 14rem)",
        "(screen-1/2-4rem)": "calc(100vh - 50vh - 4rem)",
        "(screen-1/2-6rem)": "calc(100vh - 50vh - 6rem)",
        "(screen-1/2-8rem)": "calc(100vh - 50vh - 8rem)",
        "(screen-1/2-10rem)": "calc(100vh - 50vh - 10rem)",
        "(screen-1/2-12rem)": "calc(100vh - 50vh - 12rem)",
        "(screen-1/2-14rem)": "calc(100vh - 50vh - 14rem)",
        "(screen-1/2-16rem)": "calc(100vh - 50vh - 16rem)",
        "(screen-2/3-8rem)": "calc(100vh - 33vh - 8rem)",
        "(screen-2/3-9rem)": "calc(100vh - 33vh - 9rem)",
        "(screen-2/3-10rem)": "calc(100vh - 33vh - 10rem)",
        "(screen-2/3-11rem)": "calc(100vh - 33vh - 11rem)",
        "(screen-2/3-12rem)": "calc(100vh - 33vh - 12rem)",
        "(screen-2/3-13rem)": "calc(100vh - 33vh - 13rem)",
        "(screen-2/3-14rem)": "calc(100vh - 33vh - 14rem)",
        "(screen-2/3-15rem)": "calc(100vh - 33vh - 15rem)",
        "(screen-2/3-16rem)": "calc(100vh - 33vh - 16rem)",
        "(screen-2/3-17rem)": "calc(100vh - 33vh - 17rem)",
        "(screen-1/3-14rem)": "calc(100vh - 66vh - 14rem)",
        "(screen-1/3)": "calc(100vh - 66vh)",
        "(screen-2/3)": "calc(100vh - 33vh)",
      },
      maxWidth: {
        "8xl": "88rem",
        "9xl": "96rem",
        "10xl": "104rem",
        "screen-3xl": "1920px",
      },
      fontSize: {
        xxs: "0.50rem",
      },
      inset: {
        13: "3.25rem",
        14: "3.50rem",
        15: "3.75rem",
        16: "4.00rem",
        17: "4.25rem",
        18: "4.50rem",
        19: "4.75rem",
        20: "5.00rem",
      },
      colors: {
        darkGreen: "#1D272B",
        "light-green": "#f1f5f4",
        blueGray: colors.blueGray,
        coolGray: colors.coolGray,
        gray: colors.gray,
        trueGray: colors.trueGray,
        warmGray: colors.warmGray,
        red: colors.red,
        orange: colors.orange,
        amber: colors.amber,
        yellow: colors.yellow,
        lime: colors.lime,
        green: colors.green,
        emerald: colors.emerald,
        teal: colors.teal,
        cyan: colors.cyan,
        lightBlue: colors.lightBlue,
        blue: colors.blue,
        indigo: colors.indigo,
        violet: colors.violet,
        purple: colors.purple,
        fuchsia: colors.fuchsia,
        pink: colors.pink,
        rose: colors.rose,
      },
      screens: {
        "2xl": "1366px",
        "3xl": "1800px",
      },
      spacing: {
        128: "32rem",
        144: "36rem",
      },
      transitionDuration: {
        2000: "2000ms",
        2500: "2500ms",
        3000: "3000ms",
      },
    },
  },
  variants: {
    filter: ["responsive"], // defaults to ['responsive']
    backdropFilter: ["responsive"], // defaults to ['responsive']
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("tailwindcss-filters"),
    require("kutty"),
  ],
};
