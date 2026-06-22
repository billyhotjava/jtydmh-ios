<template>
	<!--常用应用-->
	<div data-intro="3、常用应用：用户常使用到的应用，可到应用编辑页面去修改">
		<div class="cy background-white">
			<img v-if="imageSrc != ''" :src="getImgUrl(imageSrc)" height="25" width="25" style="float: left; margin-left: 15px;" />
			<img v-else src="../../assets/images/application/placeholder_image.png" height="25" width="25"
				style="float: left; margin-left: 15px;">
			<div class="icon-bt text-color-black text-size-16" style="font-weight: bold">常用应用</div>
			<div class="icon-edit cy-edit-color text-size-14" @click="appEdit()"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击常用应用的编辑按钮', actionType:'application-edit-click'}">
				编辑</div>
		</div>
		<div class="commonapp-nodata-div" v-if="iconBtnList.length == 0" @click="appEdit">
			<div class="commonapp-nodata-tip1-div">
				您还未添加常用应用
			</div>
			<div>
				>> 点我立刻添加 << </div>
			</div>
			<IconBtn :iconBtnList="iconBtnList" />
		</div>
</template>

<script>
	export default {
		name: "commonapp",
		props: {
			componentList: Object,
			user: Object,
		},
		data() {
			return {
				positionId: [],
				iconBtnList: [],
				imageSrc: `${this.$config.YDMH}transformDownload/download?type=2&fileId=${this.componentList.componentIconId}`
			}
		},
		created() {
			this.getAPPList();
			// this.getImage();
			let that = this;
			this.bus.$on('refresh', function() {
				that.getAPPList();
			});
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
			getAPPList() {
				let that = this;
				this.positionId = this.user.positionId.split(",");
				this.$postRequest(`${this.$config.YDMH}application/obtainCommonUseApplication`, {
					userCode: this.user.employeeCode,
					orgCode: this.user.orgCode,
					positionIdList: this.positionId,
				}).then(res2 => {
					that.iconBtnList = [];
					res2.list.forEach((value) => {
						that.iconBtnList.push(value);
					});
					if (res2.list.length > 0) {
						res2.list.forEach((value, index) => {
							that.iconBtnList.splice(index, 1, {
								name: value.name,
								url: `${this.$config.YDMH}transformDownload/download?type=2&fileId=${value.iconAttachmentId}`,
								path: value.appPath
							});


							// this.$getRequest(
							// 	`${this.$config.FILE_IP}file/
							// 					${value.iconAttachmentId}/presignedurl`
							// ).then(res3 => {
							//   that.iconBtnList.splice(index, 1, {
							//     name: value.name,
							//     url: res3.presignedAgentUrl,
							//     path: value.appPath
							//   });
							// }).catch(() => {
							//
							// })
						})
					} else {

					}
				}).catch(() => {

				});
			},
			appEdit() {
				this.$router.push({
					name: 'appedit'
				});
			},
			getImgUrl(url) {
				let img = this.$check.check('常用应用');
				if (img != null) {
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

	.commonapp-nodata-div {
		text-align: center;
		font-size: 13px;
		color: #206EEA;
		padding-top: 10px;
		padding-bottom: 12px;
	}

	.commonapp-nodata-tip1-div {
		margin-bottom: 6px;
	}
</style>
