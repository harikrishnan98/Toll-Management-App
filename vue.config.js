const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  publicPath: process.env.NODE_ENV === 'production'
  ? '/Toll-Management-App': '/',
  transpileDependencies: true,
  configureWebpack: {
    devtool: 'source-map'
  },
},
)
