<template>
	<div id="exit" class="home">

		<mt-tab-container v-model="selected">
			<mt-tab-container-item id="tab-container1">
				<Tab1 v-on:tab3-active="tab3Active" v-if="!openOld"/>
				<TabOld v-on:tab3-active="tab3Active" v-else/>
			</mt-tab-container-item>
			<mt-tab-container-item id="tab-container2" v-if="!openOld">
				<Tab2 :selected="selected" />
			</mt-tab-container-item>
			<mt-tab-container-item id="tab-container3">
				<Tab3 :selected="selected" />
			</mt-tab-container-item>
			<mt-tab-container-item id="tab-container4">
				<Tab4 :selected="selected" />
			</mt-tab-container-item>
		</mt-tab-container>

		<mt-tabbar v-model="selected" v-show="hidshow">
			<!--fixed-->
			<mt-tab-item id="tab-container1" data-intro="7、门户主页：应用首页展示应用减略信息"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击Tabbar主页的按钮', actionType:'home-tabbar-click'}">
				<div class="mint-tab-item-icon">
					<img v-if="selected == 'tab-container1'" slot="icon"
						src="../assets/images/globle/home_selected.png" />
					<img v-else slot="icon" src="../assets/images/globle/home_nomal.png" />
				</div>
				主页
			</mt-tab-item>
			<mt-tab-item v-if="!openOld" id="tab-container2" data-intro="8、应用中心：所有应用软件展示，可跳转到第三方应用，对应用展示顺序进行修改"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击Tabbar应用的按钮', actionType:'application-tabbar-click'}">
				<div class="mint-tab-item-icon">
					<img v-if="selected == 'tab-container2'" slot="icon"
						src="../assets/images/globle/application_selected.png" />
					<img v-else slot="icon" src="../assets/images/globle/application_nomal.png" />
				</div>
				应用
			</mt-tab-item>
			<mt-tab-item id="tab-container3" data-intro="9、消息中心：对所有我的消息信息的展示查看"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击Tabbar消息的按钮', actionType:'message-tabbar-click'}">
				<div class="mint-tab-item-icon">
					<img v-if="selected == 'tab-container3'" slot="icon"
						src="../assets/images/globle/message_selected.png" />
					<img v-else slot="icon" src="../assets/images/globle/message_nomal.png" />
				</div>
				消息
			</mt-tab-item>
			<mt-tab-item id="tab-container4" data-intro="10、个人中心：可对用户信息查看，头像进行修改，设置密码等操作"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击Tabbar设置的按钮', actionType:'settings-tabbar-click'}">
				<div class="mint-tab-item-icon">
					<img v-if="selected == 'tab-container4'" slot="icon"
						src="../assets/images/globle/set_selected.png" />
					<img v-else slot="icon" src="../assets/images/globle/set_nomal.png" />
				</div>
				设置
			</mt-tab-item>
		</mt-tabbar>

		<mt-popup v-model="isGPShow" class="gp-popup" :closeOnClickModal="closeOnClickModal">
			<h3>请先设置手势密码才能使用</h3>
			<button href="javascript:;" @click="GesturePwd()">前往设置 》</button>
		</mt-popup>
	</div>
</template>

<script>
	import Tab1 from "./Tab1";
	import Tab2 from "./Tab2";
	import Tab3 from "./Tab3";
	import Tab4 from "./Tab4";
	import TabOld from "./TabOld";
	export default {
		name: 'Home',
		components: {
			Tab4,
			Tab3,
			Tab2,
			Tab1,
			TabOld
		},
		data() {
			return {
				selected: 'tab-container1',
				isGPShow: false,
				closeOnClickModal: false,
				isYZPwdShow: false,
				docmHeight: document.documentElement.clientHeight, //默认屏幕高度
				showHeight: document.documentElement.clientHeight, //实时屏幕高度
				hidshow: true, //显示或者隐藏footer,
				isResize: false, //默认屏幕高度是否已获取
				openOld: false
			}
		},
		mounted() {
		  console.log('home mounted');
			let status = localStorage.getItem('openOld');
			if (status!= null) {
				if (status == 1) {
					this.openOld = true;
				}
			}
			let that = this;
			window.onresize = () => {
				// console.log("进入  Home mounted");
				return (() => {
					// console.log("！！！！！！！！！！！！！！ 进入");
					if (!that.isResize) {
						// console.log("！！！！！！！！！！！！！！ that.isResize 为空");
						//默认屏幕高度
						that.docmHeight = document.documentElement.clientHeight;
						that.isResize = true;
						// console.log("默认屏幕高度", that.docmHeight);
					}
					//实时屏幕高度
					that.showHeight = document.documentElement.clientHeight;
					// console.log("实时屏幕高度", that.showHeight);
				})()
			};
			if (localStorage.getItem('intro') == '0') {
				var introJS = require('intro.js');
				introJS().setOptions({
					prevLabel: "上一步",
					nextLabel: "下一步",
					skipLabel: "跳过",
					doneLabel: "结束引导",
					/* 当位置选择自动的时候，位置排列的优先级 */
					positionPrecedence: ["top", "right", "left", "bottom"],
					tooltipPosition: 'top',
				}).onbeforechange((e) => {

				}).onexit(() => {
					// this.isGPShow = true;
					localStorage.setItem('intro', '1');

				}).start();
			}
			if (localStorage.getItem('isGesturePwd') == '1') {
				this.isGPShow = false;
			} else {
				this.isGPShow = true;
			}
			//厂商通道消息使用
      if (window.device.platform == 'Android') {
        //厂商通道消息使用
        AppUtilsPlugin.isMain(true);
      } else {
        console.log('Home 调整状态栏颜色');
        StatusBar.backgroundColorByHexString('#3072E2');
      }
		},
		methods: {
			GesturePwd() {
				this.isGPShow = false;
				localStorage.setItem('isGesturePwd', '0');
				this.$router.push({
					name: 'gesturelock',
				});
			},
			tab3Active: function(active) {
				this.selected = active;
			},
		},
		watch: {
			showHeight() {
				// console.log("监听 docmHeight", this.docmHeight);
				// console.log("监听 showHeight", this.showHeight);
				if (this.docmHeight >= this.showHeight) {
					this.hidshow = false;
				} else {
					this.hidshow = true;
				}
				// console.log("显示隐藏", this.hidshow);
			}
		},
	}
</script>

<style lang="scss">
	.mint-tab-item-icon {
		font-size: 24px;
	}

	.mint-tabbar,
	.mint-tabbar>.mint-tab-item.is-selected {
		background-color: #fff !important;
		color: #206EEA !important;
	}


	a {
		color: #616161;
	}

	.gp-popup {
		width: 70%;
		/*height: 50%;*/
		padding: 10px;
		border-radius: 10px;

		h3 {
			text-align: center;
			margin-top: 20px;
		}

		button {
			margin-top: 20px;
			margin-bottom: 20px;
			font-size: 16px;
			background: white;
			color: #206EEA;
			border: 0;
			/*border-bottom: 1px solid #206EEA;*/
			padding: 10px;
			position: relative;
			left: 50%;
			transform: translateX(-50%);
			outline: none;
		}
	}
</style>
