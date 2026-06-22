<template>
	<div class="tab-page has-header tab1">
		<div class="tab-header tab1-z-index">
			<mt-header title="掌上国神" class="bb" fixed>
				<!--				<mt-button slot="left" class="text-size-12"-->
				<!--					style="height: 25px; border: 1px solid white;padding-left: 3px; padding-right: 3px; vertical-align: middle; line-height: 25px;">-->
				<!--					安全连接</mt-button>-->
				<mt-button slot="right" data-intro="1、扫一扫：用于二维码等常用信息的展示"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击扫一扫的按钮', actionType:'scan-click'}"
					@click="scan()">
					<img src="../assets/images/home/scanner.png" height="25" width="25"
						style="vertical-align: middle" />
				</mt-button>
			</mt-header>
		</div>
		<div class="tab-content pr tab-margin-top" @scroll="scrollEvent" ref="tabscroll">
			<van-pull-refresh v-model="refreshing" @refresh="onRefresh">
				<div v-for="(item,index) in mainList">
					<Banner :componentList="item" v-if="item.componentType == 'banner'
					&& item.isShow == '1' " />
					<commonapp :componentList="item" :user="user"
						v-else-if="item.componentType == 'applicationView' && item.isShow == '1' " />
					<noticelist :componentList="item" :user="user"
						v-else-if="item.componentType == 'announcement' && item.isShow == '1' " />
					<meetinglist :componentList="item" :user="user"
						v-else-if="item.componentType == 'meetingSummary' && item.isShow == '1' " />
					<noticeScroll :componentList="item" :user="user"
						v-else-if="item.componentType == 'rollingNotice' && item.isShow == '1' " />
					<messagescroll :componentList="item" :user="user" :swiperList="swiperList"
						v-else-if="item.componentType == 'rollingMessage' && item.isShow == '1' " />
				</div>
			</van-pull-refresh>
		</div>
	</div>
</template>

<script>
	import commonapp from "../components/application/commonapp.vue";
	import noticelist from "../components/application/noticelist.vue";
	import meetinglist from "../components/application/meetinglist.vue";
	import noticeScroll from "../components/application/noticescroll.vue";
	import messagescroll from "../components/application/messagescroll.vue";
	export default {
		name: "Tab1",
		components: {
			commonapp,
			noticelist,
			meetinglist,
			noticeScroll,
			messagescroll
		},
		data() {
			return {
				mainList: [],
				positionId: [],
				user: JSON.parse(localStorage.getItem('user')),
				refreshing: false,
				// fileName: "jtmhapp.apk",
				apkFileUrl: '',
				scroll: '',
				swiperList: [],
			}
		},
		created() {
			// 获取消息中心
			this.loadList();
			this.positionId = this.user.positionId.split(",");
			this.getMainTemp();
		},
		mounted() {
			// window.addEventListener("scroll",this.handleScroll, true);
			// 点击消息滚动图，查看详情
			let that = this;
			this.bus.$on('triggerMessageScroll', function(item) {
				console.log(item);
				let info = JSON.parse(item.appInfo);
				let appParam = JSON.parse(item.appParam);
				if (info.name === '生产日报' && info.name == '手机报') {
					that.$toast({
						message: '暂不支持该类型消息直达,消息内容请前往我的消息查看',
						className: 'inexa'
					});
					return;
				}
				that.$postFormRequest(`${this.$config.YDMH}jgMessage/changeRead`, {
					channelId: item.channelId,
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
					if (info.name == '手机报') {
						that.$router.push({
							name: appParam.url,
							params: {
								id: appParam.id,
								isLoadLocalData: false,
							}
						});
					} else if (info.name === '生产日报') {
						that.$router.push({
							name: appParam.url,
							params: {
								sendDay: appParam.data
							}
						});
					}
				}).catch(() => {

				});
			});
			this.bus.$on('gotoTab3', function() {
				that.$emit('tab3-active', 'tab-container3');
			});
			this.bus.$on('changeReadStatus', function() {
				console.log('tab1 mounted changeReadStatus');
				that.loadList();
			});
			// 5min 获取一次消息中心
			setTimeout(function() {
				console.log('定时获取消息中心内容');
				that.loadList();
			}, 5 * 1000);
		},
		activated() {
			this.$refs.tabscroll.scrollTop = this.scroll;
			console.log('tab1 activated');
			// 刷新消息中心数据
			this.loadList();
		},
		destroyed() {
			// document.removeEventListener('scroll', this.handleScroll)
		},
		methods: {
			// handleScroll() {
			//   console.log('滚动滚动');
			// },
			scrollEvent() {
				let scroll_height = this.$refs.tabscroll.scrollTop;
				this.scroll = scroll_height;
			},
			scan() {
				ScanCodePlugin.scan(3, success, error);

				function success(datas) {
					console.log('扫码数据 ', datas);
				}

				function error(errorMsg) {
					console.log('扫码数据失败 ', errorMsg);
				}
			},
			onRefresh() {
				this.loadList();
				this.getMainTemp();
			},
			moreDealtList() {
				this.$router.push('/dealtlist');
			},
			appEdit() {
				this.$router.push({
					name: 'appedit'
				});
			},
			iconBtn(item) {
				this.$router.push(item.path);
			},
			lookNotice(item) {
				this.$router.push({
					name: 'noticeinfo',
					params: {
						item: item
					}
				});
			},
			// 消息中心
			loadList() {
				this.$getRequest(`${this.$config.YDMH}jgMessage/find`, {
					pageNo: 1,
					pageSize: 1000,
					content: this.search,
					type: this.type,
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
					this.swiperList = res.list;
					for (let i = 0; i < this.swiperList.length; i++) {
						this.swiperList[i].createTime = this.$base.formatDate(this.swiperList[i].createTime);
						// console.log(this.swiperList[i].type);
						// 	// for(var j = 0; j < this.optionsList.length; j++){
						// 	//     if(this.messagetList[i].type == this.optionsList[j].id){
						// 	//         this.messagetList[i].readType = this.optionsList[j].label
						// 	//     }
						// 	// }
					}
					this.bus.$emit('reloadRedDot');
				}).catch(() => {});
			},
			getMainTemp() {
				this.$postRequest(`${this.$config.YDMH}homeManage/findTemplateByAuthority`, {
					userCode: this.user.employeeCode,
					orgCode: this.user.orgCode,
					positionIdList: this.positionId,
				}).then(res => {
					this.mainList = res.object.componentList;
					this.refreshing = false;
				}).catch(() => {
					this.refreshing = false;
				});
			},
		},
	}
</script>

<style lang="scss">
	.tab-margin-top {
		margin-top: 45px;
	}

	.tab1-z-index {
		position: absolute;
		z-index: 999999;
	}

	.scroll-title {
		width: 25px;
		height: 40px;
		float: left;
		line-height: 20px;
		margin-top: 10px;
		margin-bottom: 10px;
		margin-left: 10px;
		padding-left: 5px;
		padding-right: 5px;
		text-align: center;
		font-size: 12px;
	}

	.scroll-line {
		width: 1px;
		height: 20px;
		margin-left: 10px;
		flex: 1;
		flex: 0 0 0.5%;
	}

	.van-tabs--line .van-tabs__wrap {
		height: 44px;
		margin-bottom: 0 !important;
	}

	//.scroll-line-t {
	//	width: 1px;
	//	height: 30px;
	//	margin-left: 10px;
	//}

	.cy {
		height: 25px;
		margin-top: 5px;
		padding-top: 10px;
		margin-bottom: 10px
	}

	.message {
		margin-left: 8px;
		height: 100%;
		width: 60px;
		flex: 1;
		flex: 0 0 15%;
		line-height: 60px
	}

	.swipervertical {
		height: 60px;
		margin-left: 10px;
		margin-right: 10px;

		/*border-radius: 10px ;*/
		/*background: white;*/
		.swiper {
			line-height: 60px;
			margin-left: 5px;
			flex: 1;
		}
	}

	.vertical-center {
		position: relative;
		transform: translateY(-50%);
		top: 50%;
	}

	.no_data_div {
		margin-left: 15px;
		color: #9c9c9c;
		font-size: smaller;
		position: relative;
	}

	.red-dot-div {
		float: right;
		width: 6px;
		height: 6px;
		position: relative;
		transform: translateY(-50%);
		top: 35%;
		background: red;
		border-radius: 50%;
	}

	.tab-page .tab-content {
		background-color: white;
		// background: url("../assets/images/globle/globle-bg.jpg");
	}

	.icon-bt {
		margin-left: 5px;
		line-height: 25px;
		display: inline;
		/*color: #000;*/
	}

	.icon-edit {
		/*font-size: 14px;*/
		/*color: #6B6B6B;*/
		float: right;
		margin-right: 15px;
		line-height: 25px;
		display: inline;
	}

	.load-more {
		text-align: center;
		padding: 10px;
	}
</style>
