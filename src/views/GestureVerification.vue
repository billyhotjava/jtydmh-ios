<template>
	<div>
		<img :src="src1" class="user-img hor-center" />
		<h3 class="name-h3">{{ChineseName}}</h3>
		<GesturePassword :width='width' :height='height' @onChange="pwdChange" class="hor-center" />
		<div class="pwd-h3" @click="forgetPwd"
			v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击忘记手势密码的按钮', actionType:'forget-gesture-click'}">
			忘记手势密码？</div>
    <checkpassword :showCheckPasswordDialog="isShowCheckPasswordDialog" @closeDialog="closeDialog"
                   @checkPasswordHandler="checkPasswordHandler" />
	</div>
</template>

<script>
	import src1 from './../assets/images/gestver/user.png';
  import checkpassword from "@/components/CheckPassword/CheckPassword";

	export default {
		name: "GestureVerification",
    components: {
      checkpassword,
    },
		data() {
			return {
				src1,
				width: 375,
				height: 400,
				ChineseName: JSON.parse(localStorage.getItem('user')).fullName,
				wrongGVCount: 0,
				jumpType: 0, //0普通登录进入手势密码页面 1前后台切换进入手势密码验证页面
        isShowCheckPasswordDialog: false,
			}
		},
		mounted() {
			if (this.$route.params.type != null) {
				this.jumpType = this.$route.params.type;
			}
		},
		methods: {
			queryGesturePwd(callback) {
				this.$getRequest(`${this.$config.YDMH}appGesture/obtainUserGesture`, {
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
          console.log("获取手势密码1 ", res.success + ' ' + res.msg);
					if (callback) {
						callback(res.msg);
					}
				}).catch(() => {

				});
			},
			pwdChange(data) {
				this.queryGesturePwd((res) => {
					if (data.toString() == res) {
						console.log("手势密码登录成功");
						if (device.platform == 'iOS') {
						  let userCode = localStorage.getItem('userCode');
						  let vpn_password = localStorage.getItem('vpn_password');
							NotificationPlugin.changeLoginStatus(true, userCode, vpn_password, onSuccess, onFail);
							//成功的返回事件
							function onSuccess(result) {
								console.log("changeLoginStatus success " + result)
							}
							//失败的返回事件
							function onFail(message) {
								console.log('changeLoginStatus Failed reason ' + message);
							}
						}
						console.log('type: ' + this.jumpType);
						if (this.jumpType == 0) {
							console.log('跳转到登录页');
							this.$router.replace('/home');
							// 登录成功修改水印
							this.bus.$emit('loginSuccess', true);
						} else if (this.jumpType == 1) {
							console.log('跳转到返回页');
							this.$store.commit('changegvback', true);
							this.$router.back();
						} else if (this.jumpType == 2) {
							this.$store.commit('changegvback', true);
							console.log(this.$route.params.info);
							console.log(this.$route.params.param);
							let info = JSON.parse(this.$route.params.info);
							let param = JSON.parse(this.$route.params.param);
							if (info.name == '生产日报') {
								this.$router.replace({
									name: param.url,
									params: {
										sendDay: param.data
									}
								});
							}else if (info.name =='手机报') {
								this.$router.push({
									name: param.url,
									params: {
										id: param.id,
										isLoadLocalData: false,
									}
								});
							}
						} else {

						}
					} else {
						this.$toast('手势密码错误');
						this.wrongGVCount++;
						if (this.wrongGVCount == 3) {
							let instance = this.$toast("尝试错误已达3次，请重新登录");
							setTimeout(() => {
								instance.close();
								// this.forgetPwd();
                console.log("点击忘记密码");
                // 此种情况可以跳转
                this.$store.commit('changegvback', true);
                this.$router.replace('/login');
							}, 1500);
						}
					}
				});
			},
			forgetPwd() {
			  console.log("点击忘记密码");
			  // 此种情况可以跳转
        this.$store.commit('changegvback', true);
				// this.$router.replace('/login');
        this.isShowCheckPasswordDialog = true;

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
		}
	}
</script>

<style scoped>
	.hor-center {
		position: relative;
		left: 50%;
		transform: translateX(-50%);
	}

	.user-img {
		width: 80px;
		height: 80px;
		margin-top: 80px;
		border-radius: 50%;
	}

	.name-h3 {
		text-align: center;
		margin-top: 10px;
		color: #7C7C7C
	}

	.pwd-h3 {
		text-align: center;
		margin-top: 10px;
		font-size: 13px;
		color: #5187eb
	}
</style>
