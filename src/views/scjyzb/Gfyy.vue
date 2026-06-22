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
							<p>{{"10"}}
								<p1>{{"MW"}}</p1>
							</p>
							<h4>装机容量</h4>
						</li>
						<li>
							<p>{{"20"}}
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
							<p>{{fuelSell.clxs}}
								<p1>{{"W/㎡"}}</p1>
							</p>
							<h4>实时辐照度</h4>
						</li>
						<li>
							<p>{{fuelSell.jrljdl}}
								<p1>{{"万千瓦时"}}</p1>
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
							<p1>{{jzzt.yx}}</p1>
							<h4>运行</h4>
						</li>
						<li>
							<p2>{{jzzt.dj}}</p2>
							<h4>待机</h4>
						</li>
						<li>
							<p3>{{jzzt.tj}}</p3>
							<h4>停机</h4>
						</li>
						<li>
							<p4>{{jzzt.zd}}</p4>
							<h4>中断</h4>
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
						<div style="text-align:center;height:180px;width:100%" ref="myChartGfssfhqx"
							id="myChartGfssfhqx"></div>
					</van-col>
				</van-row>
			</div>
		</div>
	</div>
</template>

<script>
	import * as echarts from 'echarts';
	import axios from 'axios';
	import qs from 'qs';
	export default {
		name: "Fdyy",
		data() {
			return {
				//综合指标
				fuelSell: {
					sjyxrl: '',
					sscl: '',
					clxs: '',
					jrljdl: ''
				},

				//机组运行情况
				jzzt: {
					yx: '',
					dj: '',
					tj: '',
					zd: ''
				},
				AqhbToken: '',
			}
		},
		mounted() {
			// let height = document.documentElement.clientHeight;
			// document.getElementById("myChartGfssfhqx").style.height = height - 52 + "px";
			this.getToken();
		},
		methods: {
			getToken: async function() {
				this.getSsyxqk();
				setTimeout(() => {
					this.getJzyxqk();
				}, 500);
				setTimeout(() => {
					this.getSsfhqxt();
				}, 1000);
			},

			getSsyxqk: async function() {
				axios.get(
					`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/RealtimemonitoringLight`, {
						params: {},
					}).then((res) => {
					if (res.code == 0) {
						this.fuelSell.sjyxrl = res.data.ratedPower;
						this.fuelSell.sscl = res.data.realPower;
						this.fuelSell.clxs = res.data.coefficient;
						this.fuelSell.jrljdl = res.data.accrue;
					}
				});
			},

			getJzyxqk: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/OpeMonitoringLight`, {
					params: {},
				}).then((res) => {
					if (res.code == 0) {
						this.jzzt.yx = res.data.yxCount;
						this.jzzt.dj = res.data.djCount;
						this.jzzt.tj = res.data.tjCount;
						this.jzzt.zd = res.data.zdCount;
					}
				});
			},

			getSsfhqxt: async function() {
				let timeData = [];
				let date = new Date();
				let planData = [];
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/runningCurveLight`, {
					params: {},
				}).then((res) => {
					if (res.code == 0) {
						date.setHours(0);
						date.setMinutes(0);
						for (let i = 0; i < 1439; i++) {
							date.setTime(date.getTime() + 1000 * 60);
							// + ':' + (date.getMinutes() > 9 ? date.getMinutes() : '0' + date.getMinutes()) 需要秒时间时加上这句
							timeData.push((date.getHours() > 9 ? date.getHours() : '0' + date.getHours()));
						}
						timeData.push(24);
						this.Gfssfhqx(timeData, res.data);
					}
				});
			},
			//火电负荷曲线
			Gfssfhqx(xAxisData, yAxisData) {
				let myChartLine = echarts.init(this.$refs.myChartGfssfhqx);
				myChartLine.clear();
				var options = {
					// title: {
					//     text: '运行曲线'
					// },
					tooltip: {
						trigger: 'axis'
					},
					legend: {
						data: ['今日', '昨日', '今日辐射', '昨日辐射']
					},
					grid: {
						left: '3%',
						right: '4%',
						bottom: '3%',
						containLabel: true
					},
					// toolbox: {
					//     feature: {
					//         saveAsImage: {}
					//     }
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
						data: xAxisData
					},
					yAxis: [{
							name: 'MW',
							type: 'value',
							scale: true
						},
						{
							name: 'W/m²',
							type: 'value',
							scale: true
						}
					],
					series: [{
							name: '今日',
							type: 'line',
							yAxisIndex: 0,
							showSymbol: false,
							smooth: true,
							data: yAxisData.today
						},
						{
							name: '昨日',
							type: 'line',
							yAxisIndex: 0,
							showSymbol: false,
							smooth: true,
							data: yAxisData.yesterday
						},
						{
							name: '今日辐射',
							type: 'line',
							yAxisIndex: 1,
							showSymbol: false,
							smooth: true,
							data: yAxisData.plan
						},
						{
							name: '昨日辐射',
							type: 'line',
							yAxisIndex: 1,
							showSymbol: false,
							smooth: true,
							data: yAxisData.agc
						}
					]
				};
				myChartLine.setOption(options);
			},
		}
	}
</script>

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
		width: 25%
	}

	.xs ul li h4 {
		font-size: 12px;
		color: #696c75;
		line-height: 1.5rem
	}

	.xs ul li p1 {
		font-size: 24px;
		font-weight: 700;
		color: #129B00;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p2 {
		font-size: 24px;
		font-weight: 700;
		color: #3274EB;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p3 {
		font-size: 24px;
		font-weight: 700;
		color: #EA0000;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p4 {
		font-size: 24px;
		font-weight: 700;
		color: #FE4700;
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
</style>
