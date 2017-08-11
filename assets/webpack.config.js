/*
 * Modules
 **/
const path = require("path");
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const elmSource = __dirname + "/elm";
// const CopyWebpackPlugin = require("copy-webpack-plugin");
// const autoprefixer = require("autoprefixer");

module.exports = {
    entry: [
        __dirname + "/js/app.js",
        __dirname + "/css/app.scss",
    ],
    output: {
        // TODO output needs to go to /priv/static see https://github.com/odiumediae/webpacker/blob/master/assets/webpack.config.js
        path: path.resolve(__dirname, "../priv/static"),
        filename: "js/app.js",
        publicPath: 'http://localhost:4000/'
    },
    module: {
        loaders: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                loader: "babel-loader",
                query: {
                    presets: ["es2015"],
                },
            },
            {
                test: /\.css$/,
                loader: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: 'css-loader'
                }),
            },
            {
                test: /\.scss$/,
                loader: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: "css-loader!sass-loader",
                }),
            },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: "elm-webpack-loader?forceWatch=true&cwd=" + elmSource,
            },
        ],
        noParse: [/\.elm$/],
    },
    plugins: [
        new ExtractTextPlugin("css/app.css"),
    ],
    resolve: {
        modules: [
            "node_modules",
            __dirname + "/js",
        ],
        extensions: [".js", ".elm", ".scss", ".css"],
    },
};
