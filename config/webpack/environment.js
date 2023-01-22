const {environment} = require('@rails/webpacker')
const webpack = require('webpack')
environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'startbootstrap-sb-admin-2/vendor/jquery/jquery',
        'window.jQuery': 'jquery',
        Popper: ['popper.js', 'default'],
        Trix: "trix",
        Rails: '@rails/ujs'
    })
)

environment.config.merge(
    module.exports = {
        resolve: {
            alias: {
                jquery: 'startbootstrap-sb-admin-2/vendor/jquery/jquery',
            }
        }
    }
)
module.exports = environment
