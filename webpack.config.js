const path = require('path');

const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
	mode: 'development',
	entry: {
		main: path.resolve(__dirname, 'client/src/main.js'),
		login: path.resolve(__dirname, 'client/src/login.js'),
	},
	output: {
		path: path.resolve(__dirname, 'priv/public/js'),
		filename: '[name].bundle.js'
	},
	module: {
		rules: [
			{
				test: /\.vue$/,
				loader: 'vue-loader',
			}
		],
	},
	plugins: [
		new VueLoaderPlugin()
	],
};
