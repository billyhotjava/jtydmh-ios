import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import IdentifierPlugin from './common/js/identifierplugin'
import IconCheck from './common/js/iconcheck.js'
import MintUI from 'mint-ui'
import 'mint-ui/lib/style.css'

import VConsole from 'vconsole';
import FastClick from 'fastclick'
import {
	Toast
} from 'mint-ui';

import Config from './common/js/config'
// import imgCache from './common/js/imgCache.js'
import {
	getRequest,
	postRequest,
	putRequest,
	deleteRequest,
	post,
	postFormRequest,
	postRequestQuery,
	postRequestNoDialog
} from './axiosConfig'
import Base from './common/js/base'

import Banner from './components/home/Banner'
import IconBtn from './components/home/IconBtn'
import SwiperVertical from './components/home/SwiperVertical'
import NavBar from './components/home/NavBar'
import VueDND from 'awe-dnd'
import GesturePassword from '@alitajs/gesture-password-vue';
import LyTab from '../packages/tab';
import VueIntro from 'vue-introjs';
import 'intro.js/introjs.css';
import Global from './common/css/global.css'
import {
	Tab,
	Tabs,
	Button,
	Calendar,
	PullRefresh,
	List,
	Cell,
	Field,
	Dialog,
	DropdownMenu,
	DropdownItem,
	Col,
	Row,
	Grid,
	GridItem,
	Image as VanImage,
	Divider,
	ImagePreview,
	Loading,
	Progress,
	Lazyload,
	Popup,
	Search,
	Switch,
	Popover
} from 'vant';
import 'vant/lib/index.css';
import VueQuillEditor from "vue-quill-editor";
import 'quill/dist/quill.core.css';
import 'quill/dist/quill.snow.css';
import 'quill/dist/quill.bubble.css';


Vue.prototype.$config = Config;
Vue.prototype.$getRequest = getRequest;
Vue.prototype.$postRequest = postRequest;
Vue.prototype.$putRequest = putRequest;
Vue.prototype.$deleteRequest = deleteRequest;
Vue.prototype.$postFormRequest = postFormRequest;
Vue.prototype.$postRequestQuery = postRequestQuery;
Vue.prototype.$postRequestNoDialog = postRequestNoDialog;
Vue.prototype.$base = Base;
Vue.prototype.$post = post;
Vue.prototype.$toast = Toast;
Vue.prototype.$global = Global;
Vue.prototype.$check = IconCheck;
Vue.prototype.bus = new Vue;


Vue.use(MintUI);
Vue.use(Banner);
Vue.use(IconBtn);
Vue.use(SwiperVertical);
Vue.use(NavBar);
Vue.use(VueDND);
Vue.use(GesturePassword);
Vue.use(LyTab);
Vue.use(VueIntro);
Vue.use(Tab);
Vue.use(Tabs);
Vue.use(Button);
Vue.use(Calendar);
Vue.use(PullRefresh);
Vue.use(List);
Vue.use(Cell);
Vue.use(Field);
Vue.use(Dialog);
Vue.use(DropdownMenu);
Vue.use(DropdownItem);
Vue.use(Col);
Vue.use(Row);
Vue.use(Grid);
Vue.use(GridItem);
Vue.use(VanImage);
Vue.use(Divider);
Vue.use(Progress);
Vue.use(Lazyload);
Vue.use(Popup);
Vue.use(Search);
Vue.use(Switch);
Vue.use(Popover);
Vue.use(VueQuillEditor, {
	placeholder: '请输入内容',
});
Vue.use(ImagePreview);
Vue.use(Loading);

//全局注册自定义指令
Vue.directive('exchangeHtml', {
	bind: function(el, foo) {
		console.log(el, foo)
		el.innerHTML += foo.value
	}
})

// 自定义埋点指令
Vue.directive('track', {
	//钩子函数，只调用一次，指令第一次绑定到元素时调用。在这里可以进行一次性的初始化设置
	/*
	 * el:指令所绑定的元素，可以用来直接操作 DOM
	 * binding：一个对象，包含以下 property:
	 *   name：指令名，不包括 v- 前缀。
	 *   value：指令的绑定值，例如：v-my-directive="1 + 1" 中，绑定值为 2。
	 *   expression：字符串形式的指令表达式。例如 v-my-directive="1 + 1" 中，表达式为 "1 + 1"。
	 *   arg：传给指令的参数，可选。例如 v-my-directive:foo 中，参数为 "foo"。
	 *   modifiers：一个包含修饰符的对象。例如：v-my-directive.foo.bar 中，修饰符对象为 { foo: true, bar: true }。
	 * vnode：Vue 编译生成的虚拟节点
	 */
	bind: (el, binding) => {
		if (binding.value) {
			//这里参数是根据自己业务可以自己定义
			let params = {
				currentUrl: binding.value.currentUrl,
				actionType: binding.value.actionType,
				frontTriggerType: binding.value.triggerType,
				behavior: binding.value.behavior,
				service: 'xxx',
			}
			//如果是浏览类型，直接保存
			if (binding.value.triggerType == 'browse') {
				//调用后台接口保存数据
				// api.eventTrack.saveEventTrack(params);
			} else if (binding.value.triggerType == 'click') {
				//如果是click类型，监听click事件
				el.addEventListener('click', () => {
					//调用后台接口保存数据
				}, false)
			}
			// 处理不上传日志信息
			let unuploadList = ['/home', '/zhiban', '/rb', '/weather', '/information'];
			if (unuploadList.indexOf(binding.value.currentUrl) > -1) {
				// console.log('黑名单不上传', binding.value.currentUrl);
				return;
			}
			postRequestNoDialog(`${Config.YDMH}log/save`, {
				content: JSON.stringify(binding.value),
				userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				userName: JSON.parse(localStorage.getItem('user')).fullName,
				logType: '2',
				operateType: '2',
				executionTime: Math.ceil(Math.random() * 10)
			}).then(res => {
				// console.log('日志接口调用成功 ', res);
			}).catch(err => {
				console.log('日志接口调用失败 ', err);
			});
		}
	}
})

// TODO: 增加资讯 Tabs keep-alive
router.afterEach((to, from, next) => {
	console.log('from.name', from.name);
	console.log('to.name', to.name);
	if (from.name == 'home' && to.name == 'zx') {
		console.log('进入 zx');
		Vue.prototype.bus.$emit('shouldReload');
	}
})

router.beforeEach((to, from, next) => {
	if (from.name == 'gv' && !store.getters.getGvcanBack) {
		if(to.name == 'login'){
			next();
		}else{
			next(false);
			console.log('拦截了');
		}
	} else {
		next();
	}
})

import * as utils from './utils'
/*注册工具*/
Object.keys(utils).forEach(k => Vue.prototype[k] = utils[k]);

Vue.config.productionTip = false;

if (typeof(cordova) === 'undefined') {

	new Vue({
		router,
		store,
		render: h => h(App)
	}).$mount('#app');

} else {
	document.addEventListener('deviceready', function() {
		// navigator.splashscreen.hide();
		// // StatusBar.backgroundColorByHexString("#ffffff");
		// if (cordova.platformId == 'android') {
		//     StatusBar.backgroundColorByHexString("#d9d9d9");
		// }
		// if (cordova.platformId == 'ios') {
		//     StatusBar.backgroundColorByHexString("#ffffff");
		//     IdentifierPlugin.getIden((message)=>{
		//         store.commit('changeDevice', {
		//             serial: message,
		//             platform: 'ios'
		//         });
		//     })
		// }

		/*解决ios按钮点击延迟问题*/
		if ('addEventListener' in document) {
			document.addEventListener('DOMContentLoaded', function() {
				FastClick.attach(document.body)
			}, false);
		}

		// vue vconsole日志调试
		// let vConsole = new VConsole();

		let vueInstance = new Vue({
			router,
			store,
			render: h => h(App)
		}).$mount('#app');

		let time;
		/*添加原生返回按钮的监听*/
		document.addEventListener("backbutton", function() {

			let pp = new Date() - time;

			let x = document.getElementById('exit');
			if (x) {
				if (pp < 2000) {
					navigator.app.exitApp();
				} else {
					Toast({
						message: '再按一次退出应用',
						position: 'bottom',
						duration: 2000
					});
					time = new Date()
				}
			} else {
				vueInstance.$router.back()
			}

		}, false);
	}, false);
}
