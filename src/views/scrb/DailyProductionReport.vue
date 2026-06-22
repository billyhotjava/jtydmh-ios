<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header title="调度日报" class="nav-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
			<div class="segmentcontrol-container" @click="chooseDate"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击筛选生产日报的起始结束日期的按钮', actionType:'daily-production-report-date-click'}">
				<div class="segmentcontrol-item">
					{{leftSegmentTitle}}
					<img src="../../assets/images/scrb/arrow_down.png" class="date-selected-img" />
				</div>
				<div class="segmentcontrol-item">
					{{rightSegmentTitle}}
					<img src="../../assets/images/scrb/arrow_down.png" class="date-selected-img" />
				</div>
			</div>
			<van-calendar color="#3b87f6" v-model="show" type="range" :min-date="minDate" :max-date="maxDate"
				:show-confirm="false" @confirm="onConfirm" allow-same-day />
		</div>
		<div class="content-container tab-content">
			<van-pull-refresh v-model="isLoading" success-text="刷新成功" @refresh="onRefresh">
				<van-list class="van-list-container" v-model="isLoading" :finished="finished" finished-text="没有更多了"
					@load="onLoad" :immediate-check="false" :offset="20">
					<van-cell v-for="(item, index) in tableData" :key="index" @click="showDetail(item)" is-link
						v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击查看${item.sendTitle}具体内容的按钮`, actionType:'daily-production-report-info-click'}">
						<template>
							<div class="table-in-div">
								<div class="table-cell-title-div">{{item.sendTitle}}</div>
								<div class="table-cell-subtitle-div">发布人：{{item.createUserName}}</div>
							</div>
						</template>
					</van-cell>
				</van-list>
			</van-pull-refresh>
		</div>
	</div>
</template>

<script>
	export default {
		name: "DailyProductionReport",
		data() {
			return {
				leftSegmentTitle: '开始时间',
				rightSegmentTitle: '结束时间',
				minDate: new Date(2010, 0, 1),
				maxDate: new Date(),
				startDate: '',
				endDate: '',
				show: false,
				tableData: [],
				isLoading: false,
				finished: false,
				pageNo: 1,
				pageSize: 10,
			}
		},
		created() {
			this.getProductDailyList();
		},
		methods: {
			chooseDate() {
				this.show = true;
			},
			onConfirm(date) {
				this.tableData = [];
				this.show = false;
				if (date.length >= 2) {
					this.leftSegmentTitle = this.formatDate(date[0]);
					this.rightSegmentTitle = this.formatDate(date[1]);
					this.getProductDailyList();
				}
			},
			formatDate(date) {
				let month = '';
				let day = '';
				let month1 = 0;
				if (date.getMonth() + 1 >= 10) {
					month1 = date.getMonth() + 1;
					month = month1 + '';
				} else {
					month1 = date.getMonth() + 1;
					month = '0' + month1;
				}
				if (date.getDate() >= 10) {
					day = date.getDate() + '';
				} else {
					day = '0' + date.getDate();
				}
				return `${date.getFullYear()}-${month}-${day}`;
			},
			getProductDailyList() {
				this.$getRequest(`${this.$config.YDMH}productDaily/getProductDailyList`, {
					beginDay: this.leftSegmentTitle === '开始时间' ? '' : this.leftSegmentTitle,
					endDay: this.rightSegmentTitle == '结束时间' ? '' : this.rightSegmentTitle,
					pageNo: this.pageNo,
					pageSize: this.pageSize
				}).then(res => {
					this.tableData = this.tableData.concat(res.list);
					this.isLoading = false;
					if (res.list.length < this.pageSize) {
						this.finished = true;
					}
				}).catch(err => {
					this.isLoading = false;
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			onRefresh() {
				console.log('下拉刷新');
				this.pageNo = 1;
				this.tableData = [];
				this.getProductDailyList();
			},
			onLoad() {
				console.log('上拉加载');
				this.pageNo++;
				this.getProductDailyList();
			},
			showDetail(item) {
				console.log(item);
				this.$router.push({
					name: 'dailyproductionreportdetail',
					params: {
						sendDay: item.sendDay
					}
				});
			},
		}
	}
</script>

<style scoped>
	.segmentcontrol-container {
		display: flex;
		justify-content: space-around;
		height: 43px;
		border-bottom: 1px solid #E0E3E7;
		margin: 0px 15px;
	}

	.segmentcontrol-item {
		line-height: 43px;
		font-size: 15px;
		font-weight: bold;
		color: #333333;
	}

	.date-selected-img {
		width: 13px;
		object-fit: contain;
		margin-left: 3px;
		margin-top: 16px;
	}

	.table-in-div {
		display: flex;
		flex-direction: column;
		width: 100%;
	}

	.table-cell-title-div {
		color: #333333;
		font-size: 14px;
	}

	.table-cell-subtitle-div {
		color: #9E9E9E;
		font-size: 10px;
	}

	>>>.van-cell__right-icon {
		margin-top: 12px;
	}

	>>>.van-calendar__popup.van-popup--bottom,
	.van-calendar__popup.van-popup--top {
		height: 90% !important;
	}
</style>
