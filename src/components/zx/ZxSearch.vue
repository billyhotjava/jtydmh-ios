<template>
	<div class="popup">
		<div class="tab-page has-header">
			<div class="tab-header">
				<mt-header :title="title" class="yyss-header">
					<a href="javascript:;" slot="left" @click="$router.back(-1)">
						<mt-button icon="back" class="mt-button-back" />
					</a>
				</mt-header>
				<div style="width: 100%; height: 56px;">
					<div class="zxs-search-div background-white">
						<form action="/" @submit.prevent>
							<img src="../../assets/images/globle/search.png" width="15" height="15" class="zxs-search-img" />
							<input autofocus="true" ref="searchinput" v-model="search" placeholder="搜索内容"	 class="zxs-search-ipnut text-size-13" @input="changeInput()" id="inputs" @keyup.13="enterPress" />
						</form>
					</div>
					<button v-if="search == ''" class="zxs-search-button background-white" @click="cancel()">取消</button>
					<button v-else class="zxs-search-button search-color background-white" @click="searchTable()">搜索
					</button>
					<!-- <form action="/" style="margin: 5px;">
						<van-search v-model="search" 
						show-action 
						autofocus
						placeholder="请输入搜索关键词" 
						@input="changeInput()"
						@search="searchTable()"
						@cancel="cancel()" />
					</form> -->
				</div>
			</div>

			<div class="tab-content pr">
				<div class="list bb zx-wrap-content" v-for="(item, index) in searchList" :key="index"
					@click="lookNotice(item)">
					<p class="zx-abstract desc">{{getTitle(item)}}</p>
					<p class="zx-date">{{getDate(item)}}</p>
				</div>
			</div>
			<div class="no_data_container" v-show="showNoData" v-if="search != '' && searchList.length == 0">
				<p style="text-align: center"><img src="../../assets/images/weather/noweatherdata.png" align="middle" />
				</p>
				<div class="no_data_text">
					暂无内容
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import eventBus from '../../utils/eventBus.js';
	export default {
		name: "ZxSearch",
		data() {
			return {
				search: '',
				searchList: [],
				showNoData: false,
				title: '',
				dataList: [],
				selectedId: 0,
			}
		},
		activated() {},
		mounted() {
			this.title = localStorage.getItem('zxSearchTitle');
			this.dataList = JSON.parse(localStorage.getItem('zxSearchDataList'));
			this.selectedId = this.$route.query.selectedId;

			let inputs = document.getElementById('inputs');
			setTimeout(inputs.focus(), 500);
		},
		methods: {
			enterPress(categoryId) {
				this.$refs.searchinput.blur();
				this.searchTable();
			},
			searchTable() {
				this.searchList = [];
				if (this.search != '') {
					this.dataList.forEach((item, index) => {
						if (this.title == '本部公告') {
							if (item.titile.search(this.search) != -1) {
								this.searchList.push(item);
							}
						} else {
							if (item.title.search(this.search) != -1) {
								this.searchList.push(item);
							}
						}
					});
					this.showNoData = true;
				} else {
					this.showNoData = false;
				}
			},
			changeInput() {
				if (this.search == '') {
					this.showNoData = false;
					this.searchList = [];
				}
			},
			cancel() {
				this.searchList = [];
				this.search = '';
				this.$emit('handleCancel');
				this.$router.back(-1);
			},
			lookNotice(item) {
				if (this.selectedId == 5) {
					this.$router.push({
						path: '/infomationDetail',
						query: {
							url: item.id,
							type: this.selectedId,
							file: item.fileList,
						}
					});
				} else if (this.selectedId == 6) {
					if (item.type == 'bb') {
						this.$router.push({
							path: '/infomationDetail',
							query: {
								url: item.href,
								type: 5,
								file: item.fileList,
							}
						});
					} else {
						this.$router.push({
							path: '/infomationDetail',
							query: {
								url: item.href,
								type: item.type == 'gs' ? 2 : 1,
							}
						});
					}
				} else {
					this.$router.push({
						path: '/infomationDetail',
						query: {
							url: item.url,
							type: this.selectedId,
						}
					});
				}

			},
			getTitle(item) {
				if (this.title == '本部公告') {
					return item.titile;
				} else {
					return item.title;
				}
			},
			getDate(item) {
				if (this.title == '本部公告') {
					return item.createTime;
				} else {
					return item.date;
				}
			}
		},
	}
</script>

<style lang="scss" scoped>
	.popup {
		width: 100% !important;
		height: 100%;
		border-radius: 1px;
		position: fixed;
		/*当页面不滚动时添加的滚动样式设置*/
		overflow-y: scroll;
		padding: 0 !important;
	}

	.mt-button-back {
		margin-top: 0px;
	}

	.zxs-search-div {
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

	.zxs-search-img {
		vertical-align: middle;
		margin-left: 5px
	}

	.zxs-search-ipnut {
		width: 80%;
		padding-top: 5px;
		padding-bottom: 5px;
		margin-left: 5px;
		border: 0px;
    background: white;
	}

	//.search-img-line{
	//    width: 2px;
	//    height: 20px;
	//    vertical-align: middle;
	//}
	.zxs-search-button {
		float: right;
		margin-top: 12px;
		margin-right: 20px;
		border: 0;
		width: 60px;
		vertical-align: middle;
    font-size: 13px;
		//position: absolute;
		//top:50%;
		//transform: translateY(-50%);
		//outline:none;
	}

	.zx-wrap-content {
		padding: 5px 20px;
		overflow: hidden;
		width: 100%;
		display: block;
		box-sizing: border-box;

		.zx-abstract {
			flex: 1;
			line-height: 1.2rem;
			font-size: 14px;
			color: #000;
			padding-bottom: 10px;
			//max-height: 2.5rem;
			overflow: hidden;
			text-overflow: ellipsis;
			display: -webkit-box;
			line-clamp: 2;
			-webkit-line-clamp: 2;
			-webkit-box-orient: vertical;
		}

		.zx-date {
			color: #666;
			font-size: 13px;
      padding-top: 5px;
			margin-left: 10px;
			float: right;
			margin-bottom: 5px;
			flex: 1;
			text-align: right;
		}
	}

	.no_data_container {
		height: 100%;
		display: -webkit-flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}
</style>
