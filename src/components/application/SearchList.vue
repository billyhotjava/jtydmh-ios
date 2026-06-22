<template>
	<mt-popup v-model="show" class="app-search-popup">
		<div class="tab-page has-header tab3">
			<div class="tab-header">
				<mt-header title="应用搜索" class="yyss-header">
					<a href="javascript:;" slot="left" @click="cancel()">
						<mt-button icon="back" class="mt-button-back" />
					</a>
				</mt-header>
				<div style="width: 100%; height: 56px;">
					<div class="app-search-div background-white">
						<form action="/" @submit.prevent>
							<img src="../../assets/images/globle/search.png" width="15" height="15"
								class="app-search-img" />

							<input v-model="search" type="search" placeholder="搜索内容" class="app-search-ipnut text-size-13" @keyup.13="enterPress" ref="searchInput" id="inputs" />
						</form>
					</div>
					<button v-if="search == ''" class="app-search-button background-white" @click="cancel()">取消</button>
					<button v-else class="app-search-button search-color background-white"
						@click="searchTable()">搜索</button>
					<!-- <form action="/" style="margin: 5px;">
						<van-search v-model="search" 
						show-action 
						autofocus
						placeholder="请输入搜索关键词" 
						@search="searchTable()"
						@cancel="cancel()" />
					</form> -->
				</div>
			</div>

			<div class="tab-content pr">
				<div class="app-list" v-for="(item, index) in appList" :key="index">
					<img class="app-img" :src="getImgUrl(item)" />
					<h3 class="app-h3">{{item.name}}</h3>
					<button class="app-right-button" @click="appInto(item)">进入应用</button>
				</div>
			</div>
		</div>
	</mt-popup>
</template>

<script>
	export default {
		name: "SearchList",
		props: {
			show: Boolean,
		},
		data() {
			return {
				search: '',
				appList: []
			}
		},
		mounted() {
			this.appList = [];
		},
		methods: {
			enterPress(categoryId) {
				this.$refs.searchInput.blur();
				this.searchTable();
			},
			async MenuData(applicationList) {
				if (applicationList.length > 0) {
					for (var i = 0; i < applicationList.length; i++) {
						await this.$getRequest(
								`${this.$config.FILE_IP}file/${applicationList[i].iconAttachmentId}/presignedurl`, {})
							.then(res => {
								this.appList.push({
									name: applicationList[i].name,
									url: res.presignedAgentUrl,
									appPath: applicationList[i].appPath,
								});
							}).catch((err) => {

							});
					}
				}
			},
			searchTable() {
				this.appList = [];
				if (this.search != '') {
					this.$getRequest(`${this.$config.YDMH}application/appFind`, {
						name: this.search,
					}).then(res => {
						if (res.list.length > 0) {
							let applicationList = res.list;
							console.log(app);
							for (var i = 0; i < applicationList.length; i++) {
								this.appList.push({
									name: applicationList[i].name,
									url: `${this.$config.YDMH}transformDownload/download?type=2&fileId=${applicationList[i].iconAttachmentId}`,
									appPath: applicationList[i].appPath,
								});
							}
						}
					}).catch(() => {

					});
				}
			},
			appInto(item) {
				this.appList = [];
				this.search = '';
				this.$emit('handleCancel');
				this.$router.push(item.appPath);
			},
			cancel() {
				this.appList = [];
				this.search = '';
				this.$emit('handleCancel');
			},
			getImgUrl(url) {
				let img = this.$check.check(url.name);
				if (img != null) {
					return img;
				} else {
					return url;
				}
			}
		},
		watch: {
			show() {
				if (this.show) {
					console.log('打开了');
					this.$nextTick(() => {
					
					this.$refs.searchInput.focus()
					
					},100)
				}
			}
		},
	}
</script>

<style lang="scss" scoped>
	.app-search-popup {
		width: 100%;
		height: 100%;
		position: fixed;
		/*当页面不滚动时添加的滚动样式设置*/
		overflow-y: scroll;
	}

	.mt-button-back {
		margin-top: 0px;
	}

	.app-search-div {
		width: calc(100% - 125px);
		float: left;
		border: 1px solid #D2D2D2;
		border-radius: 3px;
		margin-top: 10px;
		margin-left: 15px;
		margin-bottom: 10px;
		padding: 5px;
		outline: none;
	}

	.app-search-img {
		vertical-align: middle;
		margin-left: 5px
	}

	.app-search-ipnut {
		width: 80%;
		padding-top: 5px;
		padding-bottom: 5px;
		margin-left: 5px;
		border: 0px;
	}

	//.search-img-line{
	//    width: 2px;
	//    height: 20px;
	//    vertical-align: middle;
	//}
	.app-search-button {
		float: right;
		margin-top: 9px;
		margin-right: 25px;
		border: 0;
		width: 60px;
		height: 45px;
		vertical-align: middle;
		//position: absolute;
		//top:50%;
		//transform: translateY(-50%);
		//outline:none;
	}

	.app-list {
		display: flex;
		padding: 10px;
		align-items: center;
		border-bottom: 1px solid #f3f1f1;
	}

	.app-img {
		width: 40px;
		height: 40px;
		margin-left: 20px
	}

	.app-h3 {
		flex-grow: 1;
		margin-left: 20px;
		font-size: 16px;
		font-weight: normal;
	}

	.app-right-button {
		border: 0px;
		background: #fff;
		font-size: 14px;
		margin-right: 20px
	}
</style>
