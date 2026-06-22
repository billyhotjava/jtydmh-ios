<template>
	<div style="width: 100%;overflow-x: hidden;">
		<div class="main">
			<div class="tab-content">
				<div class="tit">
					<h4>作业违章情况</h4><span>(近三个月)</span>
				</div>
				<div style="text-align:center;height:220px;width:100%" ref="zyChart" id="myChart" />
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>违章趋势分析</h4><span>(近一年)</span>
				</div>
				<div style="text-align:center;height:220px;width:100%" ref="wzChart"></div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>整改完成率</h4>
				</div>
				<div style="text-align:center;height:220px;width:100%" ref="zgChart"></div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>外委人员变动率</h4>
					<div style="text-align:center">
						<button id="cqChart" @click="getCqWwry()">长期</button>
						<button id="dqChart" @click="getDqWwry()">短期</button>
					</div>
				</div>

				<div>
					<div style="text-align:center;height:220px;width:100%" ref="wwChart"></div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>自我管理力度分析</h4><span>(近三个月)</span>
				</div>
				<div style="text-align:center;height:220px;width:100%" ref="zwglChart"></div>
			</div>
		</div>
	</div>
</template>

<script>
	import * as echarts from 'echarts';
	import axios from 'axios';
	import qs from 'qs';
	export default {
		name: "Aqfx",
		data() {
			return {
				wwryType: 'cq',
				AqhbToken: '',
			}
		},
		mounted() {
			// let height = document.documentElement.clientHeight;
			// document.getElementById("myChart").style.height=height-52+"px";
			this.getToken();
		},
		methods: {
			getToken: async function() {
				this.getZywz();
				setTimeout(() => {
					this.getWzqs();
				}, 500);
				setTimeout(() => {
					this.getZgwc();
				}, 1000);
				setTimeout(() => {
					this.getCqWwry();
				}, 1500);
				setTimeout(() => {
					this.getZwgl();
				}, 2000);
			},
			//作业违章情况
			getZywz: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqjf/AqjfXwwzslfx`, {
					params: {},
				}).then((res) => {
					if (res.data.code == 200) {
						var category = [];
						var barData = [];
						for (var item of res.data.data) {
							category.push(item.电厂名称);
							barData.push(item.违章次数);
						}
						this.loadZywz(category, barData);
					}
				});
			},
			//违章趋势分析
			getWzqs: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqjf/AqjfXwwzqsfx`, {
					params: {},
				}).then((res) => {
					if (res.data.code == 200) {
						var category = [];
						var barData = [];
						for (var item1 of res.data.data.columns) {
							category.push(item1);
						}
						for (var item2 of res.data.data.rows) {
							barData.push(item2);
						}
						this.loadWzqs(category, barData);
					}
				});
			},
			//整改完成率
			getZgwc: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqjf/AqjfZzlwtZgwcqkfx`, {
					params: {},
				}).then((res) => {
					if (res.data.code == 200) {
						var category = [];
						var barData = [];
						for (var item of res.data.data) {
							category.push(item.单位名称);
							barData.push(item.整改完成率);
						}
						this.loadZgwc(category, barData);
					}
				});
			},
			//外委人员变动率(长期)
			getCqWwry: async function() {
				document.getElementById("cqChart").style.borderBottom = '2px solid #216DEA';
				document.getElementById("dqChart").style.borderBottom = '2px solid #fff';
				document.getElementById("cqChart").style.color = '#216DEA';
				document.getElementById("dqChart").style.color = '#7E7E7E';
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqjf/AqjfCqcbsRybdqsfx`, {
					params: {},
				}).then((res) => {
					if (res.data.code == 200) {
						var category = [];
						var barData = [];
						for (var item of res.data.data) {
							category.push(item.单位名称);
							barData.push(item.离厂率);
						}
						this.loadWwry(category, barData);
					}
				});
			},
			//外委人员变动率(短期)
			getDqWwry: async function() {
				document.getElementById("cqChart").style.borderBottom = '2px solid #fff';
				document.getElementById("dqChart").style.borderBottom = '2px solid #216DEA';
				document.getElementById("cqChart").style.color = '#7E7E7E';
				document.getElementById("dqChart").style.color = '#216DEA';
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqjf/AqjfDqcbsRybdqsfx`, {
					params: {},
				}).then((res) => {
					if (res.data.code == 200) {
						var category = [];
						var barData = [];
						for (var item of res.data.data) {
							category.push(item.单位名称);
							barData.push(item.离厂率);
						}
						this.loadWwry(category, barData);
					}
				});
			},
			//自我管理力度分析
			getZwgl: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/aqjf/AqjfXwwzzcldfx`, {
					params: {},
				}).then((res) => {
					if (res.data.code == 200) {
						var category = [];
						var barData = [];
						for (var item of res.data.data) {
							category.push(item.单位名称);
							barData.push(item.单位自查数量);
						}
						this.loadZwgl(category, barData);
					}
				});
			},
			//作业违章情况
			loadZywz(category, barData) {
				let zyChart = echarts.init(this.$refs.zyChart);
				zyChart.clear();
				var category = category;
				var barData = barData;
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
						type: 'category',
						data: category,
						splitLine: {
							show: false
						},
						axisLine: {
							show: true
						},
						axisTick: {
							show: false
						},
						axisLabel: {
							interval: 0,
							rotate: 50, //倾斜度
						},
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: [{
						name: '数量',
						type: 'bar',
						data: barData,
						barWidth: 14,
						barGap: 10,
						smooth: true,
						itemStyle: {
							normal: {
								color: '#FFAE00',
								barBorderRadius: [15, 15, 0, 0]
							}
						}
					}]
				};
				zyChart.setOption(options);
			},
			//违章趋势分析
			loadWzqs(category, barData) {
				let wzChart = echarts.init(this.$refs.wzChart);
				wzChart.clear();
				var category = category;
				var barData = barData;
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
						type: 'category',
						data: category,
						boundaryGap: false,
						splitLine: {
							show: false
						},
						axisLine: {
							show: true
						},
						axisTick: {
							show: false
						},
						axisLabel: {
							interval: 0,
							rotate: 50, //倾斜度
						},
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: [{
						data: barData,
						type: 'line',
						smooth: true,
						areaStyle: {}
					}]
				};
				wzChart.setOption(options);
			},
			//整改完成率
			loadZgwc(category, barData) {
				let zgChart = echarts.init(this.$refs.zgChart);
				zgChart.clear();
				var category = category;
				var barData = barData;
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
						type: 'category',
						data: category,
						splitLine: {
							show: false
						},
						axisLine: {
							show: true
						},
						axisTick: {
							show: false
						},
						axisLabel: {
							interval: 0,
							rotate: 50, //倾斜度
						},
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: [{
						name: '数量',
						type: 'bar',
						data: barData,
						barWidth: 14,
						barGap: 10,
						smooth: true,
						itemStyle: {
							normal: {
								color: '#29DB00',
								barBorderRadius: [15, 15, 0, 0]
							}
						}
					}]
				};
				zgChart.setOption(options);
			},
			//外委人员变动率
			loadWwry(category, barData) {
				let wwChart = echarts.init(this.$refs.wwChart);
				wwChart.clear();
				var category = category;
				var barData = barData;
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
						type: 'category',
						data: category,
						splitLine: {
							show: false
						},
						axisLine: {
							show: true
						},
						axisTick: {
							show: false
						},
						axisLabel: {
							interval: 0,
							rotate: 50, //倾斜度
						},
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: [{
						name: '数量',
						type: 'bar',
						data: barData,
						barWidth: 14,
						barGap: 10,
						smooth: true,
						itemStyle: {
							normal: {
								color: '#3179EE',
								barBorderRadius: [15, 15, 0, 0]
							}
						}
					}]
				};
				wwChart.setOption(options);
			},
			//自我管理力度分析
			loadZwgl(category, barData) {
				let zwglChart = echarts.init(this.$refs.zwglChart);
				zwglChart.clear();
				var category = category;
				var barData = barData;
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
						type: 'category',
						data: category,
						splitLine: {
							show: false
						},
						axisLine: {
							show: true
						},
						axisTick: {
							show: false
						},
						axisLabel: {
							interval: 0,
							rotate: 50, //倾斜度
						},
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: [{
						name: '数量',
						type: 'bar',
						data: barData,
						barWidth: 14,
						barGap: 10,
						smooth: true,
						itemStyle: {
							normal: {
								color: '#EE6B31',
								barBorderRadius: [15, 15, 0, 0]
							}
						}
					}]
				};
				zwglChart.setOption(options);
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

	.main {
		padding: 1rem;
		padding-top: 0px;
	}

	.tab-content {
		overflow-y: hidden;
	}

	.tit {
		margin: .8rem 0;
	}

	.tit h4 {
		font-size: 15px;
		color: #5D5D5D;
		font-weight: 700;
		position: relative;
		padding-left: 12px;
		display: inline;
	}

	.tit h4:after {
		content: '';
		position: absolute;
		z-index: 0;
		top: 50%;
		transform: translateY(-50%);
		left: 0;
		width: 4px;
		height: 1.1rem;
		border-radius: 3px;
		background: #1E6DE4;
		display: inline;
	}

	.tit span {
		font-size: 14px;
		color: #5D5D5D;
		font-weight: 700;
		position: relative;
		padding-left: 12px;
	}

	.tit button {
		margin: 20px;
		font-size: 15px;
		background: white;
		padding-bottom: 10px;
		font-weight: 700
	}

	.con {
		background: #EFF8FF;
		border: 1px solid #e5e6e8;
		padding: .5rem;
		border-radius: 5px;
	}

	.table-content {
		empty-cells: show;
		border-collapse: collapse;
		border-spacing: 0;
		width: 100%;
	}
</style>
