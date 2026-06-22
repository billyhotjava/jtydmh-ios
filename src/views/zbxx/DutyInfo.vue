<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header title="值班信息" class="nav-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
			<div>
				<van-dropdown-menu active-color="#206EEA" class="dropdown-item">
					<van-dropdown-item v-model="leftValue" :options="leftDropDownList" @change="selectLeftChange()"
						v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击筛选电厂/煤矿的按钮', actionType:'duty-factory-tab1-click'}" />
					<van-dropdown-item v-model="rightValue" :options="rightDropDownList[leftValue]"
						@change="selectRightChange()"
						v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击筛选具体电厂/煤矿的按钮', actionType:'duty-factory-tab2-click'}" />
				</van-dropdown-menu>
			</div>
			<div v-if="leftValue == 1 && filterList.length != 1" class="zbxx-notice-div">点击煤矿列表查值班详细信息</div>
		</div>
		<div v-if="filterList.length != 1" class="content-container tab-content" style="background: white">
			<div v-if="leftValue == 0" v-for="(item, index) in filterList" :key="index">
				<div class="content-bg" v-if="getShowFactory(item.factoryCoalMineName)">
					<div class="elec-div">
						{{item.factoryCoalMineName}}
					</div>
					<div class="elec-line"></div>
					<div :class='["bottom-info-container", i == item.dutyCommonDTOList.length - 1 ? "bottom-info-last-margin" : ""]'
						v-for="(duty, i) in item.dutyCommonDTOList" :key="i">
						<div class="left-info-container">
							<div v-if="duty.dutyType == 0" class="duty-icon-div duty-zhiban-active-div">
								值
							</div>
							<div v-if="duty.dutyType == 1" class="duty-icon-div duty-daiban-active-div">
								带
							</div>
							<div v-if="duty.userName" class="user-div">
								{{duty.userName}}
							</div>
							<div class="station-div">
								{{duty.position}}
							</div>
						</div>
						<div class="phone-container" @click="callphone(duty.mobile)">
							<img v-if="duty.mobile" src="../../assets/images/zbxx/phone.png" class="phone-img">
							<div v-if="duty.mobile" class="phone-div">
								{{duty.mobile}}
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--   煤矿   -->
			<div v-if="leftValue == 1" class="content-bg" v-for="(item, index) in filterList" :key="index"
				@click="filterData(item)"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击查看${item.factoryCoalMineName}的具体内容的按钮`, actionType:'duty-factory-info-click'}">
				<div class="elec-title-container">
					<div class="elec-div">
						{{item.factoryCoalMineName}}
					</div>
					<!-- <div class="elec-des-div">
						{{getCurrentDuty()}}
					</div> -->
					<img src="../../assets/images/arrow.png" class="right-img" />
				</div>
				<div class="elec-line"></div>
				<div :class='[duty.dutyType == 0 || (duty.dutyType == 1 && duty.shift == getCurrentDuty()) ? "bottom-info-container" : "", i == item.dutyCommonDTOList.length - 1 ? "bottom-info-last-margin" : ""]'
					v-for="(duty, i) in item.dutyCommonDTOList" :key="i">
					<div class="left-info-container">
						<div v-if="duty.dutyType == 0" class="duty-icon-div duty-zhiban-active-div">
							值
						</div>
						<div v-if="duty.dutyType == 1 && duty.shift == getCurrentDuty() && duty.userName"
							class="duty-icon-div duty-daiban-active-div">
							带
						</div>
						<div v-if="duty.dutyType == 0 || (duty.dutyType == 1 && duty.shift == getCurrentDuty())"
							class="user-div">
							{{duty.userName}}
						</div>
						<div v-if="duty.dutyType == 0 || (duty.dutyType == 1 && duty.shift == getCurrentDuty())"
							class="station-div">
							{{duty.position}}
						</div>
					</div>
					<div v-if="duty.dutyType == 0 || (duty.dutyType == 1 && duty.shift == getCurrentDuty())"
						class="phone-container" @click.stop="callphone(duty.mobile)">
						<img v-if="duty.mobile" src="../../assets/images/zbxx/phone.png" class="phone-img">
						<div v-if="duty.mobile" class="phone-div">
							{{duty.mobile}}
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--  筛选  -->
		<div v-if="filterList.length == 1" class="content-container tab-content" style="background: white">
			<!--   大底   -->
			<div class="" v-for="(item, index) in filterList" :key="index">
				<!--    值、带底    -->
				<div :class='["bottom-detail-info-container", duty.dutyType == 0 || (duty.dutyType == 1 && i == 0) ? "bottom-detail-info-first-container" : "bottom-detail-info-not-first-container", (duty.dutyType == 0 || (duty.dutyType == 1 && checkIsTheLastDaiban(item.dutyCommonDTOList, i))) ? "bottom-detail-info-bottom-corner" : ""]'
					v-for="(duty, i) in item.dutyCommonDTOList" :key="i" v-if="duty.userName">
					<div class="top-detail-info-container">
						<div class="duty-detail-left-icon-container">
							<div v-if="duty.dutyType == 0" class="duty-detail-icon-div duty-zhiban-active-div">
								值
							</div>
							<div v-if="(leftValue == 0 && duty.dutyType == 1) || (leftValue == 1 && duty.dutyType == 1 && checkIsTheFirstDaiban(item.dutyCommonDTOList, i))"
								class="duty-detail-icon-div duty-daiban-active-div">
								带
							</div>
						</div>
						<div class="duty-detail-right-info-container">
							<div class="duty-detail-name-container">
								<div class="duty-detail-name-div">
									{{duty.userName}}
								</div>
								<div class="duty-detail-position-div">
									{{duty.position}}
								</div>
								<!--                <div v-if="duty.dutyType == 1 && duty.shift" class="duty-detail-position-shift-div">-->
								<!--                  {{duty.shift}}-->
								<!--                  值班-->
								<!--                </div>-->
								<img v-if="duty.dutyType == 1 && duty.shift == '早班'"
									class="duty-detail-position-shift-div" src="../../assets/images/zbxx/早班@2x.png">
								<img v-if="duty.dutyType == 1 && duty.shift == '中班'"
									class="duty-detail-position-shift-div" src="../../assets/images/zbxx/中班@2x.png">
								<img v-if="duty.dutyType == 1 && duty.shift == '夜班'"
									class="duty-detail-position-shift-div" src="../../assets/images/zbxx/夜班@2x.png">
							</div>
							<div class="duty-detail-mobile-container" @click="callphone(duty.mobile)">
								<img src="../../assets/images/zbxx/phone.png" class="duty-detail-mobile-img">
								<div class="duty-detail-mobile-div">
									{{duty.mobile}}
								</div>
							</div>
						</div>
					</div>
					<!--          <div v-if="duty.dutyType == 1 && !checkIsTheLastDaiban(item.dutyCommonDTOList, i)" class="bottom-detail-daiban-info-line-div"></div>-->
					<div v-if="duty.dutyType == 1 && getDaibanCount(item.dutyCommonDTOList) != 1"
						class="bottom-detail-daiban-info-line-div"></div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	export default {
		name: "DutyInfo",
		data() {
			return {
				leftValue: 0,
				leftDropDownList: [{
						text: '电厂',
						value: 0
					},
					{
						text: '煤矿',
						value: 1
					},
				],
				rightValue: 0,
				rightDropDownList: [
					[{
							text: '全部',
							value: 0
						},
						{
							text: '乌中旗热力厂',
							value: 1
						},
						{
							text: '府谷电厂',
							value: 2
						},
						{
							text: '店塔电厂',
							value: 3
						},
						{
							text: '郭家湾电厂',
							value: 4
						},
						{
							text: '花园电厂',
							value: 5
						},
						{
							text: '大南湖电厂',
							value: 6
						},
						{
							text: '和丰电厂',
							value: 7
						},
						{
							text: '河曲电厂',
							value: 8
						},
						{
							text: '鄂温克电厂',
							value: 9
						},
						{
							text: '亿利电厂',
							value: 10
						},
						{
							text: '宝清电厂',
							value: 11
						},
						{
							text: '白马电厂',
							value: 12
						},
						// {
						// 	text: '乌拉特风电场',
						// 	value: 13
						// },
						// {
						// 	text: '白云风电场',
						// 	value: 14
						// },
						// {
						// 	text: '康保风电场',
						// 	value: 15
						// },
						{
							text: '内蒙古分公司',
							value: 16
						},
						// {
						// 	text: '技术研究院',
						// 	value: 17
						// },
						// {
						// 	text: '准东电厂',
						// 	value: 18
						// }
					],
					[{
							text: '全部',
							value: 0
						},
						{
							text: '三道沟煤矿',
							value: 1
						},
						{
							text: '黄玉川煤矿',
							value: 2
						},
						{
							text: '上榆泉煤矿',
							value: 3
						},
						{
							text: '大南湖一矿',
							value: 4
						},
						{
							text: '大南湖二矿',
							value: 5
						},
						{
							text: '沙吉海煤矿',
							value: 6
						},
						{
							text: '敏东一矿',
							value: 7
						},
						{
							text: '朝阳露天矿',
							value: 8
						},
						{
							text: '准东二矿',
							value: 9
						}
					]
				],
				dutyList: [],
				filterList: [],
				getCurrentDuty() {
					let date = new Date();
					let hour = date.getHours();
					if (hour < 8) {
						return '夜班';
					} else if (hour < 16) {
						return '早班';
					} else {
						return '中班';
					}
				},
			}
		},
		mounted() {
			this.getDuty();
		},
		methods: {
			getShowFactory(item){
				if (item == '技术研究院' || item == '准东电厂' || 
				item == '白云风电场' || item == '乌拉特风电场') {
					return false;
				}else{
					return true;
				}
			},
			selectLeftChange() {
				this.rightValue = 0;
				this.getDuty();
			},
			selectRightChange() {
				if (this.rightValue == 0) {
					this.filterList = this.dutyList;
				} else {
					let selectedFactory = this.rightDropDownList[this.leftValue][this.rightValue];
					// this.filterList = this.dutyList.filter(function(item) {
					// 	return item.factoryCoalMineName == selectedFactory.text;
					// });
					var tempFilterList = this.dutyList.filter(function(item) {
						return item.factoryCoalMineName == selectedFactory.text;
					});
					this.beforeFilter(tempFilterList);
				}
			},
			// 数据排序 && 去除掉空用户名的数据
			beforeFilter(list) {
				var dutyCommonDTOList = list[0].dutyCommonDTOList;
				// console.log(JSON.stringify(dutyCommonDTOList));
				// console.log(this.getCurrentDuty());

				var zaobanList = [];
				var zhongbanList = [];
				var yebanList = [];
				var zhibanList = [];
				var newAllList = [];
				dutyCommonDTOList.forEach((item, index) => {
					if (item.dutyType == 1) {
						if (item.shift == '早班') {
							zaobanList.push(item);
						} else if (item.shift == '中班') {
							zhongbanList.push(item);
						} else if (item.shift == '夜班') {
							yebanList.push(item);
						}
					} else {
						zhibanList.push(item);
					}
				});
				// console.log(JSON.stringify(zaobanList));
				// console.log(JSON.stringify(zhongbanList));
				// console.log(JSON.stringify(yebanList));
				if (this.getCurrentDuty() == '早班') {
					zaobanList.forEach(item => {
						newAllList.push(item);
					});
					zhongbanList.forEach(item => {
						newAllList.push(item);
					});
					yebanList.forEach(item => {
						newAllList.push(item);
					});
				} else if (this.getCurrentDuty() == '中班') {
					zhongbanList.forEach(item => {
						newAllList.push(item);
					});
					zaobanList.forEach(item => {
						newAllList.push(item);
					});
					yebanList.forEach(item => {
						newAllList.push(item);
					});
				} else if (this.getCurrentDuty() == '夜班') {
					yebanList.forEach(item => {
						newAllList.push(item);
					});
					zaobanList.forEach(item => {
						newAllList.push(item);
					});
					zhongbanList.forEach(item => {
						newAllList.push(item);
					});
				}
				zhibanList.forEach(item => {
					newAllList.push(item);
				});
				dutyCommonDTOList = newAllList;
				list[0].dutyCommonDTOList = newAllList;
				// console.log(JSON.stringify(list[0].dutyCommonDTOList));

				// 去除员工名为空的数据
				for (var i = 0; i < dutyCommonDTOList.length; i++) {
					let item = dutyCommonDTOList[i];
					if (item.userName == null || item.userName == '') {
						dutyCommonDTOList.splice(i, 1);
					}
				}
				this.filterList = list;
			},
			swapArray(arr, index1, index2) {
				arr[index1] = arr.splice(index2, 1, arr[index1])[0];
				return arr;
			},
			getDuty() {
				this.$getRequest(`${this.$config.YDMH}duty/obtainDuty`, {
					type: this.leftValue
				}).then(res => {
					var list = res.list;
					// 去除员工名为空的数据
					for (var index = list.length - 1; index >= 0; index--) {
						let item = list[index];
						var dutyCommonDTOList = item.dutyCommonDTOList;
						for (var i = dutyCommonDTOList.length - 1; i >= 0; i--) {
							let content = dutyCommonDTOList[i];
							if (!content.hasOwnProperty('userName') || content.userName == null || content
								.userName == '') {
								dutyCommonDTOList.splice(i, 1);
							}
						}
						if (dutyCommonDTOList == [] || dutyCommonDTOList.length == 0) {
							list.splice(index, 1);
							// 删除本地 右侧选择数据中列表为空的数据
							for (var inIndex = 0; inIndex < this.rightDropDownList[this.leftValue]
								.length; inIndex++) {
								let info = this.rightDropDownList[this.leftValue][inIndex];
								if (info.text == item.factoryCoalMineName) {
									console.log('删除删除', this.rightDropDownList[this.leftValue][inIndex]);
									this.rightDropDownList[this.leftValue].splice(inIndex, 1);
									break;
								}
							}
						}
					}
					this.dutyList = res.list;
					this.filterList = res.list;
				}).catch(err => {
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			filterData(item, index) {
				// let that = this;
				// this.rightDropDownList[this.leftValue].forEach((inItem) => {
				//   if (inItem.text == item.factoryCoalMineName) {
				//     that.rightValue = inItem.value;
				//   }
				// });
				// this.filterList = [item];
				//按照nq要求right筛选在本页，点击煤矿列表进下一页，难受
				this.$router.push({
					name: 'zbDetail',
					params: {
						item: JSON.stringify(item)
					}
				});
			},
			checkIsTheFirstDaiban(list, index) {
				for (var i = 0; i < list.length; i++) {
					if (list[i].dutyType == 1) {
						return i == index;
					}
				}
			},
			checkIsTheLastDaiban(list, index) {
				for (var i = list.length - 1; i >= 0; i--) {
					if (list[i].dutyType == 1) {
						return i == index;
					}
				}
			},
			getDaibanCount(list) {
				var count = 0;
				list.forEach((item) => {
					if (item.dutyType == 1) {
						count++;
					}
				});
				return count;
			},
			callphone(mobile) {
				console.log('进入拨打电话方法了');
				window.plugins.CallNumber.callNumber(() => {
					console.log('成功拨打电话');
				}, () => {
					console.log('拨打电话失败');
				}, mobile, true);
			}
		},
	}
</script>

<style scoped>
	.nav-header {}

	.dropdown-item {
		height: 43.0px;
	}

	>>>.van-dropdown-menu__bar {
		height: 43.0px;
	}

	>>>.van-dropdown-menu__title {
		color: #333333;
		font-weight: bold;
	}

	.content-bg {
		background: #F1F7FE;
		margin: 17px 14px;
		border-radius: 8px;
	}

	.elec-div {
		color: #5D5D5D;
		padding: 10px 8px 10px 14px;
		font-size: 15px;
	}

	.elec-line {
		border-bottom: 1px solid #E0E3E7;
		margin: 0px 14px;
	}

	.bottom-info-container {
		display: flex;
		flex-direction: row;
		/*padding: 18px 10px 20px 14px;*/
		margin: 14px 14px 20px 14px;
	}

	.bottom-info-last-margin {
		padding-bottom: 16px;
	}

	.left-info-container {
		display: flex;
		flex-direction: row;
		width: 70%;
	}

	.duty-icon-div {
		margin-top: -1px;
		color: white;
		width: 20px;
		height: 20px;
		border-radius: 50%;
		font-size: 13px;
		text-align: center;
		line-height: 20px;
	}

	.duty-zhiban-active-div {
		background: #206EEA;
	}

	.duty-daiban-active-div {
		background: #FF7E00;
	}

	.user-div {
		margin: 0px 8px;
		color: black;
		font-size: 18px;
		font-weight: bold;
		flex: 3;
	}

	.station-div {
		color: #646464;
		font-size: 14px;
		line-height: 20px;
		margin-top: 1px;
		margin-right: 8px;
		flex: 5;
	}

	.phone-container {
		display: flex;
		flex-direction: row;
		margin-left: auto;
	}

	.phone-img {
		width: 10px;
		height: 13px;
		margin-top: 4px;
		margin-right: 6px;
	}

	.phone-div {
		color: #333333;
		font-weight: bold;
		font-size: 14px;
		line-height: 20px;
		margin-top: 1px;
		margin-left: auto;
	}

	.elec-title-container {
		display: flex;
		flex-direction: row;
	}

	.elec-des-div {
		color: red;
		font-size: 13px;
		text-align: center;
		line-height: 38px;
	}

	.right-img {
		width: 8px;
		height: 14px;
		margin-left: auto;
		margin-right: 12px;
		margin-top: 12px;
	}

	/*筛选*/
	.bottom-detail-info-container {
		background: #F1F7FE;
		/*border-radius: 8px;*/
		display: flex;
		flex-direction: column;
		padding: 22px 20px 12px 24px;
		margin: 0px 17px;
	}

	.bottom-detail-info-first-container {
		border-top-left-radius: 8px;
		border-top-right-radius: 8px;
		margin-top: 14px;
		padding: 22px 20px 12px 24px;
	}

	.bottom-detail-info-not-first-container {
		padding: 2px 20px 12px 24px;
	}

	.bottom-detail-info-bottom-corner {
		border-bottom-left-radius: 8px;
		border-bottom-right-radius: 8px;
	}

	.top-detail-info-container {
		display: flex;
	}

	.bottom-detail-daiban-info-line-div {
		margin-top: 12px;
		border-bottom: 1px solid #E0E3E7;
		width: 100%;
		height: 1px;
	}

	.duty-detail-left-icon-container {
		flex: 1.3;
	}

	.duty-detail-icon-div {
		font-size: 20px;
		font-weight: normal;
		width: 28px;
		height: 28px;
		color: white;
		text-align: center;
		line-height: 26px;
		border-radius: 14px;
	}

	.duty-detail-right-info-container {
		flex: 8;
		display: flex;
		flex-direction: column;
		padding-top: 5px;
	}

	.duty-detail-name-container {
		display: flex;
	}

	.duty-detail-name-div {
		font-size: 18px;
		font-weight: bold;
		color: black;
	}

	.duty-detail-position-div {
		font-size: 12px;
		font-weight: normal;
		color: #646464;
		margin: 6px 0px 0px 8px;
	}

	.duty-detail-position-shift-div {
		margin-left: 7px;
		/*font-size: 16px;*/
		/*transform: scale(0.6);*/
		/*font-weight: normal;*/
		color: white;
		/*background: #3ea0ab;*/
		width: 14px;
		height: 14px;
		/*border-radius: 11px;*/
		text-align: center;
		margin-top: 3px;
		/*padding-top: 2px;*/
	}

	.duty-detail-mobile-container {
		display: flex;
		margin-top: 12px;
	}

	.duty-detail-mobile-img {
		width: 10px;
		height: 13px;
		margin-top: 4px;
		margin-right: 6px;
	}

	.duty-detail-mobile-div {
		font-size: 15px;
		font-weight: bold;
		color: #333333;
		margin-top: 2px;
	}
	
	.zbxx-notice-div{
		font-weight: bold;
		color: orangered;
		font-size: 13px;
		margin: 15px 5px 0px 30px;
	}
</style>
