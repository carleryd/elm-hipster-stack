const ExtractTextPlugin = require("extract-text-webpack-plugin");
const elmSource = __dirname + "/static/elm";

module.exports = {
    entry: [
        __dirname + "/static/js/app.js",
        __dirname + "/static/css/app.scss",
    ],
    output: {
        path: __dirname + "/priv/static",
        filename: "js/app.js",
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
            __dirname + "/static/js",
        ],
        extensions: [".js", ".elm", ".scss", ".css"],
    },
};
