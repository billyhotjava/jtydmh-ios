<template>
	<div class="tab-page has-header tab3">
		<div class="tab-header">
			<mt-header title="我的消息" class="bb"></mt-header>

			<div style="width: 100%; height: 56px;">
				<!-- <div class="tab3-search-div background-white">
                    <img src="../assets/images/globle/search.png" width="15" height="15"  class="tab3-search-img"/>
                    <input v-model="search" placeholder="搜索内容" class="tab3-search-ipnut text-size-13" @input="changeInput()"/>
                </div> -->
				<form action="/" class="tab3-search-div background-white">
					<van-search v-model="search" autofocus placeholder="请输入搜索关键词" @search="changeInput()" />
				</form>
				<van-dropdown-menu active-color="#206EEA" style="padding-top: 6px">
					<van-dropdown-item v-model="type" :options="optionsList" @change="selectChange()" />
				</van-dropdown-menu>
				<!--                <select v-model="type" placeholder="请选择" class="search-select vertical-center" @click="selectChange()" id="selectType">-->
				<!--                    <option-->
				<!--                            v-for="item in optionsList"-->
				<!--                            :key="item.id"-->
				<!--                            :label="item.label"-->
				<!--                            :value="item.id">-->
				<!--                    </option>-->
				<!--                </select>-->
				<!--<button class="search-button vertical-center" @click="searchList()">搜索</button>-->
			</div>
		</div>

		<div class="tab-content pr">
			<div style="height: 100%" v-if="messageList != undefined && messageList.length != 0">
				<van-pull-refresh v-model="isLoading" success-text="刷新成功" @refresh="onRefresh">
					<van-list class="dealt_list" v-model="isLoading" :finished="finished" finished-text="没有更多了"
						@load="onLoad" :immediate-check="false" :offset="20">
						<van-cell v-for="(item, index) in messageList" :key="index" @click="popShow(item)" is-link
							v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击查看${item.sendTitle}具体内容的按钮`, actionType:'daily-production-report-info-click'}">
							<template>
								<div class="flex" style="justify-content: space-between">
									<div>
										<img v-if="item.type == 1" src="../assets/images/message/message-unread@2x.png"
											width="35" height="35" class="vertical-center" />
										<img v-else-if="item.type == 2"
											src="../assets/images/message/message-read@2x.png" width="35" height="35"
											class="vertical-center" />
									</div>
									<div class="flex1 pl1rem overflowhidden"
										style="display: flex; flex-direction: column">
										<!--<p style="float: right">{{item.createTime}}</p>-->
										<div style="display: flex">
											<h3>{{item.title}} </h3>
											<p class="right-time-p">{{item.createTime}}</p>
										</div>
										<p style="color: #BBBBBB">{{item.content}}</p>
									</div>
								</div>
							</template>
						</van-cell>
					</van-list>
				</van-pull-refresh>
			</div>
			<div class="no_data_container" v-else>
				<p style="text-align: center"> <img src="@/assets/images/weather/noweatherdata.png" align="middle" />
				</p>
				<div class="no_data_text">
					暂无内容
				</div>
			</div>
		</div>

		<mt-popup v-model="popupVisible" popup-transition="popup-fade" class="popup">
			<div>我的消息</div>
			<h3>{{message.title}}</h3>
			<p>{{message.name}}</p>

			<button @click="messageDetial(message)">前往查看</button>
		</mt-popup>
	</div>
</template>

<script>
	import axios from 'axios';
	export default {
		name: "Tab3",
		props: {
			selected: String,
		},
		data() {
			return {
				search: '',
				start: '0',
				type: 0,
				popupVisible: false,
				message: {},
				messageList: [],
				optionsList: [{
					value: 0,
					text: '全部'
				}, {
					value: 1,
					text: '未读'
				}, {
					value: 2,
					text: '已读'
				}],
				isLoading: false,
				finished: false,
				pageNo: 1,
				pageSize: 10,
			}
		},
		mounted() {
			let that = this;
			this.bus.$on('changeReadStatus', function() {
				console.log('tab3 changeReadStatus mounted');
				that.onRefresh();
			});
		},
		activated() {
			if (this.selected == 'tab-container3') {
				this.onRefresh();
			}
		},
		methods: {
			onRefresh() {
				this.pageNo = 1;
				console.log('下拉刷新');
				this.finished = false;
				this.messageList = [];
				this.loadList();
			},
			onLoad() {
				console.log('上拉加载');
				this.pageNo++;
				this.loadList();
			},
			loadList() {
				this.$getRequest(`${this.$config.YDMH}jgMessage/find`, {
					pageNo: this.pageNo,
					pageSize: this.pageSize,
					content: this.search,
					type: this.type == 0 ? "" : this.type,
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
					this.messageList = this.messageList.concat(res.list);
					this.isLoading = false;
					if (this.pageNo * this.pageSize >= res.recordsTotal) {
						this.finished = true;
					}
					for (var i = 0; i < this.messageList.length; i++) {
						this.messageList[i].createTime = this.$base.formatDate(this.messageList[i].createTime);
						// for(var j = 0; j < this.optionsList.length; j++){
						//     if(this.messageList[i].type == this.optionsList[j].id){
						//         this.messageList[i].readType = this.optionsList[j].label
						//     }
						// }
					}
				}).catch((err) => {
					this.isLoading = false;
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			popShow(row) {
				this.popupVisible = true;
				this.message = row;
				this.$postFormRequest(`${this.$config.YDMH}jgMessage/changeRead`, {
					channelId: row.channelId,
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
					this.bus.$emit('changeReadStatus');
					// this.onRefresh();
				}).catch(() => {

				});
			},
			messageDetial(message) {
				let that = this;
				this.popupVisible = false;
				let info = JSON.parse(message.appInfo);
				let appParam = JSON.parse(message.appParam);
				if (info.name === '生产日报' && info.name == '手机报') {
					that.$toast({
						message: '暂不支持该类型消息直达,消息内容请前往我的消息查看',
						className: 'inexa'
					});
					return;
				}
				that.$postFormRequest(`${this.$config.YDMH}jgMessage/changeRead`, {
					channelId: item.channelId,
					userCode: JSON.parse(localStorage.getItem('user')).employeeCode,
				}).then(res => {
					if (info.name == '手机报') {
						that.$router.push({
							name: appParam.url,
							params: {
								id: appParam.id,
								isLoadLocalData: false,
							}
						});
					} else if (info.name === '生产日报') {
						that.$router.push({
							name: appParam.url,
							params: {
								sendDay: appParam.data
							}
						});
					}
				}).catch(() => {

				});
			},
			changeInput() {
				this.onRefresh();
			},
			selectChange() {
				// this.type = document.getElementById('selectType').value;
				console.log("!!! type", this.type);
				this.onRefresh();
			},

		},
		watch: {
			selected() {
				if (this.selected == 'tab-container3' && this.start == '0') {
					this.onRefresh();
					this.start = '1';
				} else {}
			},
		}
	}
</script>

<style scoped lang="scss">
	.search-wrap {}

	::v-deep .van-cell__left-icon,
	.van-cell__right-icon {
		display: none;
	}

	::v-deep .van-list .van-cell {
		padding: 0px 0px !important;
	}

	.tab3-search-div {
		width: calc(100% - 105px);
		float: left;
		// border: 1px solid #D2D2D2;
		// border-radius: 3px;
		// margin-top: 10px;
		// margin-left: 15px;
		// margin-bottom: 10px;
		// padding: 5px;
		// outline:none;
	}

	.tab3-search-img {
		vertical-align: middle;
		margin-left: 5px
	}

	.tab3-search-ipnut {
		width: 80%;
		padding-top: 5px;
		padding-bottom: 5px;
		margin-left: 5px;
		outline: none;
	}

	.tab3-search-select {
		width: 70px;
		height: 38px;
		float: left;
		margin-top: 1px;
		padding: 5px;
		margin-left: 10px;
		border: 1px solid #D2D2D2;
		border-radius: 3px;
		outline: none;
		background: white;
		font-size: 13px;
	}

	.tab3-search-button {
		width: 50px;
		float: right;
		padding: 10px;
		margin-right: 10px;
		border: 0;
		border-radius: 3px;
		outline: none;
		background: #4FC2F1;
		color: white;
		font-size: 14px;
	}

	.no_data_container {
		height: 100%;
		display: -webkit-flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	.no_data_text {
		color: #9c9c9c;
		text-align: center;
	}

	.popup {
		width: 70%;
		padding: 15px;
		border-radius: 10px;

		div {
			text-align: center;
			margin-top: 10px;
		}

		h3 {
			margin-top: 20px;
			font-size: 14px;
			font-weight: normal
		}

		p {
			margin-top: 15px;
			font-size: 12px;
			color: #7C7C7C;
		}

		button {
			width: 50%;
			padding: 10px;
			font-size: 14px;
			color: white;
			background: #02A7F0;
			border: 0;
			border-radius: 5px;
			margin-top: 20px;
			position: relative;
			transform: translateX(-50%);
			left: 50%;
			outline: none;
		}
	}



	.dealt_list {
		padding: 0px 15px;
		flex-shrink: 0;

		a {
			overflow: hidden;
			width: 100%;
		}

		.img {
			width: 2rem;
			height: 2rem;
			border-radius: 5px;
			text-align: center;
			line-height: 3rem;
			color: #fff;
		}

		h3 {
			//width: 200px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap !important;
			//padding-right: 10px;
			font-size: 15px;
			color: #222;
			font-weight: normal;
			line-height: 1.5rem;
		}

		p {
			line-height: 1.5rem;
			font-size: 12px;
			color: #7C7C7C;
			display: -webkit-box;
			-webkit-box-orient: vertical;
			-webkit-line-clamp: 1;
			overflow: hidden;
		}
	}

	.right-time-p {
		margin-left: auto;
		float: right;
		margin-right: 5px;
		text-align: right;
		width: 90px;
	}

	.van-dropdown-menu ::v-deep .van-dropdown-menu__bar {
		box-shadow: none;
		height: 38px;
	}
</style>
