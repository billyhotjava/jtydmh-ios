const CompressionWebpackPlugin = require('compression-webpack-plugin');

module.exports = {
    // 基本路径
    productionSourceMap: false,
    publicPath: '',
    // 输出文件目录
    // outputDir: '',
    devServer: {
        host: "0.0.0.0",
        port: 8080,
        https: false,
        open: true,
        proxy: {
            "/ip1": {
                // target: "http://localhost:8080/",
                target: "http://localhost:8082/",
                // target: "http://10.150.104.44/api/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ip1': '/'
                },
            },
            "/ip2": {
                // target: "https://ydmh.eccl.net.cn:6443/api/ydmh/",
                target: "http://10.150.104.47:8800/api/ydmh/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ip2': '/'
                },
            },
            "/ip3": {
                // target: "https://ydmh.eccl.net.cn:6443/api/file/",
                target: "http://10.150.104.47:8765/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ip3': '/'
                },
            },
            "/ip4": {
                // target: "https://ydmh.eccl.net.cn:6443/api/uia/",
                target: "http://10.150.104.47:8800/api/uia/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ip4': '/'
                },
            },
            "/ip5": {
                // target: "https://ydmh.eccl.net.cn:6443/api/ydmh/",
                target: "http://10.150.104.47:8800/api/ydmh/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ip5': '/'
                },
            },

            "/ip6": {
                target: "http://10.150.104.69/api/jtdgdw/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ip6': '/'
                },
            },

            "/ydmh": {
                // target: "http://localhost:8082/",
                target: "https://mgs.sgeg.chnenergy.com.cn/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ydmh': '/'
                },
            },
            "/ydmhoutline": {
                target: "http://10.150.104.86:30013/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/ydmhoutline': '/'
                },
            },
            "/api/file": {
                // target: "http://10.150.104.86:30004/",
                target: "http://mhfile.sgeg.ceic.com/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '^/api/file': '/'
                },
            },
            "/idxUrl": {
                // target: "http://10.150.104.86:30012/",
                target: "https://mgs.sgeg.chnenergy.com.cn/",
                ws: false,
                changeOrigin: true,
                pathRewrite: {
                    '/idxUrl': '/'
                }
            },
        }
    },
    // 警告 webpack 的性能提示
    // configureWebpack: {
    //     performance: {
    //         hints: 'warning',
    //         //入口起点的最大体积 整数类型（以字节为单位）
    //         maxEntrypointSize: 50000000,
    //         //生成文件的最大体积 整数类型（以字节为单位 300k）
    //         maxAssetSize: 30000000,
    //         //只给出 js 文件的性能提示
    //         assetFilter: function (assetFilename) {
    //             return assetFilename.endsWith('.js');
    //         }
    //     }
    // }
    configureWebpack: {
        module: {
            rules: [{
                test: /\.less$/,
                use: [{
                    loader: 'style-loader',
                }, {
                    loader: 'css-loader',
                }, {
                    loader: 'less-loader',
                    options: {
                        javascriptEnabled: true,
                    },
                }],
            }],
        },
    },
    // runtimeCompiler: true
    // chainWebpack: config => {
    //     // 生产环境，开启js\css压缩
    //     if (process.env.NODE_ENV === "production") {
    //         config.plugin("compressionPlugin").use(
    //             new CompressionWebpackPlugin({
    //                 test: /\.(js|css|less)$/, // 匹配文件名
    //                 threshold: 10240, // 对超过10k的数据压缩
    //                 minRatio: 0.8,
    //                 deleteOriginalAssets: true // 删除源文件
    //             })
    //         );
    //     }
    // }
};