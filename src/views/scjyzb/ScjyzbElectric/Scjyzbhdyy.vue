<template>
	<div class="fire-container">
		<div class="fire-title">
			{{title}}
		</div>
		<!--  实时负荷数值  -->
		<div class="ssfhsz-content" style="overflow-y: hidden;">
			<div class="con clearfix">
				<table class="table-content">
					<tbody>
						<tr>
							<th style="width: 10%;"></th>
							<th style="width: 10%;">状态</th>
							<th style="width: 18%;">装机容量<p style="font-size: 10px;margin-top: 2px;">(MW)</p>
							</th>
							<th style="width: 18%;">实时负荷<p style="font-size: 10px;margin-top: 2px;">(MW)</p>
							</th>
							<th style="width: 18%;">出力系数<p style="font-size: 10px;margin-top: 2px;">(%)</p>
							</th>
							<th style="width: 26%;">今日累计电量<p style="font-size: 10px;margin-top: 2px;">(万千瓦时)</p>
							</th>
						</tr>
						<tr v-for="(item, i) in propertyList">
							<td style="color: #000000; padding: 12px 0px;height: auto;vertical-align: middle;">
								{{ item.shortName }}
							</td>
							<td
								style="color: #000000; padding: 12px 0px;position: relative; left: 9%;transform: translateX(-50%);">
								<div
									:class='["ssfhsz-status", item.status == "0" ? "" : (item.status == 1 ? "ssfhsz-status-green" : "ssfhsz-status-red")]'>
								</div>
							</td>
							<td style="color: #000000; padding: 12px 0px;height: auto;vertical-align: middle;">
								{{ item.installedCapacity }}
							</td>
							<td style="color: #000000; padding: 12px 0px;height: auto;vertical-align: middle;">
								{{ item.realTimeLoad }}
							</td>
							<td style="color: #000000; padding: 12px 0px;height: auto;vertical-align: middle;">
								{{ item.realTimeOut }}
							</td>
							<td style="color: #000000; padding: 12px 0px;height: auto;vertical-align: middle;">
								{{ item.todayTotal }}
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!--  实时负荷曲线  -->
		<div class="ssfhqx-content">
			<div class="tit">
				<h4>实时负荷曲线</h4>
			</div>
			<div class="ssfhqx-div"
				style="display: flex; flex-direction: column; justify-content: center;align-items: center;">
				<van-tabs v-model="sellId" v-if="coalTabs != null && coalTabs.length != 0"
					style="margin-bottom: 20px; width: 70%;" line-width="28px" title-active-color="#1E6DE4"
					@click="ssfhqxTabsClick">
					<van-tab v-for="item in coalTabs" :title="item.coalName" :name="item.coalId"></van-tab>
				</van-tabs>
				<!--   今日预计完成   -->
				<div class="jryjwc-div">
					<div style="font-size: 14px; color: #535353">
						今日预计完成
					</div>
					<div style="margin-left: 25px; font-size: 18px; color: black;">
						{{curveData.estimateToday}}
					</div>
					<div class="jryjwc-unit">
						万千瓦时
					</div>
				</div>
				<div class="echart-container">
					<div class="echart-div" ref="myChartSsfhqx"></div>
				</div>
			</div>
		</div>
		<!--  昨日机组状态  -->
		<!--  先注释掉  -->
		<!--    <div class="zrjzzt-content">-->
		<!--      <div class="tit"><h4>昨日机组状态</h4></div>-->
		<!--      <div class="zrjzzt-div">-->
		<!--        <div class="zrjzzt-yx zrjzzt-yx-active">-->
		<!--          <img class="zrjzzt-img" src="../../../assets/images/scjyzb/yx.png"/>-->
		<!--          <p class="zrjzzt-title">运行</p>-->
		<!--          <div class="zrjzzt-detail">-->
		<!--            <h4 class="zrjzzt-value-title">容量</h4>-->
		<!--            <p class="zrjzzt-value">{{40}}</p>-->
		<!--            <div class="zrjzzt-unit" style="margin-top: 4px !important;">MW</div>-->
		<!--          </div>-->
		<!--          <div class="zrjzzt-detail">-->
		<!--            <h4 class="zrjzzt-value-title">台数</h4>-->
		<!--            <p class="zrjzzt-value">{{4}}</p>-->
		<!--            <div class="zrjzzt-unit">台</div>-->
		<!--          </div>-->
		<!--        </div>-->
		<!--        <div class="zrjzzt-yx zrjzzt-yx-active">-->
		<!--          <img class="zrjzzt-img" src="../../../assets/images/scjyzb/yx.png"/>-->
		<!--          <p class="zrjzzt-title">运行</p>-->
		<!--          <div class="zrjzzt-detail">-->
		<!--            <h4 class="zrjzzt-value-title">容量</h4>-->
		<!--            <p class="zrjzzt-value">{{40}}</p>-->
		<!--            <div class="zrjzzt-unit" style="margin-top: 4px !important;">MW</div>-->
		<!--          </div>-->
		<!--          <div class="zrjzzt-detail">-->
		<!--            <h4 class="zrjzzt-value-title">台数</h4>-->
		<!--            <p class="zrjzzt-value">{{4}}</p>-->
		<!--            <div class="zrjzzt-unit">台</div>-->
		<!--          </div>-->
		<!--        </div>-->
		<!--        <div class="zrjzzt-yx">-->
		<!--          <img class="zrjzzt-img" src="../../../assets/images/scjyzb/yx.png"/>-->
		<!--          <p class="zrjzzt-title">运行</p>-->
		<!--          <div class="zrjzzt-detail">-->
		<!--            <h4 class="zrjzzt-value-title">容量</h4>-->
		<!--            <p class="zrjzzt-value">{{40}}</p>-->
		<!--            <div class="zrjzzt-unit" style="margin-top: 4px !important;">MW</div>-->
		<!--          </div>-->
		<!--          <div class="zrjzzt-detail">-->
		<!--            <h4 class="zrjzzt-value-title">台数</h4>-->
		<!--            <p class="zrjzzt-value">{{4}}</p>-->
		<!--            <div class="zrjzzt-unit">台</div>-->
		<!--          </div>-->
		<!--        </div>-->
		<!--      </div>-->
		<!--    </div>-->
		<!--  发电量完成情况  -->
		<div class="fdlwcqk-content">
			<div class="tit">
				<h4>发电量完成情况</h4>
			</div>
      <!--   改成table   -->
      <div class="con clearfix">
        <table class="table-content">
          <tbody>
          <tr>
            <th></th>
            <th>日（万千瓦时）</th>
            <th>月（亿千瓦时）</th>
            <th>年（亿千瓦时）</th>
          </tr>
          <tr v-for="(item, i) in fdlwcqkTableData">
            <td class="biaoti">{{item.name}}</td>
            <td style="font-weight:bold;font-size:12px;">{{item.value[0]}}</td>
            <td style="font-weight:bold;font-size:12px;">{{item.value[1]}}</td>
            <td style="font-weight:bold;font-size:12px;">{{item.value[2]}}</td>
          </tr>
          </tbody>
        </table>
      </div>

      <!--   去掉饼状图   -->
<!--			<div class="ssfhqx-div"-->
<!--				style="display: flex; flex-direction: column; justify-content: center;align-items: center;">-->
<!--				&lt;!&ndash;   本月预计完成   &ndash;&gt;-->
<!--				&lt;!&ndash; <div class="jryjwc-div">-->
<!--					<div style="font-size: 14px; color: #535353">-->
<!--						本月预计完成-->
<!--					</div>-->
<!--					<div style="margin-left: 25px; font-size: 18px; color: black;">-->
<!--						{{ fdlwcqkData.monthPlan }}-->
<!--					</div>-->
<!--					<div class="jryjwc-unit">-->
<!--						万千瓦时-->
<!--					</div>-->
<!--				</div>-->
<!--				<div class="echart-container">-->
<!--					<div class="echart-div" ref="myChartFdlwcqk"></div>-->
<!--				</div> &ndash;&gt;-->
<!--				&lt;!&ndash;    日月年    &ndash;&gt;-->
<!--				<div class="con clearfix" style="margin-top: 10px; width: 100%;" v-if="fdlwcqkrynr != []">-->
<!--					<div class="wctype">-->
<!--						<p class="wctypep">{{fdlwcqkrynr.type}}<span class="wctypespan">万千瓦时</span></p>-->
<!--					</div>-->
<!--					<div style="width: 100%; display: flex">-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdDayWclPie"></div>-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdDayTbPie"></div>-->
<!--					</div>-->
<!--					<ul class="fdcount">-->
<!--						<li>-->
<!--							<p>超欠<span-->
<!--									:class='[fdlwcqkrynr.overDeficit > 0 ? "" : "fdlwcqk-cq-active"]'>{{fdlwcqkrynr.overDeficit}}</span>-->
<!--							</p>-->
<!--						</li>-->
<!--						<li>-->
<!--							<p>完成<span>{{fdlwcqkrynr.completion}}</span></p>-->
<!--						</li>-->
<!--						<li>-->
<!--							<p>计划<span>{{fdlwcqkrynr.plan}}</span></p>-->
<!--						</li>-->
<!--					</ul>-->
<!--					<div style="margin-top: 20px;margin-bottom: 20px"-->
<!--						v-if="fdlwcqkrynr.progressRate != null && fdlwcqkrynr.progressRate != ''">-->
<!--						<van-progress :percentage="fdlwcqkrynr.progressRate" pivot-text="" pivot-color="#E07212"-->
<!--							color="linear-gradient(to right, #E07212, #F2D300)"-->
<!--							style="height: 13px;border-radius: 7px" />-->
<!--					</div>-->
<!--				</div>-->
<!--				<div class="con clearfix" style="margin-top: 30px; width: 100%;" v-if="fdlwcqkryny != []">-->
<!--					<div class="wctype">-->
<!--						<p class="wctypep">{{fdlwcqkryny.type}}<span class="wctypespan">亿千瓦时</span></p>-->
<!--					</div>-->
<!--					<div style="width: 100%; display: flex">-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdMonthWclPie"></div>-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdMonthTbPie"></div>-->
<!--					</div>-->
<!--					<ul class="fdcount">-->
<!--						<li>-->
<!--							<p>超欠<span-->
<!--									:class='[fdlwcqkryny.overDeficit > 0 ? "" : "fdlwcqk-cq-active"]'>{{fdlwcqkryny.overDeficit}}</span>-->
<!--							</p>-->
<!--						</li>-->
<!--						<li>-->
<!--							<p>完成<span>{{fdlwcqkryny.completion}}</span></p>-->
<!--						</li>-->
<!--						<li>-->
<!--							<p>计划<span>{{fdlwcqkryny.plan}}</span></p>-->
<!--						</li>-->
<!--					</ul>-->
<!--					<div style="margin-top: 20px;margin-bottom: 20px"-->
<!--						v-if="fdlwcqkryny.progressRate != null && fdlwcqkryny.progressRate != ''">-->
<!--						<van-progress :percentage="fdlwcqkryny.progressRate" pivot-text="" pivot-color="#00CEF9"-->
<!--							color="linear-gradient(to right, #00CEF9, #0ED600)"-->
<!--							style="height: 13px;border-radius: 7px" />-->
<!--					</div>-->
<!--				</div>-->
<!--				<div class="con clearfix" style="margin-top: 30px; width: 100%;" v-if="fdlwcqkrynn != []">-->
<!--					<div class="wctype">-->
<!--						<p class="wctypep">{{fdlwcqkrynn.type}}<span class="wctypespan">亿千瓦时</span></p>-->
<!--					</div>-->
<!--					<div style="width: 100%; display: flex">-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdYearWclPie"></div>-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdYearTbPie"></div>-->
<!--					</div>-->
<!--					<ul class="fdcount">-->
<!--						<li>-->
<!--							<p>超欠<span-->
<!--									:class='[fdlwcqkrynn.overDeficit > 0 ? "" : "fdlwcqk-cq-active"]'>{{fdlwcqkrynn.overDeficit}}</span>-->
<!--							</p>-->
<!--						</li>-->
<!--						<li>-->
<!--							<p>完成<span>{{fdlwcqkrynn.completion}}</span></p>-->
<!--						</li>-->
<!--						<li>-->
<!--							<p>计划<span>{{fdlwcqkrynn.plan}}</span></p>-->
<!--						</li>-->
<!--					</ul>-->
<!--					<div style="margin-top: 20px;margin-bottom: 20px"-->
<!--						v-if="fdlwcqkrynn.progressRate != null && fdlwcqkrynn.progressRate != ''">-->
<!--						<van-progress :percentage="fdlwcqkrynn.progressRate" pivot-text="" pivot-color="#A0A0F4"-->
<!--							color="linear-gradient(to right, #A0A0F4, #7272F3)"-->
<!--							style="height: 13px;border-radius: 7px" />-->
<!--					</div>-->
<!--				</div>-->
<!--			</div>-->
		</div>
		<!--  燃料进耗存  -->
		<div class="rljhc-content">
			<div class="tit">
				<h4>燃料进耗存</h4>
			</div>
			<div class="rljhc-div">
				<div style="display: flex; line-height: 40px">
					<div style="width:120px; margin-left: 10px">
						<van-tabs v-model="activeName" @click="rljhcTabsClick" line-width="28px"
							title-active-color="#1E6DE4">
							<van-tab v-for="item in rljhcTabs" :title="item.coalName" :name="item.coalId"></van-tab>
						</van-tabs>
					</div>
					<div style="margin-left: auto">
						<div style="margin-right:20px;font-size:8px;margin-top: 4px;color: #656565;">
							万吨、天
						</div>
					</div>
				</div>
				<div class="con clearfix">
					<div class="xs">
						<ul>
							<li>
								<p2>{{rljhcInfo.capacity}}
									<p4>{{"万吨"}}</p4>
								</p2>
								<h4>库存容量</h4>
							</li>
							<li>
								<p2>{{rljhcInfo.stockM}}
									<p4>{{"万吨"}}</p4>
								</p2>
								<h4>月初库存</h4>
							</li>
							<li>
								<p2>{{rljhcInfo.stockC}}
									<p4>{{"万吨"}}</p4>
								</p2>
								<h4>当前库存</h4>
							</li>
							<li>
								<p2>{{rljhcInfo.alertDays}}
									<p4>{{"天"}}</p4>
								</p2>
								<h4>警戒天数</h4>
							</li>
							<li>
								<p2>{{rljhcInfo.availableDays}}
									<p4>{{"天"}}</p4>
								</p2>
								<h4>可用天数</h4>
							</li>
							<li>
								<p2>{{rljhcInfo.consume}}
									<p4>{{"万吨"}}</p4>
								</p2>
								<h4>近3日平均日耗</h4>
							</li>
						</ul>
					</div>
				</div>
				<div class="rljhc-wcl-div">
					<div class="rljhc-wcl-title">
						<ul>
							<li style=" width: 19%;"></li>
							<li style=" width: 19%;">计划</li>
							<li style=" width: 19%;">完成</li>
							<li style=" width: 24%;">超欠</li>
							<li style=" width: 19%;">完成率</li>
						</ul>
					</div>
					<div class="rljhc-wcl-xs" :style='[{"margin-top": index == 0 ? "20px" : "0px"}]'
						v-for="(inItem, index) in rljhcInfo.comList" :key="index">
						<ul>
							<li class="rljhc-wcl-jm-hm-title" style=" width: 19%;">{{inItem.type}}</li>
							<li class="rljhc-wcl-jm-hm-value" style=" width: 19%;">{{inItem.plan}}</li>
							<li class="rljhc-wcl-jm-hm-value" style=" width: 19%;">{{inItem.completion}}</li>
							<li class="rljhc-wcl-jm-hm-value-cq">
								<p class="rljhc-wcl-jm-hm-value" style="">{{inItem.overDeficit}}</p>
								<img v-if="inItem.overDeficit > 0"
									style="width: 14px; height: 19px; margin-top: -2px;margin-left: 5px"
									src="../../../assets/images/scjyzb/zz@2x.png">
								<img v-else style="width: 14px; height: 19px; margin-top: -2px;margin-left: 5px"
									src="../../../assets/images/scjyzb/xj@2x.png">
							</li>
							<li class="rljhc-wcl-jm-hm-value" style=" width: 19%;">{{inItem.completeRate}}</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<!--  供电煤耗及厂用电率  -->
		<div class="gdmhjcydl-content">
			<div class="tit">
				<h4>经济性指标</h4>
			</div>
			<div class="gdmhjcydl-div">
				<div class="gdmhjcydl-gdmh-div">
					<div class="gdmhjcydl-icon-div">
						<img class="gdmhjcydl-icon" src="../../../assets/images/scjyzb/klyl.png">
						<div class="gdmhjcydl-icon-title-div">供电煤耗</div>
					</div>
					<div class="gdmhjcydl-bottom-line-div">
						<div class="gdmhjcydl-bottom-line-title-div">煤耗</div>
						<div style="display: flex; margin-left: auto">
							<div class="gdmhjcydl-bottom-line-value-div">{{gdmhjcydlInfo.consumption}}</div>
							<div class="gdmhjcydl-bottom-line-unit-div">g/kwh</div>
						</div>
					</div>
					<div class="gdmhjcydl-bottom-line-div">
						<div class="gdmhjcydl-bottom-line-title-div">同比</div>
						<div style="display: flex; margin-left: auto">
							<div class="gdmhjcydl-bottom-line-value-div">{{gdmhjcydlInfo.avaOnYear}}</div>
							<div class="gdmhjcydl-bottom-line-unit-div">g/kwh</div>
						</div>
					</div>
				</div>
				<div class="gdmhjcydl-ydl-div">
					<div class="gdmhjcydl-icon-div">
						<img class="gdmhjcydl-icon" src="../../../assets/images/scjyzb/cydl.png">
						<div class="gdmhjcydl-icon-title-div">综合厂用电率</div>
					</div>
					<div class="gdmhjcydl-bottom-line-div">
						<div class="gdmhjcydl-bottom-line-title-div">用电率</div>
						<div style="display: flex; margin-left: auto">
							<div class="gdmhjcydl-bottom-line-value-div">{{gdmhjcydlInfo.powerRate}}</div>
							<div class="gdmhjcydl-bottom-line-unit-div">%</div>
						</div>
					</div>
					<div class="gdmhjcydl-bottom-line-div">
						<div class="gdmhjcydl-bottom-line-title-div">同比</div>
						<div style="display: flex; margin-left: auto">
							<div class="gdmhjcydl-bottom-line-value-div">{{gdmhjcydlInfo.powerRateOnYear}}</div>
							<div class="gdmhjcydl-bottom-line-unit-div">%</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import * as echarts from "echarts";

	export default {
		name: "Scjyzbhdyy",
		props: {
			proId: Number,
			title: {
				type: String,
				default: ''
			}
		},
		data() {
			return {
				// 机组装机、负荷信息
				propertyList: [],
				// 实时负荷曲线
				curveData: {},
				sellId: 0,
				coalTabs: [],
				// 发电量完成情况
				fdlwcqkData: {},
				// 日月年
				fdlwcqkrynr: {},
				fdlwcqkryny: {},
				fdlwcqkrynn: {},
        fdlwcqkTableData:[],
				activeName: 1,
				rljhcTabs: [{
						coalId: '1',
						coalName: '月度'
					},
					{
						coalId: '2',
						coalName: '年度'
					},
				],
				// 燃料进耗存
				rljhcInfo: {},
				// 供电煤耗及厂用电率
				gdmhjcydlInfo: {}
			}
		},
		mounted() {
			this.reloadAllData();
		},
		methods: {
			reloadAllData() {
				this.getProperty();
				setTimeout(() => {
					this.getLoadCurveData(this.proId);
				}, 1000);
				setTimeout(() => {
					this.getPowerCompletion();
					this.getCompletionRate();
				}, 2000);
				setTimeout(() => {
					this.getCoalPCD();
					this.getEconomic();
				}, 3000);
			},
			// 机组名、装机容量、获取机组实时负荷及其他信息的proId
			getProperty() {
				this.coalTabs = [];
				this.propertyList = [];
				this.$postRequest(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: 'http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/thermalPower/v1/getProperty',
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					let propertyList = res.data.list;
					let that = this;
					this.getLoadData(function(inList) {
						propertyList.forEach((item, index) => {
							that.coalTabs.push({
								coalId: index,
								coalName: item.shortName
							});
							var newInfo = {};
							Object.assign(newInfo, item, inList[index]);
							that.propertyList.push(newInfo);
						})
					})
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					// console.log(error);
				});
			},
			// 负荷数值表的其他信息
			getLoadData(callback) {
				this.$postRequest(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: 'http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/thermalPower/v1/getLoadData',
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					if (callback) {
						callback(res.data.list);
					}
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
			},
			// 实时负荷曲线
			getLoadCurveData(proId) {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: 'http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/thermalPower/v1/getLoadCurveData',
					paramMap: {
						proId: proId
					}
				}).then(res => {
					// console.log('实时负荷曲线', res.data.list);
					this.curveData = res.data.list[0];
					this.ssfhqxEcharts();
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					// console.log(error);
				});
			},
			// 实时负荷曲线 图
			ssfhqxEcharts() {
				let myChartgfssqx = echarts.init(this.$refs.myChartSsfhqx);
				myChartgfssqx.clear();
				// console.log(this.curveData.yesterday);
				var series = [];
				series.push({
					name: '计划',
					type: 'line',
					data: this.curveData.plan,
					symbol: 'none'
				});
				series.push({
					name: '预计',
					type: 'line',
					data: this.curveData.estimate,
					symbol: 'none'
				});
				series.push({
					name: '昨日',
					type: 'line',
					data: this.curveData.yesterday,
					symbol: 'none'
				});
				series.push({
					name: '今日',
					type: 'line',
					data: this.curveData.today,
					symbol: 'none'
				});
				var options = {
					tooltip: {
						trigger: 'axis',
						axisPointer: {
							type: 'shadow'
						},
					},
					grid: {
						top: '15%',
						left: '3%',
						right: '4%',
						bottom: '8%',
						containLabel: true
					},
					legend: {
						icon: 'pin',
						data: ['计划', '预计', '昨日', '今日'],
						right: '4%'
					},
					xAxis: {
						type: 'category',
						boundaryGap: false,
						data: this.curveData.xdata
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: series
				};
				myChartgfssqx.setOption(options);
			},
			// 发电量完成情况
			getPowerCompletion() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: 'http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/thermalPower/v1/getPowerCompletion',
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					// console.log('发电量完成情况', res.data);
					this.fdlwcqkData = res.data;
					// this.fdlwcqkEcharts();
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					// console.log(error);
				});
			},
			// 发电量完成情况 图
			fdlwcqkEcharts() {
				let myChartgfssqx = echarts.init(this.$refs.myChartFdlwcqk);
				myChartgfssqx.clear();
				var series = [];
				series.push({
					name: '本月',
					type: 'line',
					data: this.fdlwcqkData.month,
					symbol: 'none'
				});
				series.push({
					name: '同期',
					type: 'line',
					data: this.fdlwcqkData.period,
					symbol: 'none'
				});
				series.push({
					name: '计划',
					type: 'line',
					data: this.fdlwcqkData.dayAvgPlan,
					symbol: 'none'
				});
				series.push({
					name: '需发',
					type: 'line',
					data: this.fdlwcqkData.dayAvgNeed,
					symbol: 'none'
				});
				var options = {
					tooltip: {
						trigger: 'axis',
						axisPointer: {
							type: 'shadow'
						},
					},

					grid: {
						top: '15%',
						left: '3%',
						right: '4%',
						bottom: '8%',
						containLabel: true
					},
					legend: {
						icon: 'pin',
						data: ['本月', '同期', '计划', '需发'],

						right: '4%'
					},
					xAxis: {
						type: 'category',
						boundaryGap: false,
						data: this.fdlwcqkData.xdata
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: series
				};
				myChartgfssqx.setOption(options);
			},
			// 日月年
			getCompletionRate() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: 'http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/thermalPower/v1/getCompletionRate',
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					// console.log('日月年', JSON.stringify(res.data.list));
					this.fdlwcqkrynr = res.data.list[0];
					this.fdlwcqkryny = res.data.list[1];
					this.fdlwcqkrynn = res.data.list[2];
          let obj = [
            {
              name: '计划',
              value: [],
            },
            {
              name: '超欠',
              value: [],
            },
            {
              name: '完成',
              value: [],
            },
            {
              name: '完成率',
              value: [],
            },
            {
              name: '同比',
              value: [],
            }
          ];
          res.data.list.forEach((item) => {
            obj[0].value.push(item.plan);
            obj[1].value.push(item.overDeficit);
            obj[2].value.push(item.completion);
            obj[3].value.push(item.comRate + '%');
            obj[4].value.push(item.onYear)
          });
          this.fdlwcqkTableData = obj;
					// this.loadDayFdwclCircle();
					// this.loadDayFdtbCircle();
					// this.loadMonthFdwclCircle();
					// this.loadMonthFdtbCircle();
					// this.loadYearFdwclCircle();
					// this.loadYearFdtbCircle();
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					// console.log(error);
				});
			},
			//发电量完成情况(完成率)
			loadDayFdwclCircle() {
				let fdDayWclPie = echarts.init(this.$refs.fdDayWclPie);
				fdDayWclPie.clear();
				fdDayWclPie.setOption({
					title: {
						text: this.fdlwcqkrynr.comRate + "%",
						left: "center",
						top: "40%",
						textStyle: {
							color: "#000",
							fontSize: 20,
							align: "center"
						},
						background: "#fff"
					},
					graphic: {
						type: "text",
						left: "center",
						top: "57%",
						style: {
							text: "完成率",
							color: "#777777",
							fontSize: 12,
							textAlign: "center",
						},
					},
					color: ['#EAA808', '#D0D0D0'],
					series: [{
						name: "",
						type: "pie",
						radius: ['50%', '70%'],
						itemStyle: {
							borderRadius: 1,
							borderColor: "#fff",
							borderWidth: 2
						},
						label: {
							show: false,
							position: "center"
						},
						emphasis: {
							label: {
								show: false,
								fontSize: "40",
								fontWeight: "bold"
							}
						},
						labelLine: {
							show: false
						},
						data: [this.fdlwcqkrynr.comRate, 100 - this.fdlwcqkrynr.comRate]
					}]
				});
			},
			//发电量完成情况(同比)
			loadDayFdtbCircle() {
				let fdDayTbPie = echarts.init(this.$refs.fdDayTbPie);
				fdDayTbPie.clear();
				fdDayTbPie.setOption({
					title: {
						text: this.fdlwcqkrynr.onYear,
						left: "center",
						top: "40%",
						textStyle: {
							color: "#000",
							fontSize: 20,
							align: "center"
						},
					},
					graphic: {
						type: "text",
						left: "center",
						top: "57%",
						style: {
							text: "同比",
							color: "#777777",
							fontSize: 12,
							textAlign: "center",
						},
						backgroundColor: '#fff',
					},
					color: ['#95A4BC'],
					series: [{
						name: "",
						type: "pie",
						radius: ['50%', '70%'],
						itemStyle: {
							borderRadius: 1,
							borderColor: "#fff",
							borderWidth: 2
						},
						label: {
							show: false,
							position: "center"
						},
						emphasis: {
							label: {
								show: false,
								fontSize: "40",
								fontWeight: "bold"
							}
						},
						labelLine: {
							show: false
						},
						data: [Math.abs(this.fdlwcqkrynr.onYear)]
					}]
				});
			},
			//发电量完成情况(完成率)
			loadMonthFdwclCircle() {
				let fdDayWclPie = echarts.init(this.$refs.fdMonthWclPie);
				fdDayWclPie.clear();
				fdDayWclPie.setOption({
					title: {
						text: this.fdlwcqkryny.comRate + "%",
						left: "center",
						top: "40%",
						textStyle: {
							color: "#000",
							fontSize: 20,
							align: "center"
						},
						background: "#fff"
					},
					graphic: {
						type: "text",
						left: "center",
						top: "57%",
						style: {
							text: "完成率",
							color: "#777777",
							fontSize: 12,
							textAlign: "center",
						},
					},
					color: ['#26C002', '#D0D0D0'],
					series: [{
						name: "",
						type: "pie",
						radius: ['50%', '70%'],
						itemStyle: {
							borderRadius: 1,
							borderColor: "#fff",
							borderWidth: 2
						},
						label: {
							show: false,
							position: "center"
						},
						emphasis: {
							label: {
								show: false,
								fontSize: "40",
								fontWeight: "bold"
							}
						},
						labelLine: {
							show: false
						},
						data: [this.fdlwcqkryny.comRate, 100 - this.fdlwcqkryny.comRate]
					}]
				});
			},
			//发电量完成情况(同比)
			loadMonthFdtbCircle() {
				let fdDayTbPie = echarts.init(this.$refs.fdMonthTbPie);
				fdDayTbPie.clear();
				fdDayTbPie.setOption({
					title: {
						text: this.fdlwcqkryny.onYear,
						left: "center",
						top: "40%",
						textStyle: {
							color: "#000",
							fontSize: 20,
							align: "center"
						},
					},
					graphic: {
						type: "text",
						left: "center",
						top: "57%",
						style: {
							text: "同比",
							color: "#777777",
							fontSize: 12,
							textAlign: "center",
						},
						backgroundColor: '#fff',
					},
					color: ['#95A4BC'],
					series: [{
						name: "",
						type: "pie",
						radius: ['50%', '70%'],
						itemStyle: {
							borderRadius: 1,
							borderColor: "#fff",
							borderWidth: 2
						},
						label: {
							show: false,
							position: "center"
						},
						emphasis: {
							label: {
								show: false,
								fontSize: "40",
								fontWeight: "bold"
							}
						},
						labelLine: {
							show: false
						},
						data: [Math.abs(this.fdlwcqkryny.onYear)]
					}]
				});
			},
			//发电量完成情况(完成率)
			loadYearFdwclCircle() {
				let fdDayWclPie = echarts.init(this.$refs.fdYearWclPie);
				fdDayWclPie.clear();
				fdDayWclPie.setOption({
					title: {
						text: this.fdlwcqkrynn.comRate + "%",
						left: "center",
						top: "40%",
						textStyle: {
							color: "#000",
							fontSize: 20,
							align: "center"
						},
						background: "#fff"
					},
					graphic: {
						type: "text",
						left: "center",
						top: "57%",
						style: {
							text: "完成率",
							color: "#777777",
							fontSize: 12,
							textAlign: "center",
						},
					},
					color: ['#6767D5', '#D0D0D0'],
					series: [{
						name: "",
						type: "pie",
						radius: ['50%', '70%'],
						itemStyle: {
							borderRadius: 1,
							borderColor: "#fff",
							borderWidth: 2
						},
						label: {
							show: false,
							position: "center"
						},
						emphasis: {
							label: {
								show: false,
								fontSize: "40",
								fontWeight: "bold"
							}
						},
						labelLine: {
							show: false
						},
						data: [this.fdlwcqkrynn.comRate, 100 - this.fdlwcqkrynn.comRate]
					}]
				});
			},
			//发电量完成情况(同比)
			loadYearFdtbCircle() {
				let fdDayTbPie = echarts.init(this.$refs.fdYearTbPie);
				fdDayTbPie.clear();
				fdDayTbPie.setOption({
					title: {
						text: this.fdlwcqkrynn.onYear,
						left: "center",
						top: "40%",
						textStyle: {
							color: "#000",
							fontSize: 20,
							align: "center"
						},
					},
					graphic: {
						type: "text",
						left: "center",
						top: "57%",
						style: {
							text: "同比",
							color: "#777777",
							fontSize: 12,
							textAlign: "center",
						},
						backgroundColor: '#fff',
					},
					color: ['#95A4BC'],
					series: [{
						name: "",
						type: "pie",
						radius: ['50%', '70%'],
						itemStyle: {
							borderRadius: 1,
							borderColor: "#fff",
							borderWidth: 2
						},
						label: {
							show: false,
							position: "center"
						},
						emphasis: {
							label: {
								show: false,
								fontSize: "40",
								fontWeight: "bold"
							}
						},
						labelLine: {
							show: false
						},
						data: [Math.abs(this.fdlwcqkrynn.onYear)]
					}]
				});
			},
			// 燃料进耗存
			getCoalPCD() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: 'http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/thermalPower/v1/getCoalPCD',
					paramMap: {
						proId: this.proId,
						type: this.activeName
					}
				}).then(res => {
					// console.log('燃料进耗存', res.data);
					this.rljhcInfo = res.data.stockList[0];
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					// console.log(error);
				});
			},
			// 供电煤耗及厂用电率
			getEconomic() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: 'http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/thermalPower/v1/getEconomic',
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					// console.log("供电煤耗及厂用电率", res.data);
					this.gdmhjcydlInfo = res.data[0];
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					// console.log(error);
				});
			},
			ssfhqxTabsClick() {
				// console.log(this.sellId);
				let proId = this.propertyList[this.sellId].proId;
				this.getLoadCurveData(proId);
			},
			rljhcTabsClick() {
				this.getCoalPCD();
			},
		},
		watch: {
			proId(newValue, oldValue) {
				this.reloadAllData();
			}
		}
	}
</script>

<style scoped>
	.fire-container {
		margin: 24px 16px;
	}

	.fire-title {
		text-align: center;
	}

	.ssfhsz-content {
		background: #EEF6FE;
		border-radius: 8px;
		padding: 10px 8px;
		margin: 14px 0px;
		overflow-y: hidden;
	}

	.ssfhsz-status {
		width: 16px;
		height: 16px;
		border-radius: 8px;
	}

	.ssfhsz-status-green {
		background: #09C800;
	}

	.ssfhsz-status-red {
		background: #DD0000;
	}

	.jryjwc-div {
		width: 100%;
		background: #EEF6FE;
		border-radius: 8px;
		text-align: center;
		justify-content: center;
		line-height: 20px;
		display: flex;
		flex-direction: row;
		padding: 16px 0px;
	}

	.jryjwc-unit {
		margin-left: 5px;
		font-size: 9px;
		color: #535353;
		transform: scale(0.8);
		/*margin-top: 0px;*/
		/*margin-left: 0px;*/
	}

	.echart-container {
		width: 100%;
		margin-top: 20px;
	}

	.echart-div {
		text-align: center;
		width: 100%;
		height: 180px;
	}

  .biaoti {
    font-size: 12px;
    font-weight: 700;
    color: #5c5c5c;
    margin: 20px 0px 10px 0px;
  }

	.zrjzzt-div {
		background: #EEF6FE;
		border-radius: 8px;
		padding: 10px 0px;
		display: flex;
	}

	.zrjzzt-yx {
		display: flex;
		flex-direction: column;
		flex: 1;
		align-items: center;
		justify-content: center;
		margin: 15px 0px;
	}

	.zrjzzt-yx-active {
		border-right: 1px #DDDDDD solid;
	}

	.zrjzzt-detail {
		display: flex;
		flex-direction: row;
		padding-top: 12px;
		line-height: 30px;
	}

	.zrjzzt-img {
		width: 30px;
		height: 30px;
	}

	.zrjzzt-title {
		font-size: 12px;
		color: #5D5D5D;
		margin-top: 8px;
		font-weight: 700;
	}

	.zrjzzt-value-title {
		font-size: 12px;
		color: #656565;
		margin-top: 1px;
		width: 33px;
	}

	.zrjzzt-value {
		font-size: 20px;
		color: #000000;
		font-weight: 700;
		width: 50px;
		text-align: center;
	}

	.zrjzzt-unit {
		font-size: 12px;
		transform: scale(0.8);
		color: #7F7F7F;
		margin-top: 2px;
		width: 24px;
	}

	.rljhc-div {
		background: #EEF6FE;
		border-radius: 10px;
		padding-bottom: 10px;
	}

	::v-deep .van-tabs__wrap .van-tabs__nav {
		background: unset;
	}

	::v-deep .van-tabs__wrap .van-tab__text--ellipsis {
		font-weight: bold;
	}

	.rljhc-wcl-div {
		display: flex;
		flex-direction: column;
		margin-top: 20px;
	}

	.rljhc-wcl-title {
		/*display: flex;*/
		background: #CDE5FF;
		border-radius: 15px;
		margin: 0px 10px;
		height: 30px;
		color: #656565;
		font-size: 14px;
		text-align: center;
		justify-content: center;
		align-items: center;
		/*justify-content: space-around;*/
		/*align-items: center;*/
	}

	.rljhc-wcl-title ul {}

	.rljhc-wcl-title ul li {
		float: left;
		text-align: center;
		padding-top: 3px;
		line-height: 1.5rem
	}

	.rljhc-wcl-jm {
		display: flex;
		padding-top: 20px;
		margin-left: 20px;
		margin-right: 10px;
		justify-content: space-around;
		text-align: center;
		align-items: center;
	}

	.rljhc-wcl-jm-hm-title {
		font-size: 15px;
		color: #656565;
	}

	.rljhc-wcl-jm-hm-value {
		font-weight: lighter;
		font-size: 18px;
	}

	.rljhc-wcl-hm {
		display: flex;
		padding-top: 15px;
		margin-left: 20px;
		margin-right: 10px;
		justify-content: space-around;
		text-align: center;
		align-items: center;
	}

	.rljhc-wcl-xs {
		padding-top: .5rem;
		padding: 10px 0px
	}

	.rljhc-wcl-xs ul {}

	.rljhc-wcl-xs ul li {
		float: left;
		text-align: center;
		line-height: 1rem;
		font-size: 15px
	}

	.rljhc-wcl-jm-hm-value-cq {
		width: 24%;
		display: flex;
		flex-direction: row;
		text-align: center;
		justify-content: center;
		align-items: center
	}

	.gdmhjcydl-div {
		background: #EEF6FE;
		border-radius: 10px;
		padding: 25px 10px;
		display: flex;
		/*justify-content: space-around;*/
	}

	.gdmhjcydl-gdmh-div {
		display: flex;
		flex-direction: column;
		text-align: center;
		align-items: center;
		width: 50%;
		padding: 0px 20px;
	}

	.gdmhjcydl-ydl-div {
		display: flex;
		flex-direction: column;
		text-align: center;
		align-items: center;
		width: 50%;
		padding: 0px 20px;
	}

	.gdmhjcydl-icon-div {
		display: flex;
		flex-direction: column;
		text-align: center;
		align-items: center;
	}

	.gdmhjcydl-icon {
		width: 30px;
		height: 30px;
	}

	.gdmhjcydl-icon-title-div {
		font-size: 12px;
		font-weight: bold;
		margin-top: 10px;
		color: #5D5D5D;
	}

	.gdmhjcydl-bottom-line-div {
		display: flex;
		width: 100%;
		align-items: center;
		padding-top: 20px;
	}

	.gdmhjcydl-bottom-line-title-div {
		font-size: 12px;
		font-weight: lighter;
		color: #656565;
	}

	.gdmhjcydl-bottom-line-value-div {
		font-size: 18px;
		margin-left: auto;
	}

	.gdmhjcydl-bottom-line-unit-div {
		font-size: 12px;
		transform: scale(0.7);
		margin-left: auto;
		margin-top: 6px;
	}

	.tit {
		margin-top: 1.6em;
		margin-bottom: 0.8em
	}

	.tit h4 {
		font-size: 15px;
		color: #5D5D5D;
		font-weight: 700;
		position: relative;
		padding-left: 12px;
	}

	.tit h4:after {
		content: '';
		position: absolute;
		z-index: 0;
		top: 0px;
		left: 0;
		width: 4px;
		height: 1.1rem;
		border-radius: 3px;
		background: #1E6DE4;
	}

	.con {
		background: #EFF8FF;
		border: 1px solid #e5e6e8;
		padding: .5rem;
		border-radius: 5px;
	}

	.clearfix:after {
		content: ".";
		display: block;
		height: 0;
		clear: both;
		visibility: hidden;
	}

	.clearfix {
		*display: inline-block;
		*zoom: 100%;
		border: none
	}

	.list {}

	.list ul {}

	.list ul li {
		float: left;
		font-size: .8rem;
		color: #696c75
	}

	.xs {
		padding-top: .5rem
	}

	.xs ul {}

	.xs ul li {
		float: left;
		text-align: center;
		width: 33.333%;
		padding: 10px 0px
	}

	.xs ul li h4 {
		font-size: 12px;
		color: #696c75;
		line-height: 1.5rem;
		margin-top: 2px
	}

	.xs ul li p1 {
		font-size: 24px;
		font-weight: 700;
		color: #EA0000;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p2 {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p3 {
		font-size: 24px;
		font-weight: 700;
		color: #129B00;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p4 {
		font-size: 7.54px;
		transform: scale(0.3);
		font-weight: 700;
		color: #696c75;
		font-family: arial;
		margin-bottom: .2rem;
		margin-left: 2px
	}

	.xp {
		padding-top: .5rem
	}

	.xp ul {}

	.xp ul li {
		float: left;
		text-align: center;
		width: 50%;
	}

	.xp ul li h4 {
		font-size: 12px;
		color: #696c75;
		line-height: 1.5rem
	}

	.xp ul li p {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xp ul li p1 {
		font-size: 7.54px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	/*饼状图*/
	.wctype {
		padding-top: 10px
	}

	.wctypep {
		font-size: 20px;
		font-weight: 700;
		color: #000
	}

	.wctypespan {
		font-size: 9px;
		color: #777777;
		margin-left: 9px
	}

	.fdcount {
		width: 100%;
		display: flex;
	}

	.fdcount li {
		width: 33.33%;
		text-align: center
	}

	.fdcount li p {
		font-size: 9px;
		color: #777777
	}

	.fdcount li p span {
		font-size: 20px;
		color: #000000;
		margin-left: 6px;
		font-weight: 700
	}

	.fdlwcqk-cq-active {
		color: #D60000 !important;
	}
</style>
