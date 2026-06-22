<template>
	<!--列表组件-->
	<div data-intro="5、通知公告">
		<div class="mt1rem bgwhite">
			<div class="cy background-white">
				<img v-if="imageSrc != ''" :src="getImgUrl(imageSrc)" height="25" width="25"
					style="float: left; margin-left: 5px;" />
				<img v-else src="../../assets/images/application/placeholder_image.png" height="25" width="25"
					style="float: left; margin-left: 5px;">
				<div class="icon-bt text-color-black text-size-16" style="font-weight: bold">通知公告</div>
				<img src="../../assets/images/keyword.png" height="20" width="20"
					style="float: right; margin-right: 5px;margin-top: 3px;" @click="showPop()"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击通知公告的关注公告设置的图标', actionType:'notice-like-notice-setting-click'}" />
			</div>
			<NavBar :tabsList="tabList" :NoticeList="noticeList" :showCustomLoading="showCustomLoading" v-on:isSelected="showNoticeSelected"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击切换通知公告Tab的按钮', actionType:'notice-tab-click'}" />
      <div v-if="noticeList.length != 0 && componentList.loadMore == '1'">
				<div class="load-more  text-size-14" v-if="hasMore" @click="loadMoreNotice"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击通知公告的加载更多的按钮', actionType:'notice-loading-more-click'}">
					点击加载更多</div>
				<div class="load-more  text-size-14" v-else>暂无更多数据</div>
			</div>
		</div>

		<mt-popup v-model="isGjcShow" class="popup">
			<div class="pop-title">关注公告设置</div>
			<div class="pop-notice">提示：
				请输入您关注的关键词，多个关键词以逗号分割，例如“安全，生产，检查”。系统将为您选出标题中含有该关键词的公告。</div>
			<input v-model="gjcModel" />
			<button @click="confirm()"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击关注公告设置的确定按钮', actionType:'like-notice-settings-ok-click'}">确定</button>
		</mt-popup>
	</div>
</template>

<script>
	export default {
		name: "noticelist",
		props: {
			componentList: Object,
			user: Object,
		},
		data() {
			return {
				tabList: [{
						propId: "jtnotice",
						propName: "集团公告",
						selectProp: 1,
					},
					{
						propId: "gsnotice",
						propName: "公司公告",
						selectProp: 2,
					},
					{
						propId: "bbnotice",
						propName: "本部公告",
						selectProp: 5,
					},
					{
						propId: "gznotice",
						propName: "关注公告",
						selectProp: 6,
					},
				],
				positionId: [],
				noticeList: [],
        // 首次进入tab1，加载本地集团公告数据，控制自定义loading
        showCustomLoading: true,
				listData: [],
				tabSelect: 1,
				pageNum: 1,
				hasMore: true,
				imageSrc: `${this.$config.YDMH}transformDownload/download?type=2&fileId=${this.componentList.componentIconId}`,
				isGjcShow: false,
				gjcModel: '',
			}
		},
		created() {
			// this.getImage();
      // 首次进入tab1时，显示缓存数据，并加载自定义的loading
      if (this.pageNum == 1 && this.noticeList.length == 0) {
        let localData = localStorage.getItem('jituangonggaoCache');
        if (localData) {
          console.log('加载本地缓存的集团公告');
          this.noticeList = JSON.parse(localData);
        }
      }
      this.queryNoticeList();
		},
		methods: {
			// getImage() {
			// 	this.$getRequest(
			// 			`${this.$config.FILE_IP}file/${this.componentList.componentIconId}/presignedurl`)
			// 		.then(res1 => {
			// 			console.log('-----------------123123');
			// 			console.log(res1);
			// 			this.imageSrc = res1.presignedAgentUrl;
			// 		}).catch(() => {
			//
			// 		});
			// },
			showNoticeSelected(selected) {
				this.tabSelect = this.tabList[selected].selectProp;
				this.pageNum = 1;
				this.queryNoticeList();
			},
			queryNoticeList() {
				this.hasMore = true;
				if (this.tabSelect == 5) {
					this.$getRequest(
						`${this.$config.YDMH}external/listAnnouncementByEmployeeCode`, {
							employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode,
							pageNo: this.pageNum,
							pageSize: 10
						}).then(res => {
						// 加载状态结束
            this.showCustomLoading = false;
						this.loading = false;
						if (res.list == null && res.list.length == 0) {
							this.hasMore = false;
						} else {
							if (this.pageNum == 1) {
								this.listData = [];
								this.noticeList = [];
								this.listData = this.listData.concat(res.list);
								let newlist = this.listData.slice(0, this.componentList.location);
								this.noticeList = this.noticeList.concat(newlist);
							} else {
								this.listData = this.listData.concat(res.list);
								this.noticeList = this.noticeList.concat(this.listData.slice(
									this.noticeList.length, this.noticeList.length + 10));
							}
						}
					}).catch(() => {

					});
				} else if (this.tabSelect == 6) {
					this.$getRequest(
						`${this.$config.YDMH}external/announcementSearch`, {
							employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode,
						}).then(res => {
						// 加载状态结束
            this.showCustomLoading = false;
						this.loading = false;
						if (res.list == null && res.list.length == 0) {
							this.hasMore = false;
						} else {
							if (this.pageNum == 1) {
								this.listData = [];
								this.noticeList = [];
								this.listData = this.listData.concat(res.list);
								let newlist = this.listData.slice(0, this.componentList.location);
								this.noticeList = this.noticeList.concat(newlist);
							}
						}
					}).catch(() => {

					});
				} else {
					this.$postRequestQuery(`${this.$config.YDMH}news/getCEList`, {
							type: this.tabSelect,
							pageNum: this.pageNum
						}).then(res => {
            this.showCustomLoading = false;
            console.log('去掉自定义loading，加载获取到的集团公告数据');
						if (res.list == null || res.list.length == 0) {
							this.hasMore = false;
						} else {
							if (this.pageNum == 1) {
								this.listData = [];
								this.noticeList = [];
								this.listData = this.listData.concat(res.list);
								let newlist = this.listData.slice(0, this.componentList.location);
								this.noticeList = this.noticeList.concat(newlist);
							} else {
								this.listData = this.listData.concat(res.list);
								this.noticeList = this.noticeList.concat(this.listData.slice(
									this.noticeList.length, this.noticeList.length + 10));
							}
						}
            // 集团公告缓存数据
            if (this.tabSelect == 1) {
              localStorage.setItem('jituangonggaoCache', JSON.stringify(this.noticeList));
            }
					}).catch(() => {

					});
				}

			},
			loadMoreNotice() {
				if (this.noticeList.length < this.listData.length) {
					this.noticeList = this.noticeList.concat(this.listData.slice(
						this.noticeList.length, this.noticeList.length + 10));
				} else {
					if (this.tabSelect == 6) {
						this.hasMore = false;
					} else {
						this.pageNum += 1;
						console.log("load more");
						this.queryNoticeList();
					}
				}
			},
			showPop() {
				this.isGjcShow = true;
				this.getAnntSearchKey();
			},
			getAnntSearchKey() {
				this.$getRequest(`${this.$config.YDMH}/external/getAnntSearchKey`, {
					employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
					this.gjcModel = res.object;
				}).catch(() => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log('保存公告关键词接口失败', error);
				});
			},
			confirm() {
				if (this.gjcModel == '') {
					this.$toast({
						message: '请输入您关注的关键词，多个关键词以逗号分割',
						className: 'inexa'
					});
					return;
				}
				let user = JSON.parse(localStorage.getItem('user'));
				this.$postFormRequest(`${this.$config.YDMH}external/updateAnntSearchKey`, {
					employeeCode: user.employeeCode,
					searchKey: this.gjcModel
				}).then(res => {
					if (res.success == true) {
						this.isGjcShow = false;
						this.$toast({
							message: '关注公告的设置已更新',
							className: 'inexa'
						});
					}
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log('保存公告关键词接口失败', error);
				});
			},
			getImgUrl(url) {
				let img = this.$check.check('通知公告');
				if (img != null) {
					console.log();
					return img;
				}else{
					return url;
				}
			}
		}
	}
</script>

<style lang="scss">
	.cy {
		height: 25px;
		margin-top: 5px;
		padding-top: 10px;
		margin-bottom: 10px
	}

	.load-more {
		text-align: center;
		padding: 10px;
	}

	.popup {
		width: 70%;
		padding: 30px;
		border-radius: 1px;
		position: fixed;
		border-radius: 5px;

		.pop-title {
			text-align: center;
			font-size: 16px;
			margin-bottom: 20px;
		}

		.pop-notice {
			color: orangered;
			font-size: 13px;
			margin-bottom: 15px;
		}


		input {
			width: 92%;
			padding: 10px;
			font-size: 14px;
			border: 1px solid #999999;
			border-radius: 5px;
			outline: none;
		}

		button {
			width: 100%;
			padding: 10px;
			background: #579FF8;
			color: white;
			font-size: 16px;
			border: 0;
			border-radius: 5px;
			margin-top: 20px;
			outline: none;
		}
	}
</style>
