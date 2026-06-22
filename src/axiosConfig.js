//配置axios
import {
	Toast
} from 'mint-ui';
import axios from 'axios';
import router from './router'
import store from './store'
import {
	getQueryUrl
} from './common/js/base'
import {
	Indicator
} from 'mint-ui';
import qs from 'qs';
axios.defaults.baseURL = '';
axios.defaults.timeout = 10000;
axios.defaults.params = {};
axios.defaults.withCredentials = true; // axios 默认不发送cookie，需要全局设置true发送cookie
// 重试次数，共请求2次
axios.defaults.retry = 3;
// 请求的间隙
axios.defaults.retryDelay = 1000;
/** 添加请求拦截器 */
axios.interceptors.request.use((config) => {
	// 发送请求之前
	// let user = store.getters.getUser;
	let user = JSON.parse(localStorage.getItem('user'));
	if (user && user.token) {
		config.headers.token = user.token; //将token放到请求头发送给服务器
	}
	let uniqueCode = localStorage.getItem('uniqueCode');
	if (uniqueCode) {
		config.headers.uniqueCode = uniqueCode;
	}
	return config;
}, (error) => {
	// 请求错误
	console.log(error);
	// Toast(error);
	Toast({
		message: res.data.msg,
		className: 'inexa'
	});
	return Promise.reject(error);
});

/** 添加响应拦截器 */
axios.interceptors.response.use(res => {
	// console.log(res);
	if (res.data.success && res.data.success == true) {
		return res.data;
	} else if (res.data.errorCode == 'notLogin' || res.data.errorCode == 'notAuth') {
		console.log('token认证失败');
		Toast({
			message: '登录信息已过期，请重新认证',
			className: 'inexa'
		});
		SSLVPNPlugin.logoutVPN();
		router.replace('/login')
	} else if (res.data && res.data.success == undefined) {
		return res;
	} else if (res.data == null || res.data == undefined || res.data == '') {
		Toast({
			message: '接口访问失败，请退出重试',
			className: 'inexa'
		});
	} else {
		Toast({
			message: res.data.msg != null && res.data.msg != '' ? res.data.msg : '接口访问失败，请退出重试',
			className: 'inexa'
		});
		return Promise.reject(res.data.msg);
	}
}, err => {
	var config = err.config;
	// 如果配置不存在或未设置重试选项，则拒绝
	if (!config || !config.retry) return Promise.reject(err);

	// 设置变量以跟踪重试次数
	config.__retryCount = config.__retryCount || 0;

	// 判断是否超过总重试次数
	if (config.__retryCount >= config.retry) {
		// 返回错误并退出自动重试
		return Promise.reject(err);
	}

	// 增加重试次数
	config.__retryCount += 1;

	//打印当前重试次数
	console.log(config.url + ' 自动重试第' + config.__retryCount + '次');

	// 创建新的Promise
	var backoff = new Promise(function(resolve) {
		setTimeout(function() {
			resolve();
		}, config.retryDelay || 1);
	});

	// 返回重试请求
	return backoff.then(function() {
		return axios(config);
	});
});

/** get请求 */
export const getRequest = (url, params) => {
	return new Promise((resolve, reject) => {
		Indicator.open({
			text: '正在加载...',
			spinnerType: 'triple-bounce'
		});
		axios.get(url, {
			params: params
		}).then((response) => {
			resolve(response);
			Indicator.close();
		}).catch((error) => {
			reject(error);
			Indicator.close();
		});
	});
};

/** get请求(序列化) */
export const getRequestStringify = (url, params) => {
	return new Promise((resolve, reject) => {
		Indicator.open({
			text: '正在加载...',
			spinnerType: 'triple-bounce'
		});
		axios.get(url + '?' + qs.stringify(params)).then((response) => {
			resolve(response);
			Indicator.close();
		}).catch((error) => {
			reject(error);
			Indicator.close();
		});
	});
};

/** post请求 */
export const postRequest = (url, params) => {
	return new Promise((resolve, reject) => {
		Indicator.open({
			text: '正在加载...',
			spinnerType: 'triple-bounce'
		});
		axios.post(url, params).then((response) => {
			resolve(response);
			Indicator.close();
		}).catch((error) => {
			reject(error);
			Indicator.close();
		});
	});
};

export const postRequestNoDialog = (url, params) => {
	return axios({
		method: 'post',
		url: url,
		data: params,
	});
};

/** post请求(query) */
export const postRequestQuery = (url, params) => {
	return new Promise((resolve, reject) => {
		Indicator.open({
			text: '正在加载...',
			spinnerType: 'triple-bounce'
		});
		axios.post(getQueryUrl(url, params)).then((response) => {
			resolve(response);
			Indicator.close();
		}).catch((error) => {
			reject(error);
			Indicator.close();
		});
	});
};

/** post请求 */
export const postFormRequest = (url, params) => {
	return new Promise((resolve, reject) => {
		Indicator.open({
			text: '正在加载...',
			spinnerType: 'triple-bounce'
		});
		axios.post(url, params,
			{
            	transformRequest: function(data) {
                    let ret = '';
                    for (let it in data) {
                        ret += encodeURIComponent(it) + '=' + encodeURIComponent(data[it]) + '&'
                    }
                    ret = ret.substring(0, ret.lastIndexOf('&'));
                    return ret
                }
            },
			{
				headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
				}
			}).then((response) => {
			resolve(response);
			Indicator.close();
		}).catch((error) => {
			reject(error);
			Indicator.close();
		});
	});
};

/** put请求 */
export const putRequest = (url, params) => {
	return new Promise((resolve, reject) => {
		Indicator.open({
			text: '正在加载...',
			spinnerType: 'triple-bounce'
		});
		axios.put(url, params).then((response) => {
			resolve(response);
			Indicator.close();
		}).catch((error) => {
			reject(error);
			Indicator.close();
		});
	});
};

/** delete请求 */
export const deleteRequest = (url, params) => {
	return new Promise((resolve, reject) => {
		Indicator.open({
			text: '正在加载...',
			spinnerType: 'triple-bounce'
		});
		axios.delete(url, params).then((response) => {
			resolve(response);
			Indicator.close();
		}).catch((error) => {
			reject(error);
			Indicator.close();
		});
	});
};

/** delete请求 */
export const postFormRequestForDelete = (url, params) => {
    return new Promise((resolve, reject) => {
        Indicator.open({
            text: '正在加载...',
            spinnerType: 'triple-bounce'
        });
        axios.post(url, params,
            {
                transformRequest: function(data) {
                    let ret = '';
                    for (let it in data) {
                        ret += encodeURIComponent(it) + '=' + encodeURIComponent(data[it]) + '&'
                    }
                    ret = ret.substring(0, ret.lastIndexOf('&'));
                    return ret
                }
            },
            {
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            }).then((response) => {
            resolve(response);
            Indicator.close();
        }).catch((error) => {
            reject(error);
            Indicator.close();
        });
    });

	// return axios({
	// 	method: 'post',
	// 	url: url,
	// 	// data: JSON.stringify(params),
	// 	data: params,
	// 	transformRequest: [
	// 		function(data) {
	// 			let ret = ''
	// 			for (let it in data) {
	// 				if (Array.isArray(data[it])) {
	// 					let array = data[it];
	// 					for (let i = 0; i < array.length; i++) {
	// 						ret += encodeURIComponent(it) + '=' + encodeURIComponent(array[i]) + '&'
	// 					}
	// 				} else {
	// 					ret += encodeURIComponent(it) + '=' + encodeURIComponent(data[it]) + '&'
	// 				}
	// 			}
	// 			ret = ret.substring(0, ret.lastIndexOf('&'));
	// 			return ret
	// 		}
	// 	],
	// 	headers: {
	// 		'Content-Type': 'application/x-www-form-urlencoded'
	// 	}
	// });
};
