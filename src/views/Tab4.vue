<template>
	<div class="tab-page tab4">
		<div class="tab-header">
			<mt-header title="设置"></mt-header>
		</div>

		<div class="tab-content pr" style="height: 100%">
			<div class="user_img background-blue-2">
				<img :src="imgSrc" alt="" @click="changeHead" style="float: left; border-radius: 50%"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击切换头像的按钮', actionType:'avatar-click'}">
				<div style="float: left; margin-left: 20px" class="vertical-center">
					<h2>{{jobName}}</h2>
					<p>{{orgName}}/{{employeeCode}}</p>
				</div>
			</div>

			<div class="setting_list bgwhite">
				<a href="javascript:;" class="flex bb" @click="grzx"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击个人中心的列表', actionType:'personal-center-click'}">
					<img src="../assets/images/set/grzx.png" width="20" height="20"
						style="margin-top: 8px; padding: 0 1rem;" />
					<p class="flex1">个人中心</p>
					<i class="mintui mintui-back"></i>
				</a>

				<a href="javascript:;" class="flex bb" @click="ssmm"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击手势密码的列表', actionType:'gesture-verification-click'}">
					<img src="../assets/images/set/ssmm.png" width="20" height="20"
						style="margin-top: 8px; padding: 0 1rem;" />
					<p class="flex1">手势密码</p>
					<i class="mintui mintui-back"></i>
				</a>

				<a href="javascript:;" v-if="showCheckUpdate" class="flex bb" @click='checkUpdate()'
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击检查更新的列表', actionType:'check-update-click'}">
					<img src="../assets/images/set/jcgx.png" width="20" height="20"
						style="margin-top: 8px; padding: 0 1rem;" />
					<p class="flex1">检查更新</p>
					<i class="mintui mintui-back"></i>
				</a>

				<a href="javascript:;" class="flex bb" @click='qchc'
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击清除缓存的列表', actionType:'clear-cache-click'}">
					<img src="../assets/images/set/qchc.png" width="20" height="20"
						style="margin-top: 8px; padding: 0 1rem;" />
					<p class="flex1">清除缓存</p>
					<i class="mintui mintui-back"></i>
				</a>

				<a href="javascript:;" class="flex bb"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击清除缓存的列表', actionType:'clear-cache-click'}">
					<img src="../assets/images/set/bigfront.png" width="20" height="20"
						style="margin-top: 8px; padding: 0 1rem;" />
					<p class="flex1">大字体模式</p>
					<div class="tab4-swith-wrap">
						<van-switch :value="openOld" @input="openOldClick" size="20px" />
					</div>
				</a>

				<!-- <a href="javascript:;" class="flex bb" @click='gywm' v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击关于我们的列表', actionType:'about-us-click'}">
                    <img src="../assets/images/set/gywm.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                    <p class="flex1">关于我们</p>
                    <i class="mintui mintui-back"></i>
                </a> -->

				<!--  <a href="javascript:;" class="flex bb" @click='signOut'>
                    <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                    <p class="flex1">退出登录</p>
                    <i class="mintui mintui-back"></i>
                </a> -->
<!--        <a href="javascript:;" class="flex bb" @click='open_remote_webView'>-->
<!--          <img src="../assets/images/set/gywm.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>-->
<!--          <p class="flex1">远程页面调用本地 Cordova 插件</p>-->
<!--          <i class="mintui mintui-back"></i>-->
<!--        </a>-->
				<div class="btn-wrap">
					<mt-button type="primary" size="large" @click="signOut"
						v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击退出登录的按钮', actionType:'logout-click'}">
						退出登录</mt-button>
				</div>
				<!-- 
                <a href="javascript:;" class="flex bb" @click='Zx'>
                    <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                    <p class="flex1">资讯</p>
                    <i class="mintui mintui-back"></i>
                </a>

                <a href="javascript:;" class="flex bb" @click='txl'>
                    <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                    <p class="flex1">通讯录</p>
                    <i class="mintui mintui-back"></i>
                </a>
              <a href="javascript:;" class="flex bb" @click='sjb'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">手机报</p>
                <i class="mintui mintui-back"></i>
              </a>
                <a href="javascript:;" class="flex bb" @click='vpnlogin'>
                  <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                  <p class="flex1">VPN 登录</p>
                  <i class="mintui mintui-back"></i>
                </a>
              <a href="javascript:;" class="flex bb" @click='vpnlogout'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">VPN 登出</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='getdevice'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">获取设备信息</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='getjpushid'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">获取极光ID</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='scancode'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">扫一扫</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='capture'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">拍照</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='picture'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">选择照片</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='camera'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">录像</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='jump'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">跳转微信</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='register_notification'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">注册通知及远程通知回调</p>
                <i class="mintui mintui-back"></i>
              </a>
              <a href="javascript:;" class="flex bb" @click='send_notification'>
                <img src="../assets/images/set/tcdl.png" width="20" height="20" style="margin-top: 8px; padding: 0 1rem;"/>
                <p class="flex1">发送本地通知</p>
                <i class="mintui mintui-back"></i>
              </a> -->
			</div>

			<mt-actionsheet :actions="actions" v-model="sheetVisible">
			</mt-actionsheet>
		</div>
		<checkpassword :showCheckPasswordDialog="isShowCheckPasswordDialog" @closeDialog="closeDialog"
			@checkPasswordHandler="checkPasswordHandler" />
	</div>
</template>

<script>
	import checkpassword from "@/components/CheckPassword/CheckPassword";
	import user_default_img from '../assets/images/set/user.png';

	export default {
		name: "Tab4",
		components: {
			checkpassword,
		},
		props: {
			selected: String,
		},
		data() {
			return {
				start: '0',
				sheetVisible: false,
				actions: [],
				imgSrc: user_default_img,
				jobName: '',
				orgName: '',
				employeeCode: '',
				version: '',
				actions: [{
					name: '拍照',
					method: this.getCamera // 调用methods中的函数
				}, {
					name: '从相册中选择',
					method: this.getLibrary // 调用methods中的函数
				}],
				sheetVisible: false,
				person: {},
				isShowCheckPasswordDialog: false,
				employeeCode: '',
				md5Code: '',
				openOld: false,
				showCheckUpdate: true,
			}
		},
		created() {
			this.showCheckUpdate = window.device.platform == 'Android';
			console.log('显示更新栏 ', this.showCheckUpdate);
			let status = localStorage.getItem('openOld');
			console.log('长辈版：' + status);
			if (status == 1) {
				this.openOld = true;
			}
		},
		mounted() {
			this.getUserNameAndOrgName();
		},
		methods: {
			openOldClick(checked) {
				this.$dialog.confirm({
					title: '提示',
					message: '大字版切换将会重启应用',
					confirmButtonColor: '#206EEA',
				}).then(() => {
					console.log(checked);
					localStorage.setItem('openOld', checked ? 1 : 0);
					console.log('openOld ', localStorage.getItem('openOld'));
					this.openOld = checked;
					if (this.openOld) {
						AppUtilsPlugin.setWebSize("larger", success, fail);
					} else {
						AppUtilsPlugin.setWebSize("normal", success, fail);
					}

					function success(datas) {
						localStorage.setItem('openOld', checked ? 1 : 0);
						console.log('设置字体成功 ', datas);
					}

					function fail(error) {
						console.log('设置字体失败 ', error);
					}
				}).catch(() => {

				});
			},
			grzx() {
				this.$router.push({
					name: 'grzx',
					params: {
						item: this.person
					}
				});
			},
			getUserNameAndOrgName() {
				let user = JSON.parse(localStorage.getItem('user'));
				let employeeCode = user.employeeCode;
				this.$getRequest(`${this.$config.YDMH}external/getUserNameAndOrgName`, {
					employeeCode: employeeCode
				}).then(res => {
					console.log("获取部门", res);
					if (res.object) {
						this.jobName = res.object.userName;
						this.orgName = res.object.orgName;
						this.employeeCode = employeeCode;
						this.person = {
							jobName: this.jobName,
							orgName: this.orgName,
							employeeCode: this.employeeCode,
							email: user.email,
							mobile: user.telephoneNumber,
						}
					}
				}).catch((err) => {
					console.log("获取部门接口失败", err);
					this.$toast("网络请求获取部门接口失败");
				});
			},
			ssmm() {
				/*
				 * TODO 判断是否已经创建过手势密码，
				 * TODO 如果未曾创建，则进入新建手势密码页面，
				 * TODO 如果已经创建过手势密码，则进入修改密码页面
				 */
				console.log('点击');
				this.isShowCheckPasswordDialog = true;
			},
			checkUpdate() {
				let that = this;
				AppUpdatePlugin.update(localStorage.getItem('deviceType'), '1', onSuccess, onFail);
				//成功的返回事件
				function onSuccess(message) {
					if (message == 'success') {
						that.$toast("当前应用已经是最新版本");
					} else {

					}
				}
				//失败的返回事件
				function onFail(message) {
					that.$toast(message);
				}
			},
			qchc() {
				let that = this;
				AppUtilsPlugin.clearCache(success, error)
				//成功的返回事件
				function success(result) {
					console.log('清除缓存成功 result ', result);
					var message = '已成功清理缓存';
					if (result != null && result != '') {
						message = message + ' ' + result + 'M';
					}
					that.$toast({
						message: message,
						className: 'inexa'
					});
				}
				//失败的返回事件
				function error(message) {

				}
			},
			gywm() {
				console.log('关于我们');
			},
			signOut() {
				console.log('退出登陆');
				this.$getRequest(`${this.$config.YDMH}/external/logout`).then(res => {
					console.log('登出成功 ', res);
					localStorage.removeItem('user');
					if (device.platform == 'iOS') {
						NotificationPlugin.changeLoginStatus(false, '', '', onSuccess, onFail);

						//成功的返回事件
						function onSuccess(result) {
							console.log("🪜changeLoginStatus success " + result)
						}

						//失败的返回事件
						function onFail(message) {
							console.log('🪜changeLoginStatus Failed reason: ' + message);
						}
					}
					//退出登录清除缓存
					localStorage.removeItem('userCode');
					localStorage.removeItem('vpn_password');
					localStorage.removeItem('password');
					localStorage.removeItem('user');
					SSLVPNPlugin.logoutVPN();
					if (window.device.platform == 'Android') {
						NetworkPlugin.checkout(success, error);
					}

					function success(datas) {

					}

					function error(errorMsg) {

					}
					// 退出登录修改水印
					this.bus.$emit('loginSuccess', false);
					this.$router.replace('/login');
				}).catch(err => {
					console.log('登出失败 ', err);
				});
			},
			closeDialog() {
				this.isShowCheckPasswordDialog = false;
			},
			checkPasswordHandler(result) {
				if (result) {
					this.closeDialog();
					this.$router.push({
						name: 'gesturelock',
					});
				} else {
					this.$toast({
						message: '密码输入有误，请重新输入',
						position: 'bottom'
					});
				}
			},
			changeHead() {
				// 打开action sheet
				this.sheetVisible = true;
			},

			getCamera() {
				console.log("打开照相机");
				this.sheetVisible = false;
			},
			getLibrary() {
				console.log("打开相册");
				this.sheetVisible = false;
			},

			Zx() {
				this.$router.push({
					name: 'zx',
				});
			},
			txl() {
				this.$router.push({
					name: 'personaddress',
				});
			},
			sjb() {
				this.$router.push({
					path: 'xinwen'
				});
			},
			vpnlogin(vpnUser, vpnPassword) {
				console.log("****** vpnLogin ******");
				SSLVPNPlugin.loginVPN("ydvpn.ceic.com", "443", "ldap-auth", "11171560", "Wgz!#%&(1682", onSuccess, onFail);
				//成功的返回事件
				function onSuccess(result) {
					console.log("vpn login success " + result)
				}
				//失败的返回事件
				function onFail(message) {
					console.log('vpn login Failed reason: ' + message);
				}
			},
			vpnlogout() {
				console.log("****** vpnLogout ******");
				SSLVPNPlugin.logoutVPN(onSuccess, onFail);
				//成功的返回事件
				function onSuccess(result) {
					console.log("vpn logout success " + result)
				}
				//失败的返回事件
				function onFail(message) {
					console.log('vpn logout Failed reason: ' + message);
				}
			},
			getdevice() {
				console.log("****** getdevice ******");
				console.log(window.device.uuid);
				console.log(window.device.platform);
				console.log(window.device.manufacturer);
				console.log(window.device.model);
				console.log(window.device.version);
				console.log(window.device.cordova);
				console.log(window.device.JPushRegistrationID);
			},
			getjpushid() {
				console.log("****** getjpushid ******");
				console.log(window.device.JPushRegistrationID);
				cordova.exec(onSuccess, onFail, 'Device', 'getJPushRegistrationID', []);
				//成功的返回事件
				function onSuccess(result) {
					console.log("getjpushid success " + result)
				}
				//失败的返回事件
				function onFail(message) {
					console.log('getjpushid Failed reason: ' + message);
				}
			},
			scancode() {
				// 参数 arg0    1  条形码   2  二维码   3   二维码或条形码
				ScanCodePlugin.scan('3', onSuccess, onFail);
				//成功的返回事件
				function onSuccess(result) {
					console.log("getjpushid success " + result)
				}
				//失败的返回事件
				function onFail(message) {
					console.log('getjpushid Failed reason: ' + message);
				}
			},
			capture() {
				console.log("!!! capture !!!");
				//拍照设置参数
				// sourceType: 0 PHOTOLIBRARY   1 CAMERA    2 SAVEDPHOTOALBUM
				// destinationType: 0 DATA_URL(base64)  1 FILE_URI
				let cameraOptions = {
					quality: 50,
					sourceType: 1,
					destinationType: 0,
					cameraDirection: 0
				};
				//此处是官网提供的调用方法
				navigator.camera.getPicture(onsuccess, onfail, cameraOptions);

				function onsuccess(imageURI) {
					console.log(imageURI);
				}

				function onfail(message) {
					alert('capture Failed reason: ' + message);
				}
			},
			picture() {
				console.log("!!! picture !!!");
				let cameraOptions = {
					quality: 50,
					sourceType: 0,
					destinationType: 0,
				};
				navigator.camera.getPicture(onsuccess, onfail, cameraOptions);

				function onsuccess(imageURI) {
					console.log("!!!!! picture success: " + imageURI);
				}

				function onfail(message) {
					alert('!!!!! picture Failed reason: ' + message);
				}
			},
			camera() {
				console.log("!!! camera !!!");
				//duration参数为最长录制时间
				navigator.device.capture.captureVideo(onsuccess, onerror, {
					duration: 10
				});

				function onsuccess(mediaFiles) {
					var i, path, len;
					for (i = 0, len = mediaFiles.length; i < len; i += 1) {
						path = mediaFiles[i].fullPath;
						alert("camera success\n" +
							"name：" + mediaFiles[i].name + "\n" +
							"size：" + mediaFiles[i].size + "\n" +
							"localURL：" + mediaFiles[i].localURL + "\n" +
							"fullPath：" + path);
					}
				}

				function onerror(error) {
					console.log(error)
					alert('camera error reason: ' + error);
				}
			},
			jump() {
				console.log("!!! jump !!!");
				let scheme = "weixin://";
				appAvailability.check(scheme, function() {
					console.log("找到 已安装");
					var sApp = startApp.set(scheme);
					sApp.start(function() {
						/* success */
						console.log('jump wechat success');
					}, function(error) {
						/* fail */
						alert(error);
					});
				}, function() { // Error callback
					console.log('jump wechat ' + scheme + " 不可用")
				});
			},
			register_notification() {
				// ⚠️⚠️⚠️ 该方法需要放到 App 启动时调用
				console.log("!!! register_notification !!!");
				NotificationPlugin.registerNotification(onSuccess, onFail);

				//成功的返回事件
				function onSuccess(result) {
					console.log("register_notification success " + result)
				}
				//失败的返回事件
				function onFail(message) {
					console.log('register_notification Failed reason: ' + message);
				}

				console.log("!!! receive_remote_notification !!!");

				NotificationPlugin.didReceiveRemoteNotification(onsuccess, onfail);

				function onsuccess(result) {
					console.log("### 远程通知回调成功 接收数据:" + result);
				}

				function onfail(message) {
					console.log("### 远程通知回调失败 " + message);
				}

			},
			send_notification() {
				console.log("!!! send_notification !!!");

				NotificationPlugin.sendNotification("我是标题", "我是通知内容", "我是跳转标识符", onsuccess, onfail);

				function onsuccess(result) {
					console.log("### 发送本地通知成功 接收数据:" + result);
				}

				function onfail(message) {
					console.log("### 发送本地通知失败 " + message);
				}
			},
			open_remote_webView() {
        if (window.device.platform == 'iOS') {
          OpenWebViewPlugin.openWebView("http://10.150.50.33:8080", onSuccess, onFail);

          //成功的返回事件
          function onSuccess(result) {
            console.log("register_notification success " + result)
          }

          //失败的返回事件
          function onFail(message) {
            console.log('register_notification Failed reason: ' + message);
          }
        }
			}
		},
		watch: {
			selected() {
				if (this.selected == 'tab-container4' && this.start == '0') {
					let user = JSON.parse(localStorage.getItem('user'));
					this.employeeCode = user.employeeCode;
					this.jobName = user.fullName;
					// this.$getRequest(`${this.$config.IP1}unifyUser/obtainUserByCode`,{
					//     userCode: JSON.parse(localStorage.getItem('user')).employeeCode
					// }).then( res => {
					//     this.person = res.object;
					//     this.jobName = res.object.jobName;
					//     if(res.object.photo){
					//         this.$getRequest(`${this.$config.IP3}file/${res.object.photo}/presignedurl`).then(res => {
					//             this.imgSrc = res.presignedAgentUrl;
					//             this.start = '1';
					//         }).catch(() => {
					//             this.$toast('请求头像失败');
					//             this.imgSrc = '';
					//         })
					//     }else{

					//     }
					// }).catch(() => {});

				}
			},
		}
	}
</script>

<style lang="scss">
	.tab4 {
		.user_img {
			width: 100%;
			height: 120px;

			a {
				display: inline-block;
				width: 70px;
				height: 70px;
				margin-left: 40px;
			}

			img {
				width: 70px;
				height: 70px;
				margin-left: 40px;
				position: relative;
				top: 50%;
				transform: translateY(-50%);
			}

			h2 {
				color: #fff;
				font-size: 20px;
				margin-top: 0.2rem;
				font-weight: normal;
				line-height: 2rem;
			}

			p {
				color: #E5E5E5;
				font-size: 16px;
			}
		}

		.setting_list {
			padding-top: 5px;
			margin-bottom: 50px;

			.flex {
				width: 96vw;
			}

			a {
				line-height: 2.3rem;

				p {
					font-size: 0.95rem;
					color: #6f6f6f;
				}

				i:nth-child(1) {
					font-size: 1.3rem;
					color: #3b87f6;
					padding: 0 1rem;
				}

				i:nth-child(3) {
					transform: rotate(180deg);
					padding: 0 1rem;
					color: #c1c1c1;
					font-size: 0.8rem;
				}

				.tab4-swith-wrap {
					display: flex;
					/*Flex布局*/
					display: -webkit-flex;
					/* Safari */
					align-items: center;
					/*指定垂直居中*/
					margin-right: 20px;
				}
			}
		}

		.lastest {
			font-size: 0.6rem;
			margin-right: 1rem;
			color: #c1c1c1;
		}
	}

	.btn-wrap {
		margin: 30px 30px;
	}
</style>
