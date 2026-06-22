<template>
	<!--列表组件-->
	<div data-intro="5、通知公告">
		<div class="mt1rem bgwhite">
			<div class="cy background-white">
				<img :src="getImgUrl(componentList)" height="25" width="25"
					style="float: left; margin-left: 5px;" />
			<!-- 	<img v-else src="../../assets/images/application/placeholder_image.png" height="25" width="25"
					style="float: left; margin-left: 5px;"> -->
				<div class="icon-bt text-color-black text-size-16" style="font-weight: bold">会议纪要</div>
			</div>
			<NavBar :tabsList="tabList" :NoticeList="meetingList" :showCustomLoading="showCustomLoading" v-on:isSelected="showMeetingSelected" v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击切换会议纪要的Tab的按钮`, actionType:'metting-tab-click'}"/>
			<div v-if="meetingList.length != 0 && componentList.loadMore == '1'">
				<div class="load-more bb text-size-14" v-if="hasMore" @click="loadMoreMeeting" v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击会议纪要的加载更多的按钮', actionType:'meeting-loading-more-click'}">点击加载更多</div>
				<div class="load-more bb text-size-14" v-else>暂无更多数据</div>
			</div>
		</div>
	</div>
</template>

<script>
	export default {
		name: "mettinglist",
		props: {
			componentList: Object,
			user: Object,
		},
		data() {
			return {
				tabList: [{
						propId: "earlymeeting",
						propName: "早调会纪要",
						selectProp: 3,
					},
					{
						propId: "weekmeeting",
						propName: "例会纪要",
						selectProp: 4,
					},
				],
				positionId: [],
				meetingList: [],
        // 首次进入tab1，加载本地会议纪要数据，控制自定义loading
        showCustomLoading: true,
				listData: [],
				tabSelect: 3,
				pageNum: 1,
				hasMore: true,
			}
		},
		mounted() {
			// this.getImage();
      // 首次进入tab1时，显示缓存数据，并加载自定义的loading
      if (this.pageNum == 1 && this.meetingList.length == 0) {
        let localData = localStorage.getItem('huiyijiyaoCache');
        if (localData) {
          console.log('加载本地缓存的集团公告');
          this.meetingList = JSON.parse(localData);
        }
      }
      this.queryMeetingList();
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
			showMeetingSelected(selected) {
				console.log(selected);
				this.tabSelect = this.tabList[selected].selectProp;
				this.pageNum = 1;
				this.queryMeetingList();
			},
			queryMeetingList() {
				this.$postRequestQuery(
					`${this.$config.YDMH}news/getCEList`, {
						type: this.tabSelect,
						pageNum: this.pageNum
					}).then(res => {
					console.log(res.list);
          this.showCustomLoading = false;
          console.log('去掉自定义loading，加载获取到的会议纪要数据');
					if (res.list == null || res.list.length == 0) {
						this.hasMore = false;
					} else {
						if (this.pageNum == 1) {
							this.listData = [];
							this.meetingList = [];
							this.listData = this.listData.concat(res.list);
							let newlist = this.listData.slice(0, this.componentList.location);
							this.meetingList = this.meetingList.concat(newlist);
						} else {
							this.listData = this.listData.concat(res.list);
							this.meetingList = this.meetingList.concat(this.listData.slice(
								this.meetingList.length, this.meetingList.length + 10));
						}
					}
          // 集团公告缓存数据
          if (this.tabSelect == 3) {
            localStorage.setItem('huiyijiyaoCache', JSON.stringify(this.meetingList));
          }
				}).catch(() => {

				});
			},
			loadMoreMeeting() {
				if (this.meetingList.length < this.listData.length) {
					this.meetingList = this.meetingList.concat(this.listData.slice(
						this.meetingList.length, this.meetingList.length + 10));
				} else {
					this.pageNum += 1;
					this.queryMeetingList();
				}
			},
			getImgUrl(item) {
				let img = this.$check.check(item.componentName);
				console.log('会议纪要名称'+ item.componentName);
				if (img != null) {
					console.log('会议纪要成功了');
					return img;
				}else{
					return `${this.$config.YDMH}transformDownload/download?type=2&fileId=${this.componentList.componentIconId}`;
				}
			},
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
</style>
