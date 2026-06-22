<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header v-if="isAdmin" title="手机报管理" class="sjb-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
				<mt-button slot="right" @click="newPhonePageEvent">
					新增
				</mt-button>
			</mt-header>
			<mt-header v-else title="手机报" class="sjb-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
      <div class="wrap-sjb" >
        <div class="search-div-sjb background-white" style="float: left">
          <img src="../../assets/images/globle/search.png" width="15" height="15" class="search-img-sjb" />
          <input placeholder="搜索标题" class="search-ipnut-sjb text-size-13" @input="changeInput($event.target.value)"/>
        </div>
        <button class="bt-sjb zx-dialog-save text-color-white" @click="chooseDateEvent">选择日期</button>
        <van-calendar color="#3b87f6" v-model="show" type="range" :min-date="minDate" :max-date="maxDate"
                      :show-confirm="false" @confirm="onConfirm" allow-same-day ref="sjb_calendar" />
      </div>



<!--			<div class="sjb-search">-->
<!--				<div class="sjb-search-div background-white">-->
<!--					<img src="@/assets/images/globle/search.png" width="15" height="15" class="sjb-search-img" />-->
<!--					<input placeholder="搜索标题" class="sjb-search-ipnut" @input="changeInput($event.target.value)" />-->
<!--					<van-button type="default" class="sjb-choose-date-button" @click="chooseDateEvent"><span-->
<!--							class="sjb-btn-font">选择日期</span></van-button>-->
<!--				</div>-->

<!--				<van-calendar color="#3b87f6" v-model="show" type="range" :min-date="minDate" :max-date="maxDate"-->
<!--					:show-confirm="false" @confirm="onConfirm" allow-same-day ref="sjb_calendar" />-->
<!--			</div>-->
			<div class="div-draft-container" v-if="this.todayRecord.draft == true" @click="gotoDraft">
				<div class="draft-normal">
					您还有未发布的手机报草稿，
				</div>
				<div class="text-message-color">
					点击查看>>
				</div>
			</div>
		</div>
		<div class="content-container tab-content" style="background: white">
			<van-pull-refresh v-model="isLoading" success-text="刷新成功" @refresh="onRefresh" style="min-height: 100vh;">
				<van-list class="van-list-container" v-model="isLoading" :finished="finished" finished-text="没有更多了"
					@load="onLoad" :immediate-check="false" :offset="20">
					<van-cell v-for="(item, index) in tableData" :key="index" @click="showDetail(item)">
						<template>
							<div class="table-in-div">
								<div class="flex">
									<div style="flex: 1;">{{item.title}}</div>
									<div class="table-cell-title-div">{{item.releaseDate}}</div>
								</div>

								<div v-if="isAdmin" class="muti-function-container">
									<van-button size="mini" class="multi-function-button-left button-red-color"
										@click.stop="editEvent(item)">编辑</van-button>
									<van-button size="mini" class="multi-function-button button-green-color"
										@click.stop="watchEvent(item)">查看</van-button>
								</div>
							</div>
						</template>
					</van-cell>
				</van-list>
			</van-pull-refresh>
		</div>
	</div>
</template>

<script>
	import {
		Toast
	} from 'vant';
	export default {
		name: "PhonePageManager",
		comments: {},
		props: {

		},
		data() {
			return {
				isAdmin: true,
				minDate: new Date(2010, 0, 1),
				maxDate: new Date(),
				startDate: '',
				endDate: '',
				show: false,
				searchContent: "",
				tableData: [],
				isLoading: false,
				finished: false,
				pageNo: 0,
				pageSize: 10,
				todayRecord: {},
			}
		},
		created() {
			this.isAdmin = this.$route.query.isadmin;
		},
		mounted() {
			this.getMobileNewsFind();
			this.getTodayRecord();
		},
		methods: {
			getMobileNewsFind() {
				this.$postRequest(`${this.$config.YDMH}mobileNews/find`, {
					pageNo: this.pageNo,
					pageSize: this.pageSize,
					title: this.searchContent,
					startDate: this.startDate,
					endDate: this.endDate,
				}).then(res => {
					this.tableData = this.tableData.concat(res.list);
					// console.log('获取手机报成功 ', res);
					this.isLoading = false;
					if (this.tableData.length == res.recordsTotal) {
						this.finished = true;
					}
				}).catch(err => {
					console.log('获取手机报失败 ', err);
					this.$toast({
						message: err,
						className: 'inexa'
					});
					this.isLoading = false;
				});
			},
			getTodayRecord() {
				this.$getRequest(`${this.$config.YDMH}mobileNews/obtainTodayRecord`)
					.then(res => {
						this.todayRecord = res.object;
					}).catch(err => {
						console.log('获取手机报草稿失败 ', err);
						this.todayRecord = {};
						this.$toast({
							message: err,
							className: 'inexa'
						});
					});
			},
			// 手机报列表已有所有信息，该接口可不用
			getDetailById(id) {
				this.$getRequest(`${this.$config.YDMH}mobileNews/findById`, {
					id: id,
				}).then(res => {
					// console.log('获取手机报详情成功 ', res);
				}).catch(err => {
					console.log('获取手机报详情失败 ', err);
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			newPhonePageEvent() {
				if (this.todayRecord == {}) {
					this.$toast({
						message: "获取草稿失败，请退出重试",
						className: 'inexa'
					});
					return;
				}
				console.log('新增手机报');
				this.todayRecord.isEdit = false;
				if (this.todayRecord.released == true) {
					this.$toast({
						message: "您今天已经发布过手机报",
						className: 'inexa'
					});
				} else {
					localStorage.setItem('tempPhoneNewsKey', JSON.stringify(this.todayRecord));
					this.$router.push({
						name: 'phonepageedit',
						params: {
							// item: JSON.stringify(this.todayRecord),
							// isEdit: false
						}
					});
				}
			},
			changeInput(value) {
				console.log('搜索 ' + value);
				this.searchContent = value;
				this.tableData = [];
				this.getMobileNewsFind();
			},
			chooseDateEvent() {
				this.show = true;
			},
			formatDate(date) {
				return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
			},
			onConfirm(date) {
				this.show = false;
				console.log(date);
				if (date.length >= 2) {
					this.startDate = this.formatDate(date[0]);
					this.endDate = this.formatDate(date[1]);
				}
				this.tableData = [];
				this.getMobileNewsFind();
			},
			gotoDraft() {
				console.log('跳转 草稿箱');
				this.todayRecord.isEdit = false;
				localStorage.setItem('tempPhoneNewsKey', JSON.stringify(this.todayRecord));
				this.$router.push({
					name: 'phonepageedit',
					params: {
						// isEdit: false
					}
				});
			},
			onRefresh() {
				console.log('下拉刷新');
				this.tableData = [];
				// this.startDate = '';
				// this.endDate = '';
				// this.pageNo = 0;
				// this.$refs.sjb_calendar.reset();
				this.getTodayRecord();
				this.getMobileNewsFind();
			},
			onLoad() {
				console.log('上拉加载');
				this.pageNo++;
				this.getMobileNewsFind();
			},
			showDetail(item) {
				console.log('点击 ');
				console.log(JSON.stringify(item));
				// this.getDetailById(item.id);
				this.$router.push({
					name: 'phonepagedetail',
					params: {
						id: item.id,
						isLoadLocalData: false,
					}
				});
			},
			editEvent(item) {
				console.log('编辑========');
				console.log(item);
				item.isEdit = true;
				localStorage.setItem('tempPhoneNewsKey', JSON.stringify(item));
				this.$router.push({
					name: 'phonepageedit',
					params: {
						// item: item,
						// isEdit: true
					}
				});
			},
			watchEvent(item) {
				console.log('查看========');
				this.showDetail(item);
			},
		}
	}
</script>

<style scoped lang="scss">
.wrap-sjb {
  display: flex;
  align-items: center;
}
.search-div-sjb {
  border: 1px solid #D2D2D2;
  border-radius: 3px;
  margin-top: 10px;
  margin-bottom: 10px;
  padding: 5px;
  outline: none;
  margin-left: 10px;
  flex: auto;
}

.search-img-sjb {
  vertical-align: middle;
  margin-left: 10px
}

.search-ipnut-sjb {
  width: 75%;
  padding-top: 5px;
  padding-bottom: 5px;
  margin-left: 5px;
  margin-right: 10px;
  outline: none;
}

.bt-sjb {
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
	.sjb-search {
    margin: 10px 0px;
		width: 100%;
		height: 36px;
		//display: flex;
		justify-content: center;
		align-items: center;

		.sjb-search-div {
			//width: 100%;
			//flex: 1;
			//float: left;
			//height: 36px;
      line-height: 30px;
			border: 1px solid #D2D2D2;
			border-radius: 18px;
			align-items: center;
			//margin-top: 10px;
			//margin-bottom: 10px;
			margin: 0px 10px;
			//display: flex;
			//padding: 3px 5px;
		}

		.sjb-search-img {
			vertical-align: middle;
			margin-left: 10px;
		}

		.sjb-search-ipnut {
			//width: 60%;
			flex: 1;
			padding-top: 5px;
			padding-bottom: 5px;
			margin-left: 5px;
			margin-right: 10px;
			outline: none;
			font-size: 13px;
		}

		.sjb-choose-date-button {
			//flex: 2;
			float: right;
      margin-top: 6px;
      height: 28px;
      //width: 88px;
			text-align: center;
      font-size: 12px;
			color: white;
			border: none;
			background: #3b87f6;
			border-radius: 15px;
			margin-right: 2px;
		}
	}

	.div-draft-container {
		display: flex;
		align-items: center;
		justify-content: center;
		margin-top: 20px;
		font-size: 10px;
	}

	.draft-normal {
		color: #999999;
	}

	.sjb-btn-font {
		font-size: 11px;
	}

	.table-in-div {
		display: flex;
		flex-direction: column;
		width: 100%;
		height: 100%;
		font-size: 16px;
	}

	.table-cell-title-div {
		color: #3b87f6;
		float: right;
		padding-right: 8px;
		text-align: center;
	}

	.muti-function-container {
		display: flex;
		justify-content: flex-end;
	}

	.multi-function-button-left {
		font-size: small;
		margin-right: 5px;
		border-radius: 15px;
		padding: 5px 10px;
	}

	.multi-function-button {
		font-size: small;
		margin-right: 0px;
		margin-left: 10px;
		border-radius: 15px;
		padding: 5px 10px;
	}

	.button-red-color {
		color: red;
		border-color: red;
	}

	.button-green-color {
		color: #0BB955;
		border-color: #0BB955;
	}
</style>
