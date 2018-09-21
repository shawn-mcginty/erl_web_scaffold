'use strict';

let Vue;

if (process.env.NODE_ENV !== 'production') {
	Vue = require('vue/dist/vue.common.js');
} else {
	Vue = require('vue');
}

module.exports = Vue;