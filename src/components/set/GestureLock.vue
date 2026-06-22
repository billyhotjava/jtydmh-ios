<!--手势密码-->
<template>
	<div class="tab-page has-header noticeinfo_page">
		<div class="tab-header">
			<mt-header :title="title">
				<a href="javascript:;" slot="left" @click="back()">
					<mt-button icon="back" />
				</a>
			</mt-header>
		</div>



		<div class="tab-content hor-center" style="background: white">

			<div class="notice">{{notice}}</div>
			<img src="../../assets/images/application/gesture.png" width="40" height="40" />
			<div class="notice-sub">绘制解锁图案</div>
			<GesturePassword v-if="gesturePwd.length < 6" :width='width' :height='height' @onChange="firstChange" />
			<GesturePassword v-else :width='width' :height='height' @onChange="secondChange" />
		</div>
	</div>
</template>

<script>
	export default {
		name: "GestureLock",
		data() {
			return {
				width: 350,
				height: 350,
				gesturePwd: [],
				title: '',
				elForm: {},
				notice: '请绘制修改手势密码'
			}
		},
		mounted() {
			if (localStorage.getItem('isGesturePwd') == '0') {
				this.title = '创建手势密码';
			} else {
				this.title = '修改手势密码';
			}
		},
		methods: {
			back() {
				if (localStorage.getItem('isGesturePwd') == '1') {
					this.$router.back(-1);
				} else {
                    this.$toast({message: '请先创建手势密码', className: 'inexa'});
				}
			},
			firstChange(data) {
				if (data.length < 6) {
					this.notice = '请绘制至少六位手势图案';
				} else {
					this.gesturePwd = data;
					this.notice = '请再次确认手势密码';
				}
			},
			secondChange(data) {
				if (this.gesturePwd.toString() == data.toString()) {
					this.elForm.userCode = JSON.parse(localStorage.getItem('user')).employeeCode;
					this.elForm.gesture = data.toString();
					if (this.title == '创建手势密码') {
						this.$postRequest(`${this.$config.YDMH}appGesture`, {
							...this.elForm
						}).then(res => {
							this.$toast({message: '手势密码创建成功', className: 'inexa'});
              this.$router.back(-1);
						}).catch(() => {
						});
					} else {
						this.$postRequest(`${this.$config.YDMH}appGesture`, {
							...this.elForm
						}).then(res => {
              this.$toast({message: '手势密码修改成功', className: 'inexa'});
							this.$router.back(-1);
						}).catch(() => {

						});
					}
					localStorage.setItem('isGesturePwd', '1');
				} else {
          this.gesturePwd = [];
					// this.notice = '与上次绘制图案不同，请重新绘制';
          this.notice = '与上次绘制图案不同，请重新重建手势密码';
				}

			},
		},
	}
</script>

<style scoped lang="scss">
	.hor-center {
		padding-top: 70px;
		margin: 0 auto;
		text-align: center;

		.notice {
			font-size: 20px;
			color: orangered;
		}

		img {
			margin-top: 15px;
			margin-bottom: 15px;
		}

		.notice-sub {
			font-size: 15px;
			color: #206EEA;
		}
	}
</style>
