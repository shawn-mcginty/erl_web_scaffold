'use strict';

const Vue = require('./utils/vueLoader');
import LoginForm from './comp/LoginForm.vue';

const vm = new Vue({
	el: '#login',
	data: {},
	components: {
		LoginForm,
	},
});
