<template>
	<div class="tab-page has-header tab1">
		<div class="tab-header tab1-z-index">
			<mt-header title="掌上国神大字版" class="bb" fixed>
				<!-- 	<mt-button slot="right" class="text-size-12"	style="height: 25px; border: 1px solid white;padding-left: 3px; padding-right: 3px; vertical-align: middle; line-height: 25px;">
									安全连接</mt-button> -->
				<van-popover slot="right" v-model="showPopover" trigger="click" :actions="getActions()" @select="onSelect"
					placement="bottom-end" overlay>
					<template #reference>
						<mt-button class="text-size-12"
							style="height: 25px;padding-left: 3px; padding-right: 3px; vertical-align: middle; line-height: 25px;">
							便捷功能</mt-button>
					</template>
				</van-popover>

			<!-- 	<mt-button slot="left" data-intro="1、扫一扫：用于二维码等常用信息的展示"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击扫一扫的按钮', actionType:'scan-click'}"
					@click="scan()">
					<img src="../assets/images/home/scanner.png"
						style="vertical-align: middle;height: 20px; width: 20px;vertical-align: middle;" />
				</mt-button> -->
			</mt-header>
		</div>
		<div class="tab-margin-top tab-content">
			<van-tabs type="card" color="#3b87f6" sticky offset-top="65" v-model="currentTab">
				<van-tab title="找应用">
					<seeApp ref="seeAppRef" />
				</van-tab>
				<van-tab title="看新闻">
					<seeNews ref="newref" />
				</van-tab>
			</van-tabs>
		</div>

	</div>
</template>

<script>
	import seeApp from "../components/application/seeApp.vue";
	import seeNews from "../components/application/seeNews.vue";
	export default {
		name: "TabOld",
		components: {
			seeApp,
			seeNews
		},
		data() {
			return {
				user: JSON.parse(localStorage.getItem('user')),
				positionId: [],
				showPopover: false,
				actions: [{
					text: '常用编辑'
				}],
				actionsright: [ {
					text: '公告关键词'
				}, {
					text: '公告排序'
				}],
				isZxShow: false,
				isGjcShow: false,
				gjcModel: '',
				currentTab: 0
			}
		},
		created() {

		},
		mounted() {
			this.positionId = this.user.positionId.split(",");
			this.queryCyApp();
			this.queryAllApp();
		},
		methods: {
			getActions(){
				if (this.currentTab ==0) {
					return this.actions;
				}else{
					return this.actionsright;
				}
			},
			onSelect(action) {
				console.log(action);
				if (action.text == '常用编辑') {
					setTimeout(() =>{
						this.editApp();
					},200);
				} else if (action.text == '公告关键词') {
					this.$refs.newref.openGjc();
				} else {
					this.$refs.newref.titlePx();
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
			editApp() {
				this.$router.push({
					name: 'appedit'
				});
			},
			queryCyApp() {
				this.$postRequest(`${this.$config.YDMH}application/obtainCommonUseApplication`, {
					userCode: this.user.employeeCode,
					orgCode: this.user.orgCode,
					positionIdList: this.positionId,
				}).then(res => {
					let name = '常用应用';
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
		margin-top: 65px;
	}

	.tab1-z-index {
		position: absolute;
		z-index: 999999;
		height: 55px;
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
		width: 45px;
		height: 45px;
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

	/*头部*/
	.mint-header {
		height: 55px !important;
		background-color: #206EEA !important;
		color: white !important;
		line-height: 54px !important;
	}
</style>
