<template>
	<div style="width: 100%;overflow-x: hidden;padding-left: 15px;padding-right: 15px;">
		<div class="tab-content">
			<div class="tit">
				<h4>实时运行情况</h4>
			</div>
			<div class="con clearfix">
				<div class="xp">
					<ul>
						<li>
							<p>{{"15074"}}
								<p1>{{"MW"}}</p1>
							</p>
							<h4>装机容量</h4>
						</li>
						<li>
							<p>{{"34"}}
								<p1>{{"台"}}</p1>
							</p>
							<h4>台数</h4>
						</li>
						<li>
							<p>{{fuelSell.sjyxrl}}
								<p1>{{"MW"}}</p1>
							</p>
							<h4>实际运行容量</h4>
						</li>
						<li>
							<p>{{fuelSell.sscl}}
								<p1>{{"MW"}}</p1>
							</p>
							<h4>实时出力</h4>
						</li>
						<li>
							<p>{{toDecimal(fuelSell.clxs)}}
								<p1>{{"%"}}</p1>
							</p>
							<h4>出力系数</h4>
						</li>
						<li>
							<p>{{fuelSell.jrljdl}}
								<p1>{{"亿千瓦时"}}</p1>
							</p>
							<h4>今日累计电量</h4>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="tab-content">
			<div class="tit">
				<h4>停备检修情况</h4>
			</div>
			<div class="con clearfix">
				<div class="xs">
					<ul>
						<li>
							<p1>{{jzzt.ssyx}}</p1>
							<h4>运行</h4>
						</li>
						<li>
							<p2>{{jzzt.zs}}</p2>
							<h4>备用</h4>
						</li>
						<li>
							<p3>{{jzzt.tj}}</p3>
							<h4>检修</h4>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="tab-content">
			<div class="tit">
				<h4>实时负荷曲线</h4>
			</div>
			<div>
				<van-row>
					<van-col span="24">
						<div style="text-align:center;height:220px;width:100%" ref="myChartHdssfhqx"></div>
					</van-col>
				</van-row>
			</div>


			<div class="tab-content">
				<div class="tit">
					<h4>发电量完成情况(亿千瓦时)</h4>
				</div>
				<div class="con clearfix">
					<table class="table-content">
						<tbody>
							<tr>
								<th></th>
								<th>年</th>
								<th>月</th>
								<th>日</th>
							</tr>
							<tr v-for="(item,i) in fdlwcqk">
								<td>{{getColName(item.coalName)}}</td>
								<td style="font-weight:bold;font-size:14px;">{{item.year}}</td>
								<td style="font-weight:bold;font-size:14px;">{{item.month}}</td>
								<td style="font-weight:bold;font-size:14px;">{{item.day}}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>


			<div class="tab-content">
				<div class="tit">
					<h4>燃煤进耗存</h4>
				</div>
				<!-- <div class="con clearfix">
					<div class="xs">
						<ul>
							<li>
								<p2>{{rmjhc.kcrl}}
									<p4>{{"万吨"}}</p4>
								</p2>
								<h4>库存容量</h4>
							</li>
							<li>
								<p2>{{rmjhc.yckc}}
									<p4>{{"天"}}</p4>
								</p2>
								<h4>警戒天数</h4>
							</li>
							<li>
								<p2>{{rmjhc.dqkc}}
									<p4>{{"万吨"}}</p4>
								</p2>
								<h4>月初库存</h4>
							</li>
							<li>
								<p2>{{rmjhc.jjts}}
									<p4>{{"天"}}</p4>
								</p2>
								<h4>可用天数</h4>
							</li>
							<li>
								<p2>{{rmjhc.kyts}}
									<p4>{{"天"}}</p4>
								</p2>
								<h4>当前库存</h4>
							</li>
							<li>
								<p2>{{rmjhc.pjrh}}
									<p4>{{"万吨"}}</p4>
								</p2>
								<h4>近3日平均日耗</h4>
							</li>
						</ul>
					</div>
				</div> -->
			</div>


			<div class="tab-content">
				<div class="clearfix">
					<table style="width:100%">
						<tr>
							<th>
								<van-tabs v-model="activeName" @click="tabsClick" class="chcolor">
									<van-tab v-for="item in coalTabs" :title="item.coalName" :name="item.coalId">
									</van-tab>
								</van-tabs>
							</th>
							<th style="text-align:right;"><span style="margin-right:10px;font-size:8px;">(单位:万吨)</span>
							</th>
						</tr>
					</table>

					<table class="cxlsj-wrap" style="margin-top: 10px;">
						<!-- <tbody>
							<tr>
								<th></th>
								<th>计划</th>
								<th>完成</th>
								<th>超欠</th>
							</tr>
							<tr v-for="(item,i) in rmjhcym">
								<td>{{item.coalName}}</td>
								<td style="font-weight:bold;font-size:14px;">{{item.plan}}</td>
								<td style="font-weight:bold;font-size:14px;">{{item.over}}</td>
								<td><span style="color:red;font-weight:bold;font-size:14px;"
										v-if="item.cq < 0">{{item.cq}}</span><span
										style="color:green;font-weight:bold;font-size:14px;"
										v-if="item.cq >= 0">{{item.cq}}</span></td>
							</tr>
						</tbody> -->
						<tr style="background: #F5F5F5;">
							<td colspan="3"><strong>进煤（万吨）</strong></td>
							<td style="background: white; width:3%; border:0px;"></td>
							<td><strong>煤炭库存</strong></td>
						</tr>
						<tr>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>日累计</h4>
									<p><span>{{currentMk.jmDay}}</span></p>
								</div>
							</td>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>月累计</h4>
									<p><span>{{currentMk.jmMonth}}</span></p>
								</div>
							</td>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>年累计</h4>
									<p><span>{{currentMk.jmYear}}</span></p>
								</div>
							</td>
							<td style="background: white; width:3%; border:0px;"></td>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>煤量（万吨）</h4>
									<p><span>{{currentMk.kcm}}</span></p>
								</div>
							</td>
						</tr>
						<tr style="background: #F5F5F5;text-align: center;">
							<td colspan="3"><strong>耗煤（万吨）</strong></td>
							<td style="background: white; width:3%; border:0px;"></td>
							<td style="background: white; width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>环比（万吨）</h4>
									<p><span>{{currentMk.tb}}</span></p>
								</div>
							</td>
						</tr>
						<tr>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>日累计</h4>
									<p><span>{{currentMk.hmDay}}</span></p>
								</div>
							</td>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>月累计</h4>
									<p><span>{{currentMk.hmMonth}}</span></p>
								</div>
							</td>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>年累计</h4>
									<p><span>{{currentMk.hmYear}}</span></p>
								</div>
							</td>
							<td style="background: white; width:3%; border:0px;"></td>
							<td style="width:24%;border: #eee 1px solid">
								<div class="jhc">
									<h4>可用天数</h4>
									<p><span>{{currentMk.availableDay}}</span></p>
								</div>
							</td>
						</tr>
					</table>

				</div>
			</div>


			<div class="tab-content">
				<div class="tit">
					<h4>供电煤耗(g/kW.h)</h4>
				</div>
				<div>
					<van-row>
						<van-col span="24">
							<div style="text-align:center;height:180px;width:100%" ref="myChartGdmh"></div>
						</van-col>
					</van-row>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import * as echarts from 'echarts';
	import axios from 'axios';
	import qs from 'qs';
	export default {
		name: "Hdyy",
		comments: {},
		props: {

		},
		data() {
			return {
				//实时运行情况
				fuelSell: {
					sjyxrl: '',
					sscl: '',
					clxs: '',
					jrljdl: ''
				},
				//机组运行情况
				jzzt: {
					ssyx: '',
					zs: '',
					tj: ''
				},
				//发电量完成情况
				fdlwcqk: [],
				//燃煤进耗存
				rmjhc: {
					kcrl: 0,
					yckc: 0,
					dqkc: 0,
					jjts: 0,
					kyts: 0,
					pjrh: 0
				},
				rmjhcym: [],
				//煤矿标签
				activeName: '',
				coalTabs: [{
						coalId: 'GSJT',
						coalName: '公司合计'
					},
					{
						coalId: 'MDYT',
						coalName: '自产煤'
					},
					{
						coalId: 'FMDYT',
						coalName: '外购煤'
					}
				],
				mkinoutData: [],
				currentMk: {}
			}
		},
		created() {

		},
		mounted() {
			var that = this;
			that.getToken();
		},
		methods: {

			tabsClick(name, title) {
				// console.log('点击了：' + name);
				// this.getRljxc(name);
				if (name == 'GSJT') {
					this.currentMk = this.mkinoutData[0];
				} else if (name == 'MDYT') {
					this.currentMk = this.mkinoutData[1];
				} else if (name == 'FMDYT') {
					this.currentMk = this.mkinoutData[2];
				}
			},
			getToken: async function() {
				this.getSsyxqk();
				setTimeout(() => {
					this.getJzyxqk();
				}, 500);
				setTimeout(() => {
					this.getSsfhqx();
				}, 1000);
				setTimeout(() => {
					this.getFdlwcqk();
				}, 1500);
				setTimeout(() => {
					// this.getRljxc('month');
					this.getRmjhc();
				}, 2000);
				setTimeout(() => {
					this.getGdmh();
				}, 2500);
			},
			//实时运行情况
			getSsyxqk: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/RealtimemonitoringFire`, {
					params: {},
				}).then((res) => {
					if (res.success == true) {
						var data = res.data;
						this.fuelSell = {
							sjyxrl: data.ratedPower,
							sscl: data.realPower,
							clxs: data.coefficient * 100,
							jrljdl: data.accrue
						};

					}
				});

			},
			//机组运行情况
			getJzyxqk: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/OpeMonitoringFire`, {
					params: {},
				}).then((res) => {
					if (res.success == true) {
						var data = res.data;
						this.jzzt = {
							ssyx: data.yxCount + 2,
							zs: data.byCount,
							tj: data.jxCount
						};

					}
				});

			},
			//实时符合曲线
			getSsfhqx: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/runningCurveFire`, {
					params: {},
				}).then((res) => {
					if (res.success == true) {

						// console.log(res);
						var series = [{
								name: '今日',
								type: 'line',
								showSymbol: false,
								smooth: true,
								data: res.data.today
							},
							{
								name: '昨日',
								type: 'line',
								showSymbol: false,
								smooth: true,
								data: res.data.yesterday
							},
							{
								name: 'AGC',
								type: 'line',
								showSymbol: false,
								smooth: true,
								data: res.data.agc
							}
						]
						let timeData = [];
						let date = new Date();
						date.setHours(0);
						date.setMinutes(0);
						for (let i = 0; i < 1439; i++) {
							date.setTime(date.getTime() + 1000 * 60);
							// + ':' + (date.getMinutes() > 9 ? date.getMinutes() : '0' + date.getMinutes()) 需要秒时间时加上这句
							timeData.push((date.getHours() > 9 ? date.getHours() : '0' + date.getHours()));
						}
						timeData.push(24);

						this.loadClLine(timeData, series);
					}
				});

			},

			//实时符合曲线
			loadClLine(timeData, series) {
				let myChartLine = echarts.init(this.$refs.myChartHdssfhqx);
				myChartLine.clear();
				var options = {
					title: {
						//text: '火电负荷曲线'
					},
					tooltip: {
						trigger: 'axis',
					},
					legend: {
						data: ['今日', '昨日', 'AGC']
					},
					grid: {
						left: '3%',
						right: '4%',
						bottom: '3%',
						containLabel: true
					},
					// toolbox: {

					// },
					xAxis: {
						type: "category",
						boundaryGap: false,
						axisLabel: {
							interval: 240,
							show: true,
							textStyle: {
								// color: "#a9a9a9", //更改坐标轴文字颜色
								fontSize: 10 //更改坐标轴文字大小
							},
							// rotate: 40, 文字倾斜使用此属性
							showMinLabel: true, //显示最小值
							showMaxLabel: true, //显示最大值
						},
						data: timeData
					},
					yAxis: {
						name: 'MW',
						type: 'value',
						scale: true
					},

					series: series
				};
				myChartLine.setOption(options);
			},
			//发电量完成情况
			getFdlwcqk: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/powerGeneration`, {
					params: {},
				}).then((res) => {
					if (res.success == true) {
						var data = res.data;
						console.log(data);
						this.fdlwcqk = [{
								coalName: '计划',
								year: data.yPlan,
								month: data.mPlan,
								day: data.dPlan
							},
							{
								coalName: '完成',
								year: data.yOver,
								month: data.mOver,
								day: data.dOver
							},
							{
								coalName: '超欠',
								year: data.yCom,
								month: data.mCom,
								day: data.dCom
							}
						];
					}
				});

			},
			//燃料进销存
			getRljxc: async function(type) {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/GsjsRmjhcMonth`, {
					params: {},
				}).then((res) => {
					if (res.success == true) {
						var list = res.data.stockList[0];
						var capacity = Math.round(list.capacity * 10) / 10;
						var alertDays = Math.round(list.alertDays * 10) / 10;
						var stockM = Math.round(list.stockM * 10) / 10;
						var availableDays = Math.round(list.availableDays * 10) / 10;
						var stockC = Math.round(list.stockC * 10) / 10;
						var consume = Math.round(list.consume * 10) / 10;
						this.rmjhc = {
							kcrl: capacity,
							yckc: alertDays,
							dqkc: stockM,
							jjts: availableDays,
							kyts: stockC,
							pjrh: consume
						};

						if (type == 'month') {
							this.rmjhcym = [];
							var comList = list.comList;
							for (var i = 0; i < comList.length; i++) {
								var com = comList[i];
								var plan = Math.round(com.plan * 10) / 10;
								var completion = Math.round(com.completion * 10) / 10;
								var overDeficit = Math.round(com.overDeficit * 10) / 10;
								if (com.type == "进煤") {
									this.rmjhcym.push({
										coalName: '进煤',
										plan: plan,
										over: completion,
										cq: overDeficit
									});
								}
								if (com.type == "耗煤") {
									this.rmjhcym.push({
										coalName: '耗煤',
										plan: plan,
										over: completion,
										cq: overDeficit
									});
								}
							}
						} else {
							axios.get(
								`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/GsjsRmjhcYear`, {
									params: {},
								}).then((res1) => {
								if (res1.success == true) {
									var list1 = res1.data.stockList[0];
									this.rmjhcym = [];
									var comList = list1.comList;
									for (var i = 0; i < comList.length; i++) {
										var com = comList[i];
										var plan = Math.round(com.plan * 10) / 10;
										var completion = Math.round(com.completion * 10) / 10;
										var overDeficit = Math.round(com.overDeficit * 10) / 10;
										if (com.type == "进煤") {
											this.rmjhcym.push({
												coalName: '进煤',
												plan: plan,
												over: completion,
												cq: overDeficit
											});
										}
										if (com.type == "耗煤") {
											this.rmjhcym.push({
												coalName: '耗煤',
												plan: plan,
												over: completion,
												cq: overDeficit
											});
										}
									}

								}
							});

						}

					}
				});


			},
			//燃料进耗存
			getRmjhc: async function(type) {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqhb/AqhbRmjhc`, {
					params: {},
				}).then((res) => {
					if (res.success == true) {
						this.mkinoutData = res.list;
						this.currentMk = res.list[0];
					}
				});
			},
			//供电煤耗获取数据
			getGdmh: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqhb/AqhbGdmh`, {
					params: {},
				}).then((res) => {
					if (res.success == true) {
						let list = res.list;
						var planList = [];
						var compList = [];
						var dataList = [];
						if (list.length > 0) {
							for (let i = 0; i < list.length; i++) {
								let dc = list[i].factoryName;
								let plan = list[i].planValue;
								let comp = list[i].compValue;
								if (plan == undefined) plan = "0";
								if (comp == undefined) comp = "0";
								dataList.push(dc);
								planList.push(plan);
								compList.push(comp);
							}
						}

						var series = [{
								name: '计划',
								type: 'bar',
								data: planList
							},
							{
								name: '完成',
								type: 'bar',
								data: compList
							}
						];
						this.loadClBar(dataList, series);
					}
				});

			},

			//供电煤耗
			loadClBar(data, series) {
				let myChartLine = echarts.init(this.$refs.myChartGdmh);
				myChartLine.clear();
				var options = {
					title: {
						//subtext: '火电年累计供电煤耗'
					},
					tooltip: {
						trigger: 'axis'
					},
					grid: {
						left: '3%',
						right: '4%',
						bottom: '3%',
						top: '15%',
						containLabel: true
					},
					xAxis: [{
						type: 'category',
						axisLabel: {
							interval: 0,
							rotate: 50, //倾斜度
						},
						data: data
					}],
					yAxis: [{
						type: 'value'
					}],
					series: series
				};
				myChartLine.setOption(options);
			},
			toDecimal(x) {
				var f = parseFloat(x);
				if (isNaN(f)) {
					return;
				}
				f = Math.round(x * 100) / 100;
				return f;
			},
			getColName(name) {
				if (name == '完成') {
					return '超欠';
				} else if (name == '超欠') {
					return '完成';
				} else {
					return name;
				}
			}
		}
	}
</script>
<!--<style>-->
<!--.van-tabs__nav{background: #EFF8FF;}-->
<!--</style>-->
<style scoped lang="scss">
	* {
		margin: 0;
		padding: 0;
		border: 0;
		list-style: none;
		text-decoration: none;
		color: inherit;
		font-weight: normal;
		font-family: "微软雅黑";
		box-sizing: border-box;
		font-style: normal;
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
	}

	.clear {
		clear: both;
		height: 0px;
		font-size: 0px;
		line-height: 0px;
		overflow: hidden;
	}

	.tbox {
		background: #226ee8;
		padding: 2rem 0 0;
	}

	.tbox ul {}

	.tbox ul li {
		width: 25%;
		float: left;
		text-align: center;
		margin-bottom: 2rem
	}

	.tbox ul li p {
		font-size: 1.8rem;
		font-weight: 700;
		color: #fff;
		font-family: arial;
		margin-bottom: .2rem
	}

	.tbox ul li h4 {
		font-size: .8rem;
		color: #fff;
		line-height: 1.5rem
	}

	.red0 {
		color: #FF7D83 !important
	}

	.red {
		color: #EC070A !important
	}

	.orange {
		color: #F3A527 !important
	}

	.yellow {
		color: #F7DA45 !important
	}

	.blank10 {
		clear: both;
		display: block;
		overflow: hidden;
		height: .5rem;
		line-height: .5rem;
		font-size: 0px;
	}

	.main {
		padding: 1rem;
		padding-top: 0px;
	}

	.tab-content {
		overflow-y: hidden;
	}

	.bold {
		font-weight: 700 !important
	}

	.tit {
		margin: .8rem 0
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

	.list {}

	.list ul {}

	.list ul li {
		float: left;
		font-size: .8rem;
		color: #696c75
	}

	.table-content {
		empty-cells: show;
		border-collapse: collapse;
		border-spacing: 0;
		width: 100%
	}

	table {
		empty-cells: show;
		border-collapse: collapse;
		border-spacing: 0;
	}

	.table-content th {
		padding: .5rem .2rem;
		border-bottom: 2px solid #c4def9;
		font-size: .8rem;
		color: #696c75;
		text-align: center
	}

	.table-content td {
		padding: .5rem .2rem;
		border-bottom: 1px solid #e4e4e4;
		font-size: .8rem;
		color: #696c75;
		text-align: center
	}


	.xs {
		padding-top: .5rem
	}

	.xs ul {}

	.xs ul li {
		float: left;
		text-align: center;
		width: 33.333%
	}

	.xs ul li h4 {
		font-size: 12px;
		color: #696c75;
		line-height: 1.5rem
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
		font-weight: 700;
		color: #696c75;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xp {
		padding-top: .5rem
	}

	.xp ul {}

	.xp ul li {
		float: left;
		text-align: center;
		width: 50%
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


	.t_l {
		text-align: left !important
	}

	// ::v-deep .van-tabs .van-tabs__nav {
	// 	background: #EFF8FF;
	// }

	.jhc h4 {
		font-size: 12px;
		color: #000;
		line-height: 20px;
	}

	.jhc p {
		color: #3aa1fe;
		font-size: 15px;
		line-height: 20px;
	}

	.cxlsj-wrap {
		empty-cells: show;
		border-collapse: collapse;
		border-spacing: 0;
		width: 100%
	}

	.cxlsj-wrap td {
		padding: 3px 5px;
		border: #eee 1px solid;
		font-size: 14px;
		height: 35px;
		line-height: 40px;
		color: #000;
		text-align: center;
	}
</style>
