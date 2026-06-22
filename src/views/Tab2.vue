<template>
	<div class="tab-page has-header tab2">
		<div class="tab-header">
			<mt-header title="应用" class="bb"></mt-header>
		</div>

		<div class="tab-content pr">
			<div class="search-div background-white">
				<img src="../assets/images/globle/search.png" width="15" height="15" class="search-img" />
				<input placeholder="搜索内容" class="search-ipnut" readonly="readonly" @click="showSearch()" />
			</div>
			<cascad-menu ref="menu" :menus="menus" style="top: 60px"></cascad-menu>

			<SearchList :show="isSearchShow" @handleCancel="handleCancel" />

		</div>
	</div>
</template>

<script>
	import CascadMenu from "../components/application/cascad-menu";
	import SearchList from "../components/application/SearchList";
	export default {
		name: "Tab2",
		components: {
			SearchList,
			CascadMenu
		},
		props: {
			selected: String,
		},
		data() {
			return {
				start: '0',
				isSearchShow: false,
				menus: [],
				translatedText: '',
				list: [],
				pullup: true,
				positionId: [],
				user: JSON.parse(localStorage.getItem('user')),
			}
		},
		mounted() {
			// this.queryMenu();
			this.commonApp();
			this.positionId = this.user.positionId.split(",");
			let that = this;
			this.bus.$on('refresh', function() {
				that.commonApp();
			});
		},

		methods: {
			commonApp() {
				this.$postRequestNoDialog(`${this.$config.YDMH}application/obtainCommonUseApplication`, {
					userCode: this.user.employeeCode,
					orgCode: this.user.orgCode,
					positionIdList: this.positionId,
				}).then(res => {
					let cy = {};
					cy.applicationList = res.list;
					cy.classifyIconAttachmentId = '';
					cy.classifyId = '';
					cy.classifyName = '常用';
					cy.sortIndex = 0;
					this.queryMenu(cy);
				}).catch(() => {

				});
			},

			async queryMenu(cy) {
				await this.$postRequestNoDialog(`${this.$config.YDMH}application/obtainApplicationListByUser`, {
					userCode: this.user.employeeCode,
					orgCode: this.user.orgCode,
					positionIdList: this.positionId,
				}).then(res => {
					if (res.list.length > 0) {
						this.menus = res.list;
						this.menus.unshift(cy);
					}
				}).catch(() => {

				});
				let that = this;
				this.menus.forEach(function(menu, index) {
					let applicationList = menu.applicationList;
					applicationList.forEach(function(info) {
						that.$set(info, 'imageUrl',
							`${that.$config.YDMH}transformDownload/download?type=2&fileId=${info.iconAttachmentId}`
							);
						// that.$getRequest(
						// 	`${that.$config.FILE_IP}file/${info.iconAttachmentId}/presignedurl`, {}
						// ).then(res => {
						// 	that.$set(info, 'imageUrl', res.presignedAgentUrl);
						// }).catch((err) => {
						// 	console.log('获取 图标 失败', err);
						// });
					})
				});
			},

			/*
			 * TODO 应用搜索
			 */
			showSearch() {
				this.isSearchShow = true;
			},
			handleCancel() {
				this.isSearchShow = false;
			},
		},
		watch: {
			selected() {
				this.$refs.menu._calculateHeight();
				if (this.selected == 'tab-container2') {
					if (this.start == '0') {
						this.start = '1';
					}
					this.commonApp();
					// this.start = '1';
					// this.commonApp().then(() => {
					// 	this.start = '1';
					// }).catch(() => {
					// });
				}
			},
		}
	}
</script>

<style scoped lang="scss">
	.search-div {
		width: 90%;
		float: left;
		border: 1px solid #D2D2D2;
		border-radius: 3px;
		margin-top: 10px;
		margin-bottom: 10px;
		padding: 5px;
		outline: none;
		position: absolute;
		left: 50%;
		transform: translateX(-50%);
	}

	.search-img {
		vertical-align: middle;
		margin-left: 10px;
	}

	.search-ipnut {
		width: 80%;
		padding-top: 5px;
		padding-bottom: 5px;
		margin-left: 5px;
		margin-right: 10px;
		outline: none;
		font-size: 13px;
	}
</style>
