const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Noto Sans JP', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    backgroundColor: ['responsive', 'odd', 'hover', 'focus'],
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
