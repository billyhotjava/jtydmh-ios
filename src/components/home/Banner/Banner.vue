<template>
	<mt-swipe :bannerList="bannerList" :auto="4000" v-show="bannerList.length>0">
		<mt-swipe-item v-for="(item,index) in bannerList" :key="index">
			<img :src="getImgUrl(item)" alt="banner">
			<!-- <van-image lazy-load :src="item"> -->
			  <template v-slot:loading>
			    <van-loading type="spinner"/>
			  </template>
<!--			</van-image>-->
		</mt-swipe-item>
	</mt-swipe>
</template>

<script>
	export default {
		name: "Banner",
		props: {
			componentList: Object,
		},
		data() {
			return {
				bannerList: []
			}
		},
		created() {
			this.getBannerList();
		},
		methods: {
			getBannerList() {
				let that = this;
				let banner = this.componentList.bannerPictureList;
				if (banner.length > 0) {
					banner.forEach((value, index) => {
						that.bannerList.push(
							`${this.$config.YDMH}transformDownload/download?type=2&fileId=${value.pictureId}`);
						// this.$getRequest(
						//     // `${this.$config.FILE_IP}file/${value.pictureId}/presignedurl`)
						//     `${this.$config.YDMH}transformDownload/download`, {
						//         type: 2,
						//         fileId: value.pictureId
						//     })
						// 	.then(res1 => {
						// 	  console.log("banner", res1);
						// 		that.bannerList.push(res1);
						// 	}).catch(() => {
						//
						// 	})
					})
				} else {

				}
			},
			getImgUrl(url) {
				console.log(url);
				let img = this.$check.check('banner');
				if (img != null) {
					console.log('获取成功了');
					return img;
				}else{
					return item.imageUrl;
				}
			}
		}
	}
</script>

<style lang="scss">
	.mint-swipe {
		height: 36vw;
		margin: 1rem 0.7rem 0;
		margin: 1rem auto 0;
		margin-top: 5px;
		width: 95%;
		border-radius: 5px;
	}

	.mint-swipe-item {
		img {
			height: 100%;
			width: 100%;
		}
	}

	.mint-swipe-indicators {
		/*right: 0.3rem;*/
		/*left: unset;*/

		.mint-swipe-indicator {
			width: 9px;
			height: 9px;
			margin: 0 .25rem;
			background-color: #fff;
			opacity: 1;
			border-radius: 5px;

			&.is-active {
				background-color: #427fed;
			}
		}

	}
</style>
