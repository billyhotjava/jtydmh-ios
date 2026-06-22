<template>
	<div id="app">
		<transition :name="transitionName">
			<keep-alive :include="keepAlive">
				<router-view class="transition-body" />
			</keep-alive>
		</transition>
	</div>
</template>

<script>
	import Watermark from '@/common/js/watermark'; //路径不要写错
	export default {
		name: 'app',
		data() {
			return {
				transitionName: 'fold-left',
				// Fixed: 增加资讯 Tabs keep-alive
				keepAlive: ['Home', 'Tab1', 'Tab2', 'Tab3', 'Tab4', 'DutyInfo', 'Zx'],
				loginStatus: false,
			}
		},
		mounted() {
			let that = this;
			window.authGest = this.authGest;
			window.messageJump = this.messageJump;
			let user = JSON.parse(localStorage.getItem('user'));
			let waterName = '';
			let waterPhone = '';
			if (user) {
				console.log(user);
				waterName = user.fullName;
				waterPhone = user.telephoneNumber;
				console.log(user.telephoneNumber);
				Watermark.set(waterName, waterPhone);
			} else {
				Watermark.set('国神公司', '');
			}
			this.bus.$on('loginSuccess', function(success) {
				if (success) {
				  // iOS 修改状态栏颜色
          if (window.device.platform == 'iOS') {
            console.log('App 调整状态栏颜色');
            StatusBar.backgroundColorByHexString('#3072E2');
          }
					that.loginStatus = true;
					let user = JSON.parse(localStorage.getItem('user'));
					console.log(user);
					waterName = user.fullName;
					waterPhone = user.telephoneNumber;
					console.log(user.telephoneNumber);
					Watermark.set(waterName, waterPhone);
				} else {
					that.loginStatus = false;
					waterName = '';
					waterPhone = '';
					Watermark.set('国神公司', '');
				}
			});
			if (localStorage.getItem('login') == '1' && localStorage.getItem('intro') == '1') {
				this.$router.replace('/loading');
			} else {
				localStorage.setItem('login', '1');
				localStorage.setItem('intro', '0');
				this.$router.replace('/guide');
			}
			// localStorage.setItem('deviceType', '1');
			// localStorage.setItem('uniqueCode', '3994abdd8975ad32');
			// localStorage.setItem('jgPushId', '18171adc03d43fce68b');

			// console.log("设备信息 Start");
			// console.log('uuid: ' + window.device.uuid); // uuid: 973EF811-7202-4002-8CBF-4B49411DD0B6
			// console.log('platform: ' + window.device.platform); // platform: iOS
			// console.log('manufacturer: ' + window.device.manufacturer); // manufacturer: Apple
			// console.log('model: ' + window.device.model); // model: iPhone7,1
			// console.log('version: ' + window.device.version); // system version: 12.4.3
			// console.log('cordova: ' + window.device.cordova); // cordova: 4.5.5
			// console.log('极光ID: ' + window.device.JPushRegistrationID); // 极光ID: 18171adc03d43fce68b
			// console.log("设备信息 End");
		},
		computed: {
			keepAlive() {
				return this.$store.getters.getKeepAlive
			}
		},
		methods: {
			authGest() {
				console.log('收到跳转通知了' + this.loginStatus);
				let hadGesturePassword = localStorage.getItem('isGesturePwd');
				console.log('是否存在手势密码', hadGesturePassword);
				if (hadGesturePassword == '1' && this.loginStatus) {
					this.$store.commit('changegvback', false);
					this.$router.push({
						name: 'gv',
						params: {
							type: 1
						}
					});
				}
        // iOS 重置手势密码时间统计
        if (window.device.platform == 'iOS') {
          NotificationPlugin.resetGestureVerifyTime(onSuccess, onFail);
          function onSuccess(result) {
            console.log(result);
          }
          function onFail() {

          }
        }
			},
			messageJump(appDetail, needGest) {
				console.log('收到跳转消息了：' + JSON.stringify(appDetail));
				console.log('需不需要验证手势密码：' + needGest);
        let hadGesturePassword = localStorage.getItem('isGesturePwd');
        console.log('是否存在手势密码', hadGesturePassword);
				if (this.loginStatus) {
					if (needGest && hadGesturePassword == '1') {
						this.$store.commit('changegvback', false);
						this.$router.push({
							name: 'gv',
							params: {
								type: 2,
								info: appDetail.appInfo,
								param: appDetail.appParam
							}
						});
            if (window.device.platform == 'iOS') {
              NotificationPlugin.resetGestureVerifyTime(onSuccess, onFail);
              function onSuccess(result) {
                console.log(result);
              }
              function onFail() {

              }
            }
					} else {
						let info = JSON.parse(appDetail.appInfo);
						let param = JSON.parse(appDetail.appParam);
						// let appDetail = JSON.parse(appinfo);
						if (info.name == '生产日报') {
							this.$router.push({
								name: param.url,
								params: {
									sendDay: param.data
								}
							});
						} else if (info.name == '手机报') {
							this.$router.push({
								name: param.url,
								params: {
									id: param.id,
									isLoadLocalData: false,
								}
							});
						} else {

						}
					}
				} else {

				}
			},
		},
		watch: {
			$route(to, from) {
				//如果to的索引值为0，不添加任何动画；如果to索引大于from索引,判断为前进状态,反之则为后退状态
				if (to.meta.index > 0) {
					if (to.meta.index < from.meta.index) {
						this.transitionName = 'fold-right';

					} else if (to.meta.index === from.meta.index) {
						this.transitionName = '';

					} else {
						this.transitionName = 'fold-left';
					}
				} else if (to.meta.index === 0 && from.meta.index > 0) {
					this.transitionName = 'fold-right';
				}

				if (to.name == 'searchbook' && from.name == 'home') {
					let list = this.$store.getters.getKeepAlive;
					list.push('SearchBook');
					this.$store.commit('changeKeepAlive', list);
				}

				if ((to.name == 'home' && from.name == 'searchbook') ||
					(to.name == 'home' && from.name == 'store') ||
					(to.name == 'home' && from.name == 'notice')) {
					let list = this.$store.getters.getKeepAlive;
					list.pop();
					this.$store.commit('changeKeepAlive', list);
				}

				if (to.name == 'store' && from.name == 'home') {
					let list = this.$store.getters.getKeepAlive;
					list.push('AppStore');
					this.$store.commit('changeKeepAlive', list);
				}

				if (to.name == 'notice' && from.name == 'home') {
					let list = this.$store.getters.getKeepAlive;
					list.push('Notice');
					this.$store.commit('changeKeepAlive', list);
				}
				
			},
		}
	}
</script>

<style>
	@import "./common/css/reset.css";
	@import "./common/css/base.css";
	@import 'assets/font/iconfont.css';

	::-webkit-scrollbar {
		width: 0 !important;
		display: none;
	}

	::-webkit-scrollbar {
		width: 0 !important;
		height: 0;
	}

	/*页面跳转动画*/
	.fold-left-enter-active {
		animation-name: fold-left-in;
		animation-duration: 0.3s;
	}

	.fold-left-leave-active {
		animation-name: fold-left-out;
		animation-duration: 0.3s;
	}

	@keyframes fold-left-in {
		0% {
			-webkit-transform: translate3d(100%, 0, 0);
			transform: translate3d(100%, 0, 0);

		}

		100% {
			-webkit-transform: translate3d(0, 0, 0);
			transform: translate3d(0, 0, 0);
		}
	}

	@keyframes fold-left-out {
		0% {
			-webkit-transform: translate3d(0, 0, 0);
			transform: translate3d(0, 0, 0);
		}

		100% {
			-webkit-transform: translate3d(-100%, 0, 0);
			transform: translate3d(-100%, 0, 0);
		}
	}

	.fold-right-enter-active {
		animation-name: fold-right-in;
		animation-duration: 0.3s;
	}

	.fold-right-leave-active {
		animation-name: fold-right-out;
		animation-duration: 0.3s;
	}

	@keyframes fold-right-in {
		0% {
			width: 100%;
			-webkit-transform: translate3d(-100%, 0, 0);
			transform: translate3d(-100%, 0, 0);
		}

		100% {
			width: 100%;
			-webkit-transform: translate3d(0, 0, 0);
			transform: translate3d(0, 0, 0);
		}
	}

	@keyframes fold-right-out {
		0% {
			width: 100%;
			-webkit-transform: translate3d(0, 0, 0);
			transform: translate3d(0, 0, 0);
		}

		100% {
			width: 100%;
			-webkit-transform: translate3d(100%, 0, 0);
			transform: translate3d(100%, 0, 0);
		}
	}

	.transition-body {
		position: absolute;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
	}

	.inexa {
		z-index: 100000001 !important;
	}
</style>
