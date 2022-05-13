module.exports = {
  plugins: [
    require('autoprefixer'),
    require('postcss-selector-not').default,
    require('postcss-gap')({ method: 'duplicate' }),
    require('cssnano'),
  ]
}
