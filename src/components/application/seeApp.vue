<template>
	<div>
		<div v-for="(cymenu, index) in cyMenus" :key="index">
			<div style="height: 20px; padding: 10px; display: flex;">
				<div style="font-size: 16px; font-weight: bold; margin-left: 5px; margin-top: 10px">
					{{cymenu.name}}
				</div>
			</div>

			<div class="div-wrap">
				<div v-for="(cyitem, cy) in cymenu.data" :key="cy" class="colum-item" @click="appClick(cyitem)">
					<img v-if="cyitem.url != undefined && cyitem.url.length != 0" :src="getImgUrl(cyitem)" alt="图标"
						class="icon-yy" />
					<img v-else :src='application_placeholder_image' alt="图标" class="icon-yy">
					<div class="icon-name">{{cyitem.name}}</div>
				</div>
			</div>
		</div>

		<div v-for="(allmenu, index1) in allMenus" :key="index1">
			<div style="height: 20px; padding: 10px;">
				<div style="font-size: 16px; font-weight: bold; margin-left: 5px; margin-top: 10px">
					{{allmenu.classifyName}}
				</div>
			</div>

			<div class="div-wrap">
				<div v-for="(allitem, all) in allmenu.applicationList" :key="all" class="colum-item" @click="appClick(allitem)">
					<div>
						<img v-if="allitem.url != undefined && allitem.url.length != 0" :src="getImgUrl(allitem)"
							alt="图标" class="icon-yy">
						<img v-else :src='application_placeholder_image' alt="图标" class="icon-yy">
						<div class="icon-name">{{allitem.name}}</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import application_placeholder_image from '@/assets/images/application/placeholder_image.png'
	export default {
		name: "seeApp",
		data() {
			return {
				user: JSON.parse(localStorage.getItem('user')),
				cyMenus: [],
				allMenus: [],
				positionId: [],
				application_placeholder_image: application_placeholder_image
			}
		},
		created() {

		},
		mounted() {
			this.positionId = this.user.positionId.split(",");
			this.queryCyApp();
			this.queryAllApp();
		},
		created() {
			let that = this;
			this.bus.$on('refresh', function() {
				console.log('收到bus了');
				that.queryCyApp();
			});
		},
		methods: {
			appClick(item) {
				if (item.category == 1) {
					if (item.appPath != null && item.appPath != '') {
						this.$router.push(item.appPath);
					}
				} else if (item.category == 2) {
					if (item.authType == 1) {
						let user = JSON.parse(localStorage.getItem('user'));
						let url = item.appUrl + '?token=' + user.token;
						//todo 跳转应用页面
					} else if (item.authType == 2) {
			
					} else {
						//todo 跳转应用页面
			
					}
				} else {
					//todo 跳转app应用页面
					if (item.isUnifiedAuthentication == 1) {
						//带token跳转
					} else {
			
					}
				}
			},
			getImgUrl(item) {
				let img = this.$check.check(item.name);
				if (img != null) {
					console.log();
					return img;
				} else {
					return item.url;
				}
			},
			queryCyApp() {
				console.log('网络访问了');
				this.$postRequest(`${this.$config.YDMH}application/obtainCommonUseApplication`, {
					userCode: this.user.employeeCode,
					orgCode: this.user.orgCode,
					positionIdList: this.positionId,
				}).then(res => {
					console.log( res.list);
					let name = '常用应用';
					this.cyMenus =[];
					this.cyMenus.push({
						name: name,
						data: res.list,
					});
					this.cyMenuData(res.list, name);
				}).catch(() => {

				});
			},
			async cyMenuData(applicationList, name) {
				if (applicationList.length > 0) {
					let that = this;
					applicationList.forEach(function(menu, index) {
						that.$set(menu, 'url',
							`${that.$config.YDMH}transformDownload/download?type=2&fileId=${menu.iconAttachmentId}`
						);
					});
				}
			},

			queryAllApp() {
				this.$postRequest(`${this.$config.YDMH}application/obtainApplicationListByUser`, {
					userCode: this.user.employeeCode,
					orgCode: this.user.orgCode,
					positionIdList: this.positionId,
				}).then(res => {
					this.allMenus = res.list;
					this.allMenuData();
				}).catch(() => {

				});
			},
			async allMenuData() {
				let that = this;
				this.allMenus.forEach((menu) => {
					let applicationList = menu.applicationList;
					applicationList.forEach((application) => {
						that.$set(application, 'url',
							`${that.$config.YDMH}transformDownload/download?type=2&fileId=${application.iconAttachmentId}`
						);
					});
				});
			},
		}
	}
</script>
<style lang="scss" scoped>
	.tab-margin-top {
		margin-top: 55px;
	}

	.tab1-z-index {
		position: absolute;
		z-index: 999999;
	}

	.tab-page .tab-content {
		background-color: white;
		// background: url("../assets/images/globle/globle-bg.jpg");
	}

	/*设置自动换行*/
	.div-wrap {
		display: flex;
		flex-wrap: wrap;
		margin: 10px 0px;
		width: 100%;
	}

	.colum-item {
		/*设置每一个小组建的宽度占比*/
		width: 33%;
		margin: 10px 0px 10px 0px;
	}

	.icon-yy {
		width: 60px;
		height: 60px;
		position: relative;
		left: 55%;
		transform: translateX(-50%);
		position: relative;
		transform: translateX(-50%);
		margin-left: -10px;
	}

	.icon-name {
		line-height: 40px;
		height: 40px;
		text-align: center;
		margin-left: -10px;
	}
</style>
