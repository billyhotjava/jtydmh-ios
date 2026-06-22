<template>
	<!-- 通知公告滚动组件 -->
	<div data-intro="2、通知公告：">
		<div class="swipervertical background-tzgg"
			style="margin-top: 10px; display: flex; align-items: center;">
			<img src="../../assets/images/home/tzgg.png" height="25" width="25"
				style="flex: 1; flex: 0 0 1%;; margin-left: 13px" />
			<div class="scroll-line background-tzgg-line"></div>
			<SwiperVertical v-if="swiperList != undefined && swiperList.length != 0" :swiperList="swiperList"
				:lineNum="noticeNum" :height="height" class="vertical-center swiper" />
			<div class="no_data_div" v-else>暂无消息</div>
		</div>
	</div>
</template>

<script>
	import application_placeholder_image from '@/assets/images/application/placeholder_image.png'
	export default {
		name: "mettinglist",
		props: {
			componentList: Object,
			user: Object,
		},
		data() {
			return {
				positionId: [],
				noticeNum: 0, //通知公告滚动条数
				swiperList: [],
				
			}
		},
		mounted() {

		},
		methods: {
			getImage() {
				this.$getRequest(
						`${this.$config.FILE_IP}file/${componentList.componentIconId}/presignedurl`)
					.then(res1 => {
						this.imageSrc = res1.presignedAgentUrl;
					}).catch(() => {

					})
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
</style>
