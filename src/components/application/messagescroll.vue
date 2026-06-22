<template>
	<!-- 我的消息滚动组件 -->
	<div data-intro="4、消息中心：">
		<div style=";margin: 10px;display: flex; align-items: center;background: #EAF3FA;padding: 10px">
			<img src="../../assets/images/home/message_center.png" style="width: 25px;height: 25px;margin-left: 10px"
				@click="gotoTab3" />
			<div @click="gotoTab3">
				<div class="red-dot-div" v-show="showRetDot"></div>
				<div style="margin-left: 8px;width: 60px;font-size: 13px;color: #206EEA;">消息中心</div>
			</div>
			<div style="width: 2px;height: 20px;margin-left: 5px;background: #206EEA;"></div>
			<SwiperVertical v-if="swiperList != undefined && swiperList.length != 0" :swiperList="swiperList"
				:lineNum=lineNum :height=height style="margin-left: 10px;" />
			<div class="no_data_div" v-else>暂无消息</div>
			<img src="../../assets/images/home/arrow.png"
				style="width: 8px;height: 13px;margin-left: auto; padding-right: 10px" />
		</div>

		<!--<div class="swipervertical background-message"-->
		<!--style="display: flex; align-items: center;">-->
		<!--<img src="../../assets/images/home/message_center.png" height="25" width="25"-->
		<!--style=" margin-left: 10px" @click="gotoTab3"/>-->
		<!--<div style="height: 100%" @click="gotoTab3">-->
		<!--<div class="red-dot-div" v-show="showRetDot"></div>-->
		<!--<div class="message text-message-color text-size-13" style="font-size: 20px">消息中心</div>-->
		<!--</div>-->
		<!--<div class="scroll-line background-blue-2"></div>-->
		<!--<SwiperVertical v-if="swiperList != undefined && swiperList.length != 0" :swiperList="swiperList"-->
		<!--:lineNum=lineNum :height=height class="vertical-center swiper" />-->
		<!--<div class="no_data_div" v-else>暂无消息</div>-->
		<!--&lt;!&ndash;                    <img src="../assets/images/jiantou_right.png" height="25" width="25" class="vertical-center" style="flex: 1; flex: 0 0 5%; margin-right: 10px;"/>&ndash;&gt;-->
		<!--<img src="../../assets/images/arrow.png" height="13" width="8"-->
		<!--style="margin-left: auto; padding-right: 10px" />-->
		<!--</div>-->
	</div>

</template>

<script>
	import application_placeholder_image from '@/assets/images/application/placeholder_image.png'
	export default {
		name: "mettinglist",
		props: {
			componentList: Object,
			user: Object,
			swiperList: Array,
		},
		data() {
			return {
				// swiperList:[],
				showRetDot: false, // 是否显示小红点
				lineNum: 1,
				height: 30,
			}
		},
		mounted() {
			let that = this;
			this.bus.$on('reloadRedDot', function() {
				// setTimeout(function() {
				that.reloadRedDot();
				// },1000);
			});
		},
		methods: {
			getImage() {
				this.$getRequest(`${this.$config.FILE_IP}file/${componentList.componentIconId}/presignedurl`).then(
				res1 => {
					this.imageSrc = res1.presignedAgentUrl;
				}).catch(() => {

				})
			},
			reloadRedDot() {
				console.log("刷新未读消息红点");
				let find = false;
				this.swiperList.forEach((item, index) => {
					// console.log('!!!!', item.type);
					if (item.type == 1) {
						find = true;
						// console.log('!!!!', JSON.stringify(item));
					}
				});
				// if (find) {
				//   console.log('有 未读消息');
				// } else {
				//   console.log('无 未读消息');
				// }
				this.showRetDot = find;
			},
			gotoTab3() {
				this.bus.$emit('gotoTab3');
			},
			appEdit() {
				this.$router.push({
					name: 'appedit'
				});
			},
			showMeetingSelected(selected) {
				this.tabSelect = selected;
				this.pageNum = 1;
				this.queryNoticeList();
			},
			queryMeetingList() {
				//todo 查询通知公告数据
			},
			loadMoreMeeting() {

			},
		},
		watch: {
			swiperList() {
				this.reloadRedDot();
			}
		},
	}
</script>

<style lang="scss">
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
		margin-top: 10px;
		margin-bottom: 10px;

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
		background: red;
		border-radius: 50%;
	}

	.scroll-line {
		width: 1px;
		height: 20px;
		margin-left: 5px;
	}
</style>
