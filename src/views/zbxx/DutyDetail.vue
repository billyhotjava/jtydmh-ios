<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header title="值班信息" class="nav-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
		</div>
		<div class="content-container tab-content" style="background: white">
			<!--    值、带底    -->
			<div :class='["bottom-detail-info-container", duty.dutyType == 0 || (duty.dutyType == 1 && i == 0) ? "bottom-detail-info-first-container" : "bottom-detail-info-not-first-container", (duty.dutyType == 0 || (duty.dutyType == 1 && checkIsTheLastDaiban(item.dutyCommonDTOList, i))) ? "bottom-detail-info-bottom-corner" : ""]'
				v-for="(duty, i) in item.dutyCommonDTOList" :key="i">
				<div class="top-detail-info-container">
					<div class="duty-detail-left-icon-container">
						<div v-if="duty.dutyType == 0" class="duty-detail-icon-div duty-zhiban-active-div">
							值
						</div>
						<div v-if="(duty.dutyType == 1 && checkIsTheFirstDaiban(item.dutyCommonDTOList, i))"
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
<!--							<div v-if="duty.dutyType == 1 && duty.shift" class="duty-detail-position-shift-div">-->
<!--								{{duty.shift}}-->
<!--							</div>-->
              <img v-if="duty.dutyType == 1 && duty.shift == '早班'" class="duty-detail-position-shift-div" src="../../assets/images/zbxx/早班@2x.png">
              <img v-if="duty.dutyType == 1 && duty.shift == '中班'" class="duty-detail-position-shift-div" src="../../assets/images/zbxx/中班@2x.png">
              <img v-if="duty.dutyType == 1 && duty.shift == '夜班'" class="duty-detail-position-shift-div" src="../../assets/images/zbxx/夜班@2x.png">
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
</template>

<script>
	export default {
		name: "DutyInfo",
		data() {
			return {
				item: {},
				getCurrentDuty() {
					let date = new Date();
					let hour = date.getHours();
					let minutes = date.getMinutes();
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
		activated() {
			let tempItem = JSON.parse(this.$route.params.item);
      var dutyCommonDTOList = tempItem.dutyCommonDTOList;
      // console.log('dutyCommonDTOList', JSON.stringify(tempItem.dutyCommonDTOList));

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
      tempItem.dutyCommonDTOList = newAllList;
      // console.log(JSON.stringify(tempItem.dutyCommonDTOList));

      /*
      for (let i = 0; i < dutyCommonDTOList.length; i++) {
        if (dutyCommonDTOList[i].dutyType == 1) {
          if (this.getCurrentDuty() == '早班') {
            if (dutyCommonDTOList[i].shift == this.getCurrentDuty()) {
              if (i != 0) {
                this.swapArray(dutyCommonDTOList, 0, i);
              }
              if (dutyCommonDTOList[1].dutyType == 1) {
                if (dutyCommonDTOList[1].shift != '中班') {
                  if (dutyCommonDTOList[2].dutyType == 2) {
                    this.swapArray(dutyCommonDTOList, 1, 2);
                  }
                }
              }
              break;
            }
          } else if (this.getCurrentDuty() == '中班') {
            if (dutyCommonDTOList[i].shift == this.getCurrentDuty()) {
              if (i != 0) {
                this.swapArray(dutyCommonDTOList, 0, i);
              }
              if (dutyCommonDTOList[1].dutyType == 1) {
                if (dutyCommonDTOList[1].shift != '早班') {
                  if (dutyCommonDTOList[2].dutyType == 2) {
                    this.swapArray(dutyCommonDTOList, 1, 2);
                  }
                }
              }
              break;
            }
          } else {
            if (dutyCommonDTOList[i].shift == this.getCurrentDuty()) {
              if (i != 0) {
                this.swapArray(dutyCommonDTOList, 0, i);
              }
              if (dutyCommonDTOList[1].dutyType == 1) {
                if (dutyCommonDTOList[1].shift != '早班') {
                  if (dutyCommonDTOList[2].dutyType == 2) {
                    this.swapArray(dutyCommonDTOList, 1, 2);
                  }
                }
              }
              break;
            }
          }
        }
      }

       */
      // 去除员工名为空的数据
      for (var i = 0; i < dutyCommonDTOList.length; i++) {
        let item = dutyCommonDTOList[i];
        if (item.userName == null || item.userName == '') {
          dutyCommonDTOList.splice(i, 1);
        }
      }
      this.item = tempItem;
		},
		mounted() {

		},
		methods: {
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
			callphone(mobile){
				window.plugins.CallNumber.callNumber(() => {
				  console.log('成功拨打电话');
				}, () => {
				  console.log('拨打电话失败');
				}, mobile, true);
			},
      swapArray(arr, index1, index2) {
        arr[index1] = arr.splice(index2, 1, arr[index1])[0];
        return arr;
      },
		},
	}
</script>

<style scoped>
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
</style>
