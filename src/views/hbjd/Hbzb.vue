<template>
	<div style="width: 100%;overflow-x: hidden;">
		<div class="main">
			<div class="tab-content">
				<div class="tit">
					<h4>月排放总量</h4>
				</div>
				<div style="text-align:center;height:220px;width:100%" ref="myChartBar"></div>

			</div>
			<div class="tab-content">
				<div class="tit">
					<h4>环保超限情况</h4>
				</div>
				<div class="con clearfix" style="margin-bottom: 10px">
					<table width="100%">
						<tbody>
							<tr>
								<td style="vertical-align: middle; padding-right:10px;color:#ED8686;fontSize:15px;">
									超<br>限
								</td>
								<td>
									<van-grid :column-num="5" :border="false">
										<van-grid-item v-for="(item, i) in cxList" text="item" @click="getCxItem(item)">
											<img width="20px" height="20px" src="../../assets/images/hbzb/cx.png" alt />
											<span
												style="fontSize:10px;margin-top:12px;font-weight:bold">{{item.factoryName}}</span>
										</van-grid-item>
									</van-grid>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<van-divider style="background: #BEBBBB;"></van-divider>
								</td>
							</tr>
							<tr>
								<td style="vertical-align: middle; padding-right:10px;color:#BEBBBB;fontSize:15px;">
									未<br>超<br>限
								</td>
								<td>
									<van-grid :column-num="5" :border="false">
										<van-grid-item v-for="(item, i) in wcxList" text="factoryName">
											<img width="20px" height="20px" src="../../assets/images/hbzb/wcx.png"
												alt />
											<span
												style="fontSize:12px;margin-top:8px;font-weight:bold">{{item.factoryName}}</span>
										</van-grid-item>
									</van-grid>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>排放绩效</h4>
				</div>
				<div style="text-align:center;height:220px;width:100%" ref="myChartLine"></div>
			</div>

		</div>
		<van-popup v-model="isCxShow" closeable close-icon-position="top-right" class="pop">
			<h4>{{cxItem.factoryName}}</h4>
			<div class="pop-list" v-for="cx in cxItemList">
				<div class="pop-div">
					<p class="pop-jz-zb-title">机组</p>
					<span class="pop-jz-zb-value">{{cx.jz}}</span>
				</div>
				<div class="pop-div">
					<p class="pop-jz-zb-title">指标</p>
					<span class="pop-jz-zb-value">{{cx.zb}}</span>
				</div>
				<div class="pop-div">
					<div style="width: 50%;">
						<p class="pop-cx-title">超限值</p>
						<span class="pop-cx-title" style="width: 60%">{{cx.cxz}}</span>
					</div>
					<div style="width: 50%;">
						<p class="pop-cx-title">限值</p>
						<span class="pop-cx-title" style="width: 60%">{{cx.xz}}</span>
					</div>
				</div>

				<div class="pop-div">
					<p class="pop-jz-zb-title" style="width: 30%;">开始时间</p>
					<span class="pop-jz-zb-value" style="width: 70%;">{{cx.kssj}}</span>
				</div>
				<div class="pop-div" style="padding: 15px 0px 15px 15px;">
					<p class="pop-jz-zb-title" style="width: 30%;">结束时间</p>
					<span class="pop-jz-zb-value" style="width: 70%;">{{cx.jssj}}</span>
				</div>
			</div>
		</van-popup>
	</div>
</template>

<script>
	import * as echarts from 'echarts';
	import axios from 'axios';
	import qs from 'qs';

	export default {
		name: "Hbzb",
		comments: {},
		props: {},
		data() {
			return {
				//报警信息
				cxList: [],
				wcxList: [],
				//煤矿标签
				activeName: '',
				coalTabs: [{
						coalId: '1',
						coalName: '环保日报'
					},
					{
						coalId: '2',
						coalName: '环保指标'
					}
				],
				AqhbToken: '',
				isCxShow: false,
				cxItemList: [],
				cxItem: {},
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
				console.log(name);
			},
			getToken: async function() {
				this.getMonthTotal();
				setTimeout(() => {
					this.getHbcxqk();
				}, 500);
				setTimeout(() => {
					this.getPfjx();
				}, 1000);
			},
			//月排放总量获取数据
			getMonthTotal: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/mtotalemissions`, {
					params: {},
				}).then((res) => {
					if (res.status == 200) {
						var category = ['NOx', 'SO', '烟尘'];
						var data = res.data;
						var str = data.split(",");
						var barData = [str[0], str[1], str[2]];
						this.loadClBar(category, barData);
					}
				});

			},
			//环保超限情况
			getHbcxqk: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/limitFactList`, {
					params: {},
				}).then((res) => {
					if (res.status == 200) {
						this.cxList = [];
						this.wcxList = [];
						var datas = eval(res.data);
						for (var i = 0; i < datas.length; i++) {
							if (datas[i].value[3] == 0) {
								this.wcxList.push({
									"factoryName": datas[i].name,
									"factoryCode": datas[i].value[4]
								});
							}
							if (datas[i].value[3] == 1) {
								this.cxList.push({
									"factoryName": datas[i].name,
									"factoryCode": datas[i].value[4]
								});
							}
						}

					}
				});
			},
			getCxItem(item) {
				this.cxItemList = [];
				this.cxItem = item;
				this.$postRequest(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://hbjd.sgeg.chnenergy.com.cn/kpiIndexJController!cxMap.action?pageNum=1&queryBean.factoryId=${item.factoryCode}`
				}).then(res => {
					if (res && res.data) {
						this.isCxShow = true;
						var datas = res.data.split('@');
						if (datas.length > 0) {
							var list = datas[datas.length - 1].split(';');
							if (list.length > 5) {
								var size = Math.floor(list.length / 6);
								for (var i = 0; i < size; i++) {
									this.cxItemList.push({
										'jz': list[i * 6],
										'zb': list[i * 6 + 1],
										'cxz': list[i * 6 + 2],
										'xz': list[i * 6 + 3],
										'kssj': list[i * 6 + 4],
										'jssj': list[i * 6 + 5],
									})
								}
							}
						}
					}
				}).catch((error) => {

				});
			},
			//排放绩效
			getPfjx: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/pfjx`, {
					params: {},
					headers: {
						'Content-Type': 'application/json; charset=utf-8',
						'AqhbToken': this.AqhbToken
					}
				}).then((res) => {
					if (res.status == 200) {
						var datas = res.data.split(";")
						var data = [];
						var sersers = [];
						if (datas.length == 4) {
							var dateAyyay = datas[0];
							var so2Ayyay = datas[1];
							var noxAyyay = datas[2];
							var ycAyyay = datas[3];

							var dates = dateAyyay.split(",");
							for (var i = 0; i < dates.length; i++) {
								data.push(dates[i]);
							}
							var ycs = ycAyyay.split(",");
							var list1 = [];
							for (var i = 0; i < ycs.length; i++) {
								list1.push(ycs[i]);
							}
							var list2 = [];
							var so2s = so2Ayyay.split(",");
							for (var i = 0; i < so2s.length; i++) {
								list2.push(so2s[i]);
							}
							var list3 = [];
							var noxs = noxAyyay.split(",");
							for (var i = 0; i < noxs.length; i++) {
								list3.push(noxs[i]);
							}
							sersers.push({
								name: '烟尘',
								type: 'line',
								data: list1,
								symbol: 'none'
							});
							sersers.push({
								name: 'SO2',
								type: 'line',
								data: list2,
								symbol: 'none'
							});
							sersers.push({
								name: 'NOx',
								type: 'line',
								data: list3,
								symbol: 'none'
							});
						}

						this.loadClLine(data, sersers);
					}
				});

			},
			//月排放总量
			loadClBar(category, barData) {
				let myChartBar = echarts.init(this.$refs.myChartBar);
				myChartBar.clear();
				var options = {
					tooltip: {
						trigger: 'axis',
						axisPointer: {
							type: 'shadow'
						}
					},
					grid: {
						top: '8%',
						left: '3%',
						right: '4%',
						bottom: '8%',
						containLabel: true
					},
					xAxis: {
						type: 'value',
						axisLine: {
							show: false
						},
						axisTick: {
							show: false
						}
					},
					yAxis: {
						type: 'category',
						data: category,
						splitLine: {
							show: false
						},
						axisLine: {
							show: false
						},
						axisTick: {
							show: false
						},
						offset: 10,
						nameTextStyle: {
							fontSize: 15
						}
					},
					series: [{
						name: '数量',
						type: 'bar',
						data: barData,
						barWidth: 14,
						barGap: 10,
						smooth: true,
						label: {
							normal: {
								show: true,
								position: 'right',
								offset: [5, -2],
								textStyle: {
									color: '#F68300',
									fontSize: 13
								}
							}
						},
						itemStyle: {
							emphasis: {
								barBorderRadius: 7
							},
							normal: {
								barBorderRadius: 7

							}
						}
					}]
				};
				myChartBar.setOption(options);
			},
			//排放绩效
			loadClLine(data, series) {
				let myChartLine = echarts.init(this.$refs.myChartLine);
				myChartLine.clear();

				var options = {
					tooltip: {
						trigger: 'axis'
					},
					legend: {
						icon: 'pin',
						data: ['烟尘', 'SO2', 'NOx'],

						right: '4%'
					},
					grid: {
						left: '3%',
						right: '4%',
						bottom: '3%',
						containLabel: true
					},
					xAxis: {
						type: 'category',
						boundaryGap: false,
						data: data
					},
					yAxis: {
						type: 'value'
					},
					series: series
				};
				myChartLine.setOption(options);
			},
		}
	}
</script>
<style>
	.van-grid-item__content {
		background: #EFF8FF !important;
	}
</style>
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
		color: #5c5c5c;
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
		font-size: .8rem;
		color: #696c75;
		line-height: 1.5rem
	}

	.xs ul li p {
		font-size: 1.4rem;
		font-weight: 700;
		color: #696c75;
		font-family: arial;
		margin-bottom: .2rem
	}

	.t_l {
		text-align: left !important
	}

	.van-tabs__nav {
		background-color: #206EEA;
	}

	.van-grid-item__content {
		background: #EFF8FF !important;
	}

	.pop {
		width: 80%;
		height: 70%;
		background: #F1F7FE
	}

	.pop h4 {
		font-size: 16px;
		font-weight: 700;
		text-align: center;
		margin-top: 20px;
		margin-bottom: 20px
	}

	.pop-list {
		width: 90%;
		background: #fff;
		border-radius: 10px;
		position: relative;
		left: 50%;
		transform: translateX(-50%);
		margin-bottom: 20px
	}

	.pop-div {
		width: 100%;
		display: flex;
		padding: 15px 0px 5px 15px;
		align-items: center
	}

	.pop-jz-zb-title {
		width: 20%;
		font-size: 14px;
		color: #000;
	}

	.pop-jz-zb-value {
		width: 80%;
		font-size: 14px;
		color: #000;
	}

	.pop-cx-title {
		width: 40%;
		float: left;
		font-size: 14px;
		color: #000;
	}

	.pop-cx-value {
		width: 60%;
		height: auto;
		vertical-align: middle;
		font-size: 14px;
		color: #000;
	}
</style>
