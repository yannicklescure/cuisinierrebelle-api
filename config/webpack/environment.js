// config/webpack/environment.js

// import(/* webpackPreload: true */ "material-icons/iconfont/MaterialIcons-Regular.woff2")
// import(/* webpackPreload: true */ "@fortawesome/fontawesome-free/webfonts/fa-solid-900.woff2")

const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

const dotenv = require('dotenv')

const dotenvFiles = [
  `.env.${process.env.NODE_ENV}.local`,
  '.env.local',
  `.env.${process.env.NODE_ENV}`,
  '.env',
]
dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true })
})

// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules')

// Bootstrap 4 has a dependency over jQuery & Popper.js:
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

environment.config.merge()

// const Critters = require('critters-webpack-plugin');

// environment.plugins.append('critters',
//   new Critters({
//     // Outputs: <link rel="preload" onload="this.rel='stylesheet'">
//     preload: 'swap',

//     // Don't inline critical font-face rules, but preload the font URLs:
//     preloadFonts: true
//   })
// );

const UglifyJsPlugin = require("uglifyjs-webpack-plugin")
// environment.plugins.delete("UglifyJs")
// environment.plugins.append("UglifyJs", new UglifyJsPlugin())
environment.config.set('optimization.minimizer', [new UglifyJsPlugin()]);

const CompressionPlugin = require('compression-webpack-plugin');

environment.plugins.append('compression',
  new CompressionPlugin({
    // asset: "[path].gz[query]",
    algorithm: "gzip",
    test: /\.(js|css)$/,
    threshold: 10240,
    minRatio: 0.8
  })
);

// config/webpack/environment.js
const splitChunks = require('./split_chunks')
const WebpackAssetsManifest = require('webpack-assets-manifest')

environment.config.merge(splitChunks)

// Should override the existing manifest plugin
environment.plugins.insert(
  'Manifest',
  new WebpackAssetsManifest({
    entrypoints: true, // default in rails is false
    writeToDisk: true, // rails defaults copied from webpacker
    publicPath: true // rails defaults copied from webpacker
  })
)

// environment.splitChunks((config) => Object.assign({}, config, {
//   optimization: {
//     splitChunks: {
//       chunks: 'all',
//       // minSize: 20000,
//       // // minRemainingSize: 0,
//       // maxSize: 30000,
//       // minChunks: 1,
//       // maxAsyncRequests: 30,
//       // maxInitialRequests: 30,
//       // automaticNameDelimiter: '~',
//       // enforceSizeThreshold: 50000,
//       // cacheGroups: {
//       //   defaultVendors: {
//       //     test: /[\\/]node_modules[\\/]/,
//       //     priority: -10
//       //   },
//       //   default: {
//       //     minChunks: 2,
//       //     priority: -20,
//       //     reuseExistingChunk: true
//       //   }
//       // }
//     }
//   }
// }))
// environment.splitChunks()

// // Get the actual sass-loader config
// const sassLoader = environment.loaders.get('sass')
// const sassLoaderConfig = sassLoader.use.find(function(element) {
//   return element.loader == 'sass-loader'
// })

// // Use Dart-implementation of Sass (default is node-sass)
// const options = sassLoaderConfig.options
// options.implementation = require('sass')

const sassLoader = require('./sass_loader')
environment.config.merge(sassLoader)

module.exports = environment
