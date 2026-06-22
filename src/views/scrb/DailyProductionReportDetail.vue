<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header :title="title">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
		</div>
		<div class="content-container tab-content">
			<van-tabs v-model="active" animated style="font-size: 14px;font-weight: bold" color="#206EEA" ellipsis="false"
				line-width="25px" title-active-color="#206EEA" title-inactive-color="#7E7E7E"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击切换生产日报Tab的按钮`, actionType:'daily-production-report-tab-click'}">
				<van-tab :title="tabs[0]">
					<div class="text-div" v-html="content['SEND_TEXT']"></div>
				</van-tab>
				<van-tab :title="tabs[1]">
					<div class="image-box">
						<van-image class="form-image" :src="content['IMG_URL1']"
							@click="showPreview([content['IMG_URL1'],content['IMG_URL2']], 0)">
							<template v-slot:loading>
								<van-loading type="spinner" size="20" />
							</template>
						</van-image>
					</div>
					<div class="image-box">
						<van-image class="form-image" :src="content['IMG_URL2']"
							@click="showPreview([content['IMG_URL1'],content['IMG_URL2']], 1)">
							<template v-slot:loading>
								<van-loading type="spinner" size="20" />
							</template>
						</van-image>
					</div>
				</van-tab>
				<van-tab :title="tabs[2]">
					<div class="image-box">
						<van-image class="form-image" :src="content['IMG_URL4']"
							@click="showPreview([content['IMG_URL4'], content['IMG_URL3']], 0)">
							<template v-slot:loading>
								<van-loading type="spinner" size="20" />
							</template>
						</van-image>
					</div>
					<div class="image-box">
						<van-image class="form-image" :src="content['IMG_URL3']"
							@click="showPreview([content['IMG_URL4'], content['IMG_URL3']], 1)">
							<template v-slot:loading>
								<van-loading type="spinner" size="20" />
							</template>
						</van-image>
					</div>
				</van-tab>
				<van-tab :title="tabs[3]">
					<div class="image-box">
						<van-image class="form-image" :src="content['IMG_URL5']"
							@click="showPreview([content['IMG_URL5']], 0)">
							<template v-slot:loading>
								<van-loading type="spinner" size="20" />
							</template>
						</van-image>
					</div>
				</van-tab>
				<!-- <van-tab v-for="(title, index) in tabs" :key="index" :title="title">
					<div class="text-div" v-if="active == 0" v-html="content['SEND_TEXT']"></div>
					<div class="image-box" v-if="active == 1">
						<img class="form-image" :src="content['IMG_URL1']"
							@click="showPreview([content['IMG_URL1']], 0)" />
					</div>
					<div class="image-box" v-if="active == 2">
						<img class="form-image" :src="content['IMG_URL2']"
							@click="showPreview([content['IMG_URL2']], 0)" />
					</div>
					<div class="image-box" v-if="active == 3">
						<img class="form-image" :src="content['IMG_URL3']"
							@click="showPreview([content['IMG_URL3'], content['IMG_URL4']], 0)" />
						<img class="form-image" :src="content['IMG_URL4']" v-if="active == 3"
							@click="showPreview([content['IMG_URL3'], content['IMG_URL4']], 0)" />
					</div>
					<div class="image-box" v-if="active == 4">
						<img class="form-image" :src="content['IMG_URL5']"
							@click="showPreview([content['IMG_URL5']], 0)" />
					</div>
				</van-tab> -->
			</van-tabs>
		</div>
	</div>
</template>

<script>
	import {
		ImagePreview
	} from 'vant';

	export default {
		name: "DailyProductionReportDetail",
		data() {
			return {
				active: 0,
				tabs: [
					'文字说明',
					'发电报表',
					'煤炭报表',
					'新能源报表',
				],
				content: {},
				sendDay: '',
				title: '调度日报'
			}
		},
		mounted() {
			var params = {};
			if (this.$route.params != {} && this.$route.params.hasOwnProperty('sendDay')) {
				params = this.$route.params;
				localStorage.setItem('offlineDailyProductionReportParams', JSON.stringify(params));
			} else {
				params = localStorage.getItem('offlineDailyProductionReportParams');
				params = JSON.parse(params);
				if (params == {}) {
					console.log('！！！ 数据错误');
					return;
				}
			}
			this.title = params.sendDay + '调度日报';
			this.sendDay = params.sendDay;
			this.getProductDailyList();
		},
		methods: {
			getProductDailyList() {
				this.$getRequest(`${this.$config.YDMH}productDaily/getOneProductDailyByDay`, {
					sendDay: this.sendDay
				}).then(res => {
					this.content = res.object;
					this.content['IMG_URL1'] = `${this.$config.YDMH}` + 'transformDownload/download?type=5&url=' +
						this.content['IMG_URL1'];
					this.content['IMG_URL2'] = `${this.$config.YDMH}` + 'transformDownload/download?type=5&url=' +
						this.content['IMG_URL2'];
					this.content['IMG_URL3'] = `${this.$config.YDMH}` + 'transformDownload/download?type=5&url=' +
						this.content['IMG_URL3'];
					this.content['IMG_URL4'] = `${this.$config.YDMH}` + 'transformDownload/download?type=5&url=' +
						this.content['IMG_URL4'];
					this.content['IMG_URL5'] = `${this.$config.YDMH}` + 'transformDownload/download?type=5&url=' +
						this.content['IMG_URL5'];
					// console.log('生产日报详情', JSON.stringify(this.content));
				}).catch(err => {
					console.log('获取生产日报详情失败 ', err);
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			cutout(value) {
				let res = value.replace(/\n\?\n/g, '\n\n');
				console.log(JSON.stringify(res));
				return res;
				// return value.replace(/\,/g, '</br>');
				// return value;
			},
			showPreview(images, index) {
				// this.images = images;
				// this.index = index;
				// this.show = true;
				// console.log(images, index, this.show);
				ImagePreview({
					images: images,
					showIndex: true,
					loop: false,
					startPosition: index,
				});
			},
			onChange(index) {
				this.index = index;
			},
		}
	}
</script>

<style scoped>
	.text-div {
		color: #333333;
		font-size: 14px;
		line-height: 24px;
		white-space: pre-line;
		margin: 30px 10px;
	}

	.image-box {
		margin: 30px 10px 10px 10px;
		width: 95%;
		height: 100%;
	}

	.form-image {
		width: 100%;
		object-fit: contain;
	}
</style>
