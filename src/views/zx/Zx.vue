<!--资讯中心-->
<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header title="资讯中心">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
				<div slot="right" class="position-right" @click="titlePx()"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击资讯中心的排序的按钮', actionType:'zx-information-sort-click'}">
					<img src="../../assets/images/sort.png" height="25" width="25">
				</div>
			</mt-header>

			<div class="wrap-zx" >
				<div class="search-div-zx background-white" style="float: left">
					<img src="../../assets/images/globle/search.png" width="15" height="15" class="search-img-zx" />
					<input v-model="search" placeholder="搜索本页" maxlength="0" class="search-ipnut-zx text-size-13" @click="showSearch"/>
				</div>
				<button class="bt-zx zx-dialog-save text-color-white" @click="gjc()"
					v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击资讯的关注关键词的按钮', actionType:'zx-like-key-click'}">关注关键词</button>
			</div>

			<div style="float: top">
				<!-- <keep-alive>
					<ly-tab :items="tabList" :options="options" @change="handleChange"></ly-tab>
				</keep-alive> -->
				<ly-tab :items="tabList" :options="options" @change="handleChange"></ly-tab>
			</div>
		</div>

		<div class="background-white tab-content" v-if="dataList != null && dataList.length != 0">

			<van-pull-refresh v-model="isLoading" @refresh="onRefresh">
				<van-list v-model="loading" :finished="finished" @load="onLoad" :offset="10" :immediate-check="false"
					finished-text="没有更多了">
					<div id="list-content" class="bgwhite zx-notice_list bb" v-for="(item,index) in dataList"
						:key="index">
						<div v-if="index == 0 && item.img != null && item.img != ''">
							<div class="zx-wrap-content" @click="lookNotice(item)">
								<div class="zx-img-flex">
									<div class="zx-abstract desc">{{item.title}}</div>
									<img :src="item.img" height="21" width="39" />
								</div>
							</div>
						</div>
						<div v-else>
							<div v-if="selectedId == '5'" class="zx-wrap-content" @click="lookNotice(item)">
								<div>
									<p class="zx-abstract desc">{{item.titile}}</p>
									<p class="zx-date">{{item.createTime}}</p>
								</div>
							</div>
							<div v-else class="zx-wrap-content" @click="lookNotice(item)">
								<div>
									<p class="zx-abstract desc">{{item.title}}</p>
									<div>
										<div v-if="selectedId == '6'" class="zx-from">{{getNoticeType(item.type)}}</div>
										<div class="zx-date">{{item.date}}</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</van-list>
			</van-pull-refresh>
		</div>
		<div class="no_data_container" v-else>
			<p style="text-align: center"> <img src="../../assets/images/weather/noweatherdata.png" align="middle" />
			</p>
			<div class="no_data_text">
				暂无内容
			</div>
		</div>
		<mt-popup v-model="isGjcShow" class="popup">
			<div class="pop-title">关注公告设置</div>
			<div class="pop-notice">提示：
				请输入您关注的关键词，多个关键词以逗号分割，例如“安全，生产，检查”。系统将为您选出标题中含有该关键词的公告。</div>
			<input v-model="gjcModel" />
			<button @click="confirm()">确定</button>
		</mt-popup>

		<ZxDialog :zxList="tabList" :show="isZxShow" @handleCancel="handleCancel" />

	</div>
</template>

<script>
	import ZxDialog from "../../components/zx/ZxDialog";
	import eventBus from '../../utils/eventBus.js';

	export default {
		name: "Zx",
		components: {
			ZxDialog
		},
		data() {
			return {
				search: '',
				pageNum: 0,
				selectedId: 6,
				tabList: [{
						label: '关注公告',
						tabType: 6
					},
					{
						label: '集团公告',
						tabType: 1
					},
					{
						label: '公司公告',
						tabType: 2
					},
					{
						label: '本部公告',
						tabType: 5
					},
					{
						label: '早调会纪要',
						tabType: 3
					},
					{
						label: '例会纪要',
						tabType: 4
					},
				],
				options: {
					activeColor: '#579FF8'
				},
				isZxShow: false,
				isGjcShow: false,
				gjcModel: '',
				refreshing: false,
				dataList: [],
				error: false,
				isLoading: false,
				loading: false,
				finished: false,
				selectedTabLabel: '',
			}
		},
		// beforeRouteLeave(to, form, next) {
		// 	next();
		// },
		mounted() {
			this.selectedTabLabel = this.tabList[0]['label'];
			this.queryZxNavBar();
			this.getList();
      this.reloadZx();
			// eventBus.$on('selectedId', function(data){
			//     //赋值给首页的附近医院数据模型
			//     console.log('data============',data);
			//     if(data == null || data == ''){
			//
			// }else {
			//         this.selectedId = data;
			//         console.log('selectedId============',this.selectedId);
			// }
			// }.bind(this));
		},
		// Fixed: 增加资讯 Tabs keep-alive 
		activated() {
      console.log('zx zx zx activated');
      // 若查看详情返回来后需要刷新，则打开
      // this.getList();
		},
		methods: {
			getNoticeType(type){
				if (type == 'gs') {
					return '国神公告';
				}else if (type == 'bb') {
					return '本部公告';
				}else if (type == 'jt') {
					return '集团公告';
				}else{
					return '国神公告';
				}
			},
      reloadZx() {
        let that = this;
        console.log('should reload');
        this.bus.$on('shouldReload', function() {
          console.log('1234', that.selectedId);
          that.tabList.forEach((item, index) => {
            if (item.tableType === that.selectedId) {
              that.selectedTabLabel = item.label;
            }
          });
          // that.queryZxNavBar();
          that.getList();
        });
      },
			queryZxNavBar() {
				/*
				 * TODO 服务器调用导航栏接口返回到页面，
				 * TODO 先调用服务器接口，根据接口返回判断是否有数据
				 * TODO 如果没有数据则调用本地写的NavBar数据列表，
				 * TODO 如果有数据则直接使用接口数据
				 */
				console.log('queryZxNavBar');
				if (localStorage.getItem('zxList') == '' || localStorage.getItem('zxList') == null) {
					this.tabList = this.tabList;
					this.selectedId = this.tabList[0].tabType;

				} else {
					this.tabList = JSON.parse(localStorage.getItem('zxList'));
					this.selectedId = this.tabList[0].tabType;
				}
				// console.log('tabList', JSON.stringify(this.tabList));
				// console.log('this.selectedId', this.selectedId);
			},
			showSearch() {
                localStorage.setItem('zxSearchTitle',this.selectedTabLabel);
                localStorage.setItem('zxSearchDataList',JSON.stringify(this.dataList));
                this.$router.push({
                    name: 'zxsearch',
					query:{
                        title : this.selectedTabLabel,
                        dataList : this.dataList,
                        selectedId: this.selectedId
					}
                });
			},
			changeInput() {
				console.log("changeInput", this.search);
			},
			handleChange(item, index) {
				this.selectedTabLabel = this.tabList[index]['label'];
				this.selectedId = this.tabList[index].tabType;
				this.onRefresh();
			},
			getList() {
				console.log('getList', this.selectedId);
				this.dataList = [];
				this.pageNum = 0;
				if (this.selectedId == 5) {
					this.pageNum += 1;
					this.$getRequest(
						`${this.$config.YDMH}external/listAnnouncementByEmployeeCode`, {
							employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode,
							pageNo: this.pageNum,
							pageSize: 10
						}).then(res => {
						if (res.list == null && res.list.length == 0) {
							this.finished = true;
							this.isLoading = false;
						} else {
							this.isLoading = false;
							this.dataList = this.dataList.concat(res.list);
							// console.log(JSON.stringify(this.dataList));
							if (this.dataList.length >= res.recordsTotal) {
								this.finished = true;
							}
						}
					}).catch(() => {
						this.error = true;
						this.isLoading = false
					});
				} else if (this.selectedId == 6) {
					this.pageNum += 1;
					this.$getRequest(
						`${this.$config.YDMH}external/announcementSearch`, {
							employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode
						}).then(res => {

						if (res.list == null && res.list.length == 0) {
							this.finished = true;
							this.isLoading = false;
						} else {
							this.isLoading = false;
							this.dataList = this.dataList.concat(res.list);
							if (this.dataList.length >= res.recordsTotal) {
								this.finished = true;
							}
						}
					}).catch(() => {
						this.error = true;
						this.isLoading = false
					});
				} else {
					this.pageNum += 1;
					this.$postRequestQuery(
						`${this.$config.YDMH}news/getCEList`, {
							type: this.selectedId,
							pageNum: this.pageNum
						}).then(res => {
						if (res.list == null && res.list.length == 0) {
							this.finished = true;
							this.isLoading = false
						} else {
							this.isLoading = false;
							this.dataList = this.dataList.concat(res.list);
							if (this.dataList.length >= res.recordsTotal) {
								this.finished = true;
							}
						}
					}).catch(() => {
						this.error = true;
						this.isLoading = false
					});
				}
			},

			//下拉刷新
			onRefresh() {
				this.pageNum = 1;
				this.finished = false;
				this.getList()
			},
			//上拉加载
			onLoad() {
				// 异步更新数据
				if (this.selectedId == 6) {
					// 加载状态结束
					this.loading = false;
					this.finished = true;
				} else if (this.selectedId == 5) {
					this.pageNum += 1;
					this.$getRequest(
						`${this.$config.YDMH}external/listAnnouncementByEmployeeCode`, {
							employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode,
							pageNo: this.pageNum,
							pageSize: 10
						}).then(res => {
						// 加载状态结束
						this.loading = false;
						if (res.list == null && res.list.length == 0) {
							this.finished = true;
						} else {
							this.dataList = this.dataList.concat(res.list);
							if (this.dataList.length >= res.recordsTotal) {
								this.finished = true;
								this.$toast({
									message: '暂无更多数据',
									className: 'inexa'
								})
							}
						}
					}).catch(() => {
						this.error = true;
						// 加载状态结束
						this.loading = false;
					});
				} else {
					this.pageNum += 1;
					this.$postRequestQuery(
						`${this.$config.YDMH}news/getCEList`, {
							type: this.selectedId,
							pageNum: this.pageNum
						}).then(res => {
						// 加载状态结束
						this.loading = false;
						if (res.list == null && res.list.length == 0) {
							this.finished = true;
						} else {
							this.dataList = this.dataList.concat(res.list);
							if (this.dataList.length >= res.recordsTotal) {
								this.finished = true;
								this.$toast({
									message: '暂无更多数据',
									className: 'inexa'
								})
							}
						}
					}).catch(() => {
						this.error = true;
						// 加载状态结束
						this.loading = false;
					});
				}
			},
			titlePx() {
				this.isZxShow = true;
			},
			gjc() {
				this.isGjcShow = true;
				this.getAnntSearchKey();
			},
			getAnntSearchKey() {
				this.$getRequest(`${this.$config.YDMH}/external/getAnntSearchKey`, {
					employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
					this.gjcModel = res.object;
				}).catch(() => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log('保存公告关键词接口失败', error);
				});
			},
			handleCancel() {
				this.isZxShow = false;
				this.queryZxNavBar();
			},
			confirm() {
				if (this.gjcModel == '') {
					this.$toast({
						message: '请输入您关注的关键词，多个关键词以逗号分割',
						className: 'inexa'
					});
					return;
				}
				let user = JSON.parse(localStorage.getItem('user'));
				this.$postFormRequest(`${this.$config.YDMH}external/updateAnntSearchKey`, {
					employeeCode: user.employeeCode,
					searchKey: this.gjcModel
				}).then(res => {
					if (res.success == true) {
						this.isGjcShow = false;
						this.$toast({
							message: '关注公告的设置已更新',
							className: 'inexa'
						});
					}
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log('保存公告关键词接口失败', error);
				});
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
		},
	}
</script>

<style scoped lang="scss">
	.wrap-zx {
		display: flex;
		align-items: center;
	}

	.search-div-zx {
		border: 1px solid #D2D2D2;
		border-radius: 3px;
		margin-top: 10px;
		margin-bottom: 10px;
		padding: 5px;
		outline: none;
		margin-left: 10px;
		flex: auto;
	}

	.search-img-zx {
		vertical-align: middle;
		margin-left: 10px
	}

	.search-ipnut-zx {
		width: 75%;
		padding-top: 5px;
		padding-bottom: 5px;
		margin-left: 5px;
		margin-right: 10px;
		outline: none;
	}

	.bt-zx {
		height: 30px;
		padding: 0px 10px;
		margin-top: 10px;
		margin-bottom: 10px;
		margin-right: 10px;
		margin-left: 10px;
		border: 0;
		font-size: 12px;
		border-radius: 20px;
	}

	.img {
		width: 28px;
		height: 28px;
		float: right;
		margin-top: 10px;
		margin-right: 10px;
	}

	.popup {
		width: 70%;
		padding: 30px;
		border-radius: 1px;
		position: fixed;
		border-radius: 5px;

		.pop-title {
			text-align: center;
			font-size: 16px;
			margin-bottom: 20px;
		}

		.pop-notice {
			color: orangered;
			font-size: 13px;
			margin-bottom: 15px;
		}


		input {
			width: 92%;
			padding: 10px;
			font-size: 14px;
			border: 1px solid #999999;
			border-radius: 5px;
			outline: none;
		}

		button {
			width: 100%;
			padding: 10px;
			background: #579FF8;
			color: white;
			font-size: 16px;
			border: 0;
			border-radius: 5px;
			margin-top: 20px;
			outline: none;
		}
	}

	.position-right {
		display: flex;
		align-items: center;
		justify-content: flex-end;
	}
	
	.zx-from{
		color: #206EEA;
		font-size: 13px;
		float: left;
		margin-bottom: 5px;
		flex: 1;
		text-align: right;
	}

	.zx-date {
		color: #666;
		font-size: 13px;
		margin-left: 10px;
		float: right;
		margin-bottom: 5px;
		flex: 1;
		text-align: right;
	}

	.zx-notice_list {

		.zx-wrap-content {
			padding: 5px 20px;
			overflow: hidden;
			width: 100%;
			display: block;
			box-sizing: border-box;

			.zx-img-flex {
				display: flex;
				align-items: center;
			}

			.zx-abstract {
				flex: 1;
				line-height: 1.2rem;
				font-size: 14px;
				color: #000;
				margin-bottom: 8px;
				overflow: hidden;
				text-overflow: ellipsis;
				display: -webkit-box;
				line-clamp: 2;
				-webkit-line-clamp: 2;
				-webkit-box-orient: vertical;
			}
		}

		.list_title_date p {}

	}

	.no_data_container {
		height: 100%;
		display: -webkit-flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}
</style>
