<template>
	<div class="guide">
		<div class="ld-img-wrap">
			<img :src="src1" class="ld-img">
		</div>
		<div class="ld-wrap">
			<div class="ld-flex">
				<div class="ld-div-wrap">应用安全检测</div>
				<van-loading v-if="!apkSafe" type="spinner" color="#1989fa" size="20px" />
				<div v-else class="ld-status-wrap">完成</div>
			</div>
			<div class="ld-flex" v-if="loginStatus">
				<div class="ld-div-wrap">准入安全检测</div>
				<van-loading v-if="!inSafe" type="spinner" color="#1989fa" size="20px" />
				<div v-else class="ld-status-wrap">完成</div>
			</div>
			<div class="ld-flex">
				<div class="ld-div-wrap">应用版本检测</div>
				<div>
					<van-loading v-if="!visionSafe" type="spinner" color="#1989fa" size="20px" />
					<div v-else class="ld-status-wrap">完成</div>
				</div>
			</div>
			<div class="ld-flex">
				<div class="ld-div-wrap">网络环境检测</div>
				<van-loading v-if="!netSafe" type="spinner" color="#1989fa" size="20px" />
				<div v-else class="ld-status-wrap">完成</div>
			</div>
			<div class="ld-flex" v-if="needVPN">
				<div class="ld-div-wrap">建立VPN连接</div>
				<div>
					<van-loading v-if="!VPNConnect" type="spinner" color="#1989fa" size="20px" />
					<div v-else class="ld-status-wrap">完成</div>
				</div>
			</div>
		</div>
		<!-- <mt-button type="primary" size="small" v-if="showBtn" @click="$router.replace('/gv')"
			v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击进入手势密码页面的按钮', actionType:'gesture-login-click'}">
			进入手势密码页面</mt-button>
 -->
	</div>
</template>

<script>
	import src1 from './../assets/images/gslogo.jpg'
	import {
		Dialog
	} from 'vant';
	export default {
		name: "Loading",
		data() {
			return {
				src1,
				list: [{
					src: src1,
					title: '移动办公',
					desc: '工作进度实时掌握'
				}],
				showBtn: true,
				uniqueCode: '',
				deviceType: '',
				popupVisible: false,
				packageId: '',
				md5Code: '',
				jgPushId: '',
				apkSafe: false,
				inSafe: false,
				visionSafe: false,
				vpnPass: '',
				userCode: '',
				VPNConnect: false,
				loginStatus: false,
				netSafe: false,
				needVPN: false,
			}
		},
		mounted() {

		},
		created() {
			let that = this;
			this.uniqueCode = localStorage.getItem('uniqueCode');
			this.jgPushId = localStorage.getItem('jgPushId');
			this.deviceType = localStorage.getItem('deviceType');
			console.log('create this.uniqueCode ', this.uniqueCode);
      console.log('create this.jgPushId ', this.jgPushId);
      console.log('create this.deviceType ', this.deviceType);
      console.log('create localStorage.getItem(\'vpn_password\') ', localStorage.getItem('vpn_password'));
      console.log('create localStorage.getItem(\'userCode\') ', localStorage.getItem('userCode'));
			if (this.uniqueCode == null || this.jgPushId == null || this.deviceType == null) {
				console.log("1");
				if (window.device.platform == 'Android') {
					console.log("Android");
					localStorage.setItem('deviceType', '1');
					this.deviceType = '1';
				} else if (window.device.platform == 'iOS') {
					console.log("iOS");
					localStorage.setItem('deviceType', '2');
					this.deviceType = '2';
				}
        AppUtilsPlugin.registrationId(success, error);
        function success(datas) {
          console.log('极光 ID ', datas);
          localStorage.setItem('jgPushId', datas);
          that.jgPushId = datas;
        }
        function error(errorMsg) {
          console.log('极光 ID 获取失败', errorMsg);
        }
				localStorage.setItem('uniqueCode', window.device.uuid);
				this.uniqueCode = window.device.uuid;
			}
      this.userCode = localStorage.getItem('userCode');
			this.vpnPass = localStorage.getItem('vpn_password');
			console.log('created userCode vpnPass: ', this.userCode, this.vpnPass);
			if (window.device.platform == 'Android') {
				console.log("android 111");
				this.signCheck();
			} else {
				console.log("iOS 111");
				this.apkSafe = true;
				//外网服务开启后打开此注释*************
				if (this.vpnPass != null && this.userCode != null) {
					this.loginStatus = true;
					console.log("进入 accessCheck");
					this.accessCheck();
				} else {
					this.checkUpdate();
				}
			}
		},
		methods: {
			signCheck() {
				let that = this;
				AppUtilsPlugin.certificate(success, error);

				function success(datas) {
					//正式环境
					let sign = '9C:72:8E:04:F6:21:40:DE:B4:74:23:16:90:D4:73:2C:61:22:06:C2';
					// let sign = 'D3:91:68:6A:D9:9E:97:17:2E:77:74:3F:0B:77:DD:CE:A4:F1:54:31';
					console.log(datas);
					if (sign == datas) {
						that.apkSafe = true;
						//外网服务开启后打开此注释*************
						if (that.vpnPass != null && that.userCode != null) {
							that.loginStatus = true;
							that.accessCheck();
						} else {
							that.checkUpdate();
						}
						// that.inAPP();
					} else {
						that.$dialog.alert({
							title: '提示',
							message: '检测到您的应用已经被篡改，请重新下载应用',
							confirmButtonColor: '#206EEA',
						}).then(() => {
							navigator.app.exitApp();
						});
					}
				}

				function error(datas) {

				}
			},
			accessCheck() {
				//调用登录准入接口判断用户是否加入黑名单
				let that = this;
				NetworkPlugin.access(this.deviceType, this.uniqueCode,
					JSON.parse(localStorage.getItem('user')).employeeCode, success, error);

				function success(datas) {
          console.log("access check datas ", datas);
					if (datas == 1) {
						that.inSafe = true;
            console.log("access check 通过");
						that.checkUpdate();
					} else if (datas == 2) {
						that.$dialog.alert({
							title: '提示',
							message: '您被添加到黑名单，请联系管理员',
							confirmButtonColor: '#206EEA',
						}).then(() => {
							that.$router.replace('/login');
						});
					} else {
						that.$toast('准入检查失败，请重新登录');
						that.$router.replace('/login');
					}
				}

				function error(errorMsg) {
					that.$toast(errorMsg);
					that.$router.replace('/login');
				}
				// this.$postRequest(`${this.$config.APP_DOWNLOAD_IP}accessManage/accessCheck`, {
				// 	...accessCheckDTO
				// }).then(res => {
				// 	if (res.object == 1) {
				// 		this.inSafe = true;
				// this.checkVersion();
				// 	} else if (res.object == 2) {
				// 		this.$toast('您被添加到黑名单，退出APP');
				// 	}
				// }).catch(err => {
				// 	this.$router.replace('/login');
				// });

			},
			checkUpdate() {
			  console.log('进入版本检测');
				if (this.deviceType == '1') {
					let that = this;
					AppUpdatePlugin.update(this.deviceType, '0', onSuccess, onFail);
					//成功的返回事件
					function onSuccess() {
						console.log('版本检测成功进入APP');
						that.visionSafe = true;
						console.log(that.visionSafe);
						that.inAPP();
					}
					//失败的返回事件
					function onFail(message) {
						console.log('版本检测失败进入APP');
						that.visionSafe = true;
						that.inAPP();
					}
				} else {
					this.visionSafe = true;
					console.log(this.visionSafe);
					this.inAPP();
				}
			},
			queryGesturePwd(callback) {
				this.$getRequest(`${this.$config.YDMH}appGesture/obtainUserGesture`, {
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
				  console.log("获取手势密码2 ", res.success + ' ' + res.msg);
					if (res.success && res.msg) {
						localStorage.setItem('isGesturePwd', '1');
					} else {
            localStorage.setItem('isGesturePwd', '0');
          }
					if (callback) {
						callback(res.msg);
					}
				}).catch(() => {
					this.$router.replace('/login');
				});
			},
			inAPP() {
			  console.log('进入 inapp');
        console.log("账号 密码 账号 密码 ", this.userCode, this.vpnPass);
				let that = this;
				NetworkPlugin.netType(success, error);

				function success(datas) {
				  console.log('netType ', datas);
					that.netSafe = true;
					if (datas == '0') {
						//连上国神wifi了
						if (that.vpnPass != null && that.userCode != null) {
							that.queryGesturePwd((res) => {
								setTimeout(() => {
									var routePath = '/gv';
									if (localStorage.getItem('isGesturePwd') == '0') {
										routePath = '/login';
									}
									that.registLisener('1');
									that.$router.replace(routePath);
								}, 1000);
							});
						} else {
						  console.log("账号密码为空，进入登录页");
							setTimeout(() => {
								that.$router.replace('/login');
							}, 1000);
						}
					} else {
						//没连国神wifi
						that.needVPN = true;
						console.log('in App 互联网 ', that.vpnPass, that.userCode);
						if (that.vpnPass != null && that.userCode != null) {
							SSLVPNPlugin.loginVPN("ydvpn.ceic.com", "443", "ldap-auth", that.userCode,
								that.vpnPass, onSuccess, onFail);

							//成功的返回事件
							function onSuccess(result) {
								that.VPNConnect = true;
								console.log("vpn login success ", result);
								// that.$router.replace('/gv');
								that.queryGesturePwd((res) => {
									console.log("手势密码获取成功");
									setTimeout(() => {
										console.log("手势密码跳转了");
										var routePath = '/gv';
										if (localStorage.getItem('isGesturePwd') == '0') {
											routePath = '/login';
										}
										that.registLisener('0');
										that.$router.replace(routePath);
									}, 1000);
								});
							}

							//失败的返回事件
							function onFail(message) {
								console.log('vpn login Failed reason: ', message);
								if (message && message.length != 0) {
									that.$toast(message);
								} else {
									that.$toast('VPN安全认证失败,请重新登录');
								}
								that.$router.replace('/login');
							}
						} else {
						  console.log('账号vpn密码为空， 跳转登录页');
							setTimeout(() => {
								that.$router.replace('/login');
							}, 1000);
						}
					}
				}

				function error(errorMsg) {

				}
			},
			registLisener(islogin) {
				if (window.device.platform == 'Android') {
          NetworkPlugin.check(islogin, this.userCode, this.vpnPass, success, error);
          function success(datas) {

          }
          function error(errorMsg) {

          }
        }
			}
		}
	}
</script>

<style lang="scss">
	.guide {
		height: 100%;
		overflow: hidden;

		.ld-img-wrap {
			display: flex;
			justify-content: center;

			.ld-img {
				height: 43px;
				width: 300px;
				margin: 24vh 0px;
			}
		}

		.mint-button {
			position: absolute;
			bottom: 2rem;
			transform: translateX(-50%);
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

	.version_update {
		width: 80%;
		padding: 10px;
		border: 0;
		border-radius: 5px;
		font-size: 14px;
		color: #fff;
		background: #00A5FF;
	}

	.updatePopup div {
		margin: 1.5rem;
	}

	.ld-wrap {
		margin-top: 70px;
	}

	.ld-flex {
		margin-top: 15px;
		display: flex;
		justify-content: center;
		align-items: center;

		.ld-div-wrap {
			width: 140px;
			font-size: 16px;
			font-weight: bold;
		}

		.ld-status-wrap {
			font-size: 17px;
			font-weight: bold;
			color: orangered;
		}
	}
</style>
