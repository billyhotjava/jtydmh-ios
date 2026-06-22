<template>
	<div class="login">

		<div class="logo">
			<img src="../assets/images/login/login_bg.png" alt="">
			<h3>欢迎使用掌上国神</h3>
		</div>

		<div class="login_form">
			<div class="form-login-notice">集团统一身份认证账号</div>
			<div class="form_item">
				<img src="../assets/images/login/user_bg.png" class="form_icon" />
				<a class="mint-cell mint-field is-nolabel">
					<div class="mint-cell-wrapper">
						<div class="mint-cell-value">
							<input placeholder="请输入工号" type="text" class="mint-field-core" v-model="userCode"
								ref="userCode">
						</div>
					</div>
				</a>
			</div>
			<div class="form-login-notice">集团统一身份认证密码</div>
			<div class="form_item">
				<img src="../assets/images/login/vpn.png" class="form_vpn_icon" />
				<a class="mint-cell mint-field is-nolabel">
					<div class="mint-cell-wrapper">
						<div class="mint-cell-value">
							<input placeholder="请输入集团统一认证密码" type="password" class="mint-field-core"
								v-model="vpn_password" ref="vpn_password">
						</div>
					</div>
				</a>
			</div>
			<div class="form-login-notice">国神密码</div>
			<div class="form_item">
				<img src="../assets/images/login/pwd.png" class="form_icon" />
				<a class="mint-cell mint-field is-nolabel">
					<div class="mint-cell-wrapper">
						<div class="mint-cell-value">
							<input placeholder="请输入国神统一认证密码" type="password" class="mint-field-core" v-model="password"
								ref="password" @blur="blurIn">
						</div>
					</div>
				</a>
			</div>

			<div class="remember">
				<mt-checklist v-model="remember" :options="['记住密码']">
				</mt-checklist>
			</div>

			<!--			<mt-button @click="login"-->
			<!--				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击账号密码登录的按钮', actionType:'login-click'}">-->
			<!--				登录</mt-button>-->
			<mt-button @click="login">登录</mt-button>
		</div>
	</div>
</template>

<script>
	export default {
		name: "Login",
		data() {
			return {
				userCode: '',
				vpn_password: '',
				password: '',
				serial: '',
				platform: '',
				//版本
				packageId: '',
				packageName: '',
				//模态框
				popupVisible: false,
				popupVisible2: false,
				remember: ['记住密码'],
				// scrollHeight: 0,
			}
		},
		created() {
			// this.platform = device.platform;
			// if (this.platform == 'Android') {
			//     this.serial = device.mac;
			//     this.$store.commit('changeDevice', {
			//         serial: this.serial,
			//         platform: this.platform
			//     });
			// }
			this.getDeviceCode();
		},
		mounted() {
			if (this.remember.length > 0) {
				this.userCode = localStorage.getItem('userCode');
				this.vpn_password = localStorage.getItem('vpn_password');
				this.password = localStorage.getItem('password');
			} else {
				this.userCode = '';
				this.vpn_password = '';
				this.password = '';
			}
      // iOS 修改状态栏颜色
      if (window.device.platform == 'iOS') {
        StatusBar.backgroundColorByHexString('#FFFFFF');
      }
		},
		computed: {
			scrollHeight() {
				return (
					document.documentElement.scrollTop ||
					window.pageYOffset ||
					document.body.scrollTop ||
					0
				)
			},
		},
		methods: {
			login() {
				console.log("1111111111111 登录前的数据", this.userCode, this.vpn_password, this.password);
				//验证登陆账号
				if (this.userCode == '' || this.userCode == null) {
					this.$toast('请输入用户名');
					return false;
				} else if (this.vpn_password == '' || this.vpn_password == null) {
					this.$toast('请输入安全认证的密码');
					return false;
				} else if (this.password == '' || this.password == null) {
					this.$toast('请输入移动门户的密码');
					return false;
				}
				let that = this;
				//测试打开此方法即可
				// this.webLogin();
				// return ;
				// this.vpnLogin();
				NetworkPlugin.netType(success, error);

				function success(datas) {
				  console.log('当前 netType = ', datas);
					if (localStorage.getItem('jgPushId') == null ||
						localStorage.getItem('jgPushId') == '') {
					  console.log('极光 ID 为空，重新获取');
						that.getJpushId(datas);
					} else {
						if (datas == '0') {
							//国神wifi
							that.noVpnLogin();
						} else {
							//登录vpn
							that.vpnLogin();
						}
					}
				}

				function error(errorMsg) {
				      console.log('netType error ', errorMsg);
				}
			},
			noVpnLogin() {
				SSLVPNPlugin.logoutVPN();
				let that = this;
				const Base64 = require('js-base64').Base64;
				let pas = Base64.encode(that.password);
				console.log(pas);
				console.log(encodeURIComponent(that.password));
				that.$postRequestQuery(`${that.$config.YDMH}external/appLogin`, {
					uniqueCode: localStorage.getItem('uniqueCode'),
					jgPushId: localStorage.getItem('jgPushId'),
					deviceType: localStorage.getItem('deviceType'),
					userCode: that.userCode,
					password: pas,
				}).then(res => {
					if (res) {
						console.log('账号密码登录成功 ', res);
						// 去掉引导功能
						localStorage.setItem('intro', '1');
						if (device.platform == 'iOS') {
							NotificationPlugin.changeLoginStatus(true, that.userCode, that.vpn_password, onSuccess,
								onFail);
							//成功的返回事件
							function onSuccess(result) {
								console.log("changeLoginStatus success " + result)
							}
							//失败的返回事件
							function onFail(message) {
								console.log('changeLoginStatus Failed reason ' + message);
							}
						}
						let obj = res.object;
						obj.pass = that.password;
						localStorage.setItem('user', JSON.stringify(obj));
						that.$store.commit('changeKeepAlive', ['Home', 'Tab1', 'Tab2', 'Tab3', 'Tab4']);
						//记住密码
						if (that.remember.length > 0) {
							localStorage.setItem('userCode', that.userCode);
							localStorage.setItem('vpn_password', that.vpn_password);
							localStorage.setItem('password', that.password);
						}
						that.queryGesturePwd((res) => {
							that.registLisener('1');
							that.$router.replace('/home');
							// 登录成功修改水印
							that.bus.$emit('loginSuccess', true);
						});
					} else {
						console.log('登录接口返回数据为空');
					}
				}).catch(err => {
					console.log('登录失败 ', err);
					// that.loginLogPasswordError(err);
				});
			},
			vpnLogin() {
				SSLVPNPlugin.logoutVPN();
				let that = this;
				this.$indicator.open({
					text: 'VPN认证中',
					spinnerType: 'triple-bounce'
				});
				console.log("****** vpnLogin ******");
				SSLVPNPlugin.loginVPN("ydvpn.ceic.com", "443", "ldap-auth", this.userCode, this.vpn_password, onSuccess,
					onFail);
				//成功的返回事件
				function onSuccess(result) {
					that.$indicator.close();
					console.log("vpn login success ", result);
					console.log(localStorage.getItem('uniqueCode'));
					console.log(localStorage.getItem('jgPushId'));
					console.log(localStorage.getItem('deviceType'));
					const Base64 = require('js-base64').Base64;
					let pas = Base64.encode(that.password);
					console.log(pas);
					that.$postRequestQuery(`${that.$config.YDMH}external/appLogin`, {
						uniqueCode: localStorage.getItem('uniqueCode'),
						jgPushId: localStorage.getItem('jgPushId'),
						deviceType: localStorage.getItem('deviceType'),
						userCode: that.userCode,
						password: pas,
					}).then(res => {
						if (res) {
							console.log('账号密码登录成功 ', res);
							// 去掉引导功能
							localStorage.setItem('intro', '1');
							if (device.platform == 'iOS') {
								NotificationPlugin.changeLoginStatus(true, that.userCode, that.vpn_password,
									onSuccess, onFail);
								//成功的返回事件
								function onSuccess(result) {
									console.log("changeLoginStatus success " + result)
								}
								//失败的返回事件
								function onFail(message) {
									console.log('changeLoginStatus Failed reason ' + message);
								}
							}
							let obj = res.object;
							obj.pass = that.password;
							localStorage.setItem('user', JSON.stringify(obj));
							that.$store.commit('changeKeepAlive', ['Home', 'Tab1', 'Tab2', 'Tab3', 'Tab4']);
							//记住密码
							if (that.remember.length > 0) {
								localStorage.setItem('userCode', that.userCode);
								localStorage.setItem('vpn_password', that.vpn_password);
								localStorage.setItem('password', that.password);
							}
							that.queryGesturePwd((res) => {
								// 登录成功修改水印
								that.bus.$emit('loginSuccess', true);
								that.registLisener('0');
								that.$router.replace('/home');
							});
						} else {
							console.log('登录接口返回数据为空');
							SSLVPNPlugin.logoutVPN();
						}
					}).catch(err => {
						that.$toast(err);
						SSLVPNPlugin.logoutVPN();
					});
				}
				//失败的返回事件

				function onFail(message) {
					that.$indicator.close();
					console.log('vpn login Failed reason: ', message);
					if (message && message.length != 0) {
						if (message.search('密码错误') != -1) {
							that.$toast('VPN密码错误，请关注是否近期修改过4A密码');
						} else {
							that.$toast(message);
						}
					} else {
						that.$toast('安全认证登录失败');
					}
				}
			},
			getDeviceCode() {
				// localStorage.setItem('uniqueCode', '1b4eefacb9196ec0');
				// localStorage.setItem('deviceType', '1');
				// localStorage.setItem('jgPushId', '12222121212');
				let uniqueCode = localStorage.getItem('uniqueCode');
				let jgPushId = localStorage.getItem('jgPushId');
				let deviceType = localStorage.getItem('deviceType');
				if (uniqueCode == null || jgPushId == null || deviceType == null) {
					if (window.device.platform == 'Android') {
						localStorage.setItem('deviceType', '1');
					} else if (window.device.platform == 'iOS') {
						localStorage.setItem('deviceType', '2');
					}
					AppUtilsPlugin.registrationId(success, error);

					function success(datas) {
						console.log('极光id获取到了:' + datas);
						localStorage.setItem('jgPushId', datas);
					}

					function error(errorMsg) {
						console.log('极光 ID 获取失败 ', errorMsg);
					}
					localStorage.setItem('uniqueCode', window.device.uuid);

					console.log('设备类型 deviceType ', localStorage.getItem('deviceType'));
					console.log('极光ID jgPushId ', localStorage.getItem('jgPushId'));
					console.log('设备唯一码 uniqueCode ', localStorage.getItem('uniqueCode'));
				}
			},
			getJpushId(datas) {
				AppUtilsPlugin.registrationId(success, error);

				function success(datas) {
					localStorage.setItem('jgPushId', datas);
					if (datas == '0') {
						//国神wifi
						that.noVpnLogin();
					} else {
						//登录vpn
						that.vpnLogin();
					}
				}

				function error(errorMsg) {
					console.log('重新获取极光 ID 失败 ', errorMsg);
					if (datas == '0') {
						//国神wifi
						that.noVpnLogin();
					} else {
						//登录vpn
						that.vpnLogin();
					}
				}
			},
			blurIn() {
				window.scrollTo(0, Math.max(this.scrollHieght - 1, 0))
			},
			queryGesturePwd(callback) {
				this.$getRequest(`${this.$config.YDMH}appGesture/obtainUserGesture`, {
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
          console.log("获取手势密码3 ", res.success + ' ' + res.msg);
					if (res.success && res.msg) {
						localStorage.setItem('isGesturePwd', '1');
					} else {
            localStorage.setItem('isGesturePwd', '0');
          }
					if (callback) {
						callback(res.msg);
					}
				}).catch(() => {

				});
			},
			registLisener(islogin) {
				console.log('登录check: isLogin = ' + islogin + ', this.userCode = ' + this.userCode +
					', this.vpn_password = ' + this.vpn_password);
				if (window.device.platform == 'Android') {
					NetworkPlugin.check(islogin, this.userCode, this.vpn_password, success, error);

					function success(datas) {
						console.log('Android networkplugin check ', datas);
					}

					function error(errorMsg) {
						console.log('Android networkplugin check error ', errorMsg);
					}
				}
			},
			webLogin() {
				let that = this;
				const Base64 = require('js-base64').Base64;
				let pas = Base64.encode(that.password);
				console.log(pas);
				console.log(encodeURIComponent(that.password));
				that.$postRequestQuery(`${that.$config.YDMH}external/appLogin`, {
					uniqueCode: localStorage.getItem('uniqueCode'),
					jgPushId: localStorage.getItem('jgPushId'),
					deviceType: localStorage.getItem('deviceType'),
					userCode: that.userCode,
					password: pas,
				}).then(res => {
					console.log('账号密码登录成功 ', res);
					// 去掉引导功能
					localStorage.setItem('intro', '1');
					let obj = res.object;
					obj.pass = that.password;
					localStorage.setItem('user', JSON.stringify(obj));
					that.$store.commit('changeKeepAlive', ['Home', 'Tab1', 'Tab2', 'Tab3', 'Tab4']);
					//记住密码
					if (that.remember.length > 0) {
						localStorage.setItem('userCode', that.userCode);
						localStorage.setItem('vpn_password', that.vpn_password);
						localStorage.setItem('password', that.password);
					}
					that.queryGesturePwd((res) => {
						that.$router.replace('/home');
						// 登录成功修改水印
						that.bus.$emit('loginSuccess', true);
					});
				}).catch(err => {
					console.log('登录失败 ', err);
					// that.loginLogPasswordError(err);
				});
			},
		},
		watch: {
			userCode() {
				if (this.userCode == '') {
					this.$refs.userCode.focus();
				}
			},
			vpn_password() {
				if (this.vpn_password == '') {
					this.$refs.vpn_password.focus();
				}
			},
			password() {
				if (this.password == '') {
					this.$refs.password.focus();
				}
			},
		},
	}
</script>

<style lang="scss">
	.login {
		height: 100%;
		overflow: hidden;
		/*background: url("../assets/images/login-bg.png") no-repeat;*/
		background-size: cover;

		.logo {
			/*margin: 5rem auto 4rem;*/
			padding-top: 10vh;
			height: 45vh;
			box-sizing: border-box;
			text-align: center;

			img {
				width: 70%;
				height: 70%;
				margin: 0 20px 20px 20px;
			}

			h3 {
				font-size: 1rem;
				margin-top: 1rem;
				letter-spacing: 0.1rem;
				color: #1f6de9;
			}
		}

		.login_form {
			margin: 0 2rem;

			.form-login-notice {
				margin-left: 1rem;
				font-weight: bold;
				color: #5c5c5c;
			}

			.form_item {
				height: 2.8rem;
				padding: 0 1rem 0 3rem;
				position: relative;
				line-height: 4rem;
				background: #f7f8fa;
				margin: 10px;
				border-radius: 30px;

				.form_icon {
					width: 1.2rem;
					height: 1.4rem;
					position: absolute;
					left: 1.5rem;
					top: 50%;
					transform: translateY(-50%);
				}

				.form_vpn_icon {
					width: 1.4rem;
					height: 1.4rem;
					position: absolute;
					left: 1.4rem;
					top: 50%;
					transform: translateY(-50%);
				}

				input {
					line-height: 1rem;
					font-size: 1rem;
					background: #f7f8fa;
				}
			}

			.mint-button {
				margin: 4vh 0 0 0;
				width: 100%;
				height: 3rem;
				border-radius: 20px;
				background-color: #206eea;
				color: #fff;
				font-size: 1.2rem;
				letter-spacing: 0.3rem;
			}

			.mint-button:not(.is-disabled):active::after {
				opacity: 0.1;
			}
		}
	}

	.remember {
		height: 2rem;
		float: right;
		/*margin: 10px;*/

		.mint-checkbox-core {
			border-radius: 0;
			background-color: rgba(255, 255, 255, 0);
			/*border: 2px solid rgba(255, 255, 255, 0.7);*/
			width: 0.8rem;
			height: 0.8rem;
		}

		.mint-checklist-label {
			/*padding-left: 8px;*/
		}

		.mint-checkbox-label {
			/*margin-left: 18px;*/
		}

		.mint-checkbox-core::after {
			top: 1px;
			left: 4px;
		}
	}

	.mt-popup {
		width: 80%;
	}

	.updatePopup {
		margin-top: 2rem;
		margin-bottom: 2rem;
		text-align: center;
	}

	.version_titie {
		font-size: 1rem;
		color: #333;
	}

	.version_content {
		font-size: 0.8rem;
		color: #666;
	}

	.updatePopup div {
		margin: 1.5rem;
	}
</style>
