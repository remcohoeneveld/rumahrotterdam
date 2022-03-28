const colors = require('tailwindcss/colors')

module.exports = {
  darkMode: "class",
  content: ["**/*.twig"],
  theme: {
    colors: {
      rumah: {
        "50": "#FBEDEA",
        "100": "#F6DAD5",
        "200": "#EFB9AE",
        "300": "#E69484",
        "400": "#DF735E",
        "500": "#D64E33",
        "600": "#B23C24",
        "700": "#842C1A",
        "800": "#591E12",
        "900": "#2A0E09"
      },
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.gray,
      emerald: colors.emerald,
      indigo: colors.indigo,
      yellow: colors.yellow,
      green: colors.green,
      blue: colors.blue,
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
};
