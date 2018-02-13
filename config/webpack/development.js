const environment = require('./environment')

module.exports = environment.toWebpackConfig()


const config = environment.toWebpackConfig()

config.resolve.alias = {
    vue: "vue/dist/vue.js"
}

// export the updated config
module.exports = config;
