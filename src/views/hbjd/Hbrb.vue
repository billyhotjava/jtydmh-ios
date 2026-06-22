<template>
	<div style="width: 100%;overflow-x: hidden;">
		<div class="main">
			<div class="tab-content">
				<div class="tit">
					<h4>机组状态</h4>
				</div>
				<div class="con clearfix">
					<div class="xs">
						<ul>
							<li>
								<p2>{{jzzt.ssyx}}</p2>
								<h4>实际运行</h4>
							</li>
							<li>
								<p3>{{jzzt.zs}}</p3>
								<h4>总数</h4>
							</li>
							<li>
								<p4>{{jzzt.tj}}</p4>
								<h4>停机</h4>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>达标排放率</h4>
				</div>
				<div class="con clearfix">
					<div class="xp">
						<ul>
							<li>
								<p>{{dbpfl.zhdb}}</p>
								<h4>综合达标</h4>
							</li>
							<li>
								<p>{{dbpfl.zs}}</p>
								<h4>总数</h4>
							</li>
							<li>
								<p>{{dbpfl.nox}}</p>
								<h4>NOx</h4>
							</li>
							<li>
								<p>{{dbpfl.fc}}</p>
								<h4>粉尘</h4>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>超限时长</h4>
				</div>
				<div class="con clearfix">
					<table class="table-content">
						<tbody>
							<tr>
								<th> </th>
								<th>日累计</th>
								<th>月累计</th>
								<th>年累计</th>
							</tr>
							<tr v-for="(item,i) in hbwrrb">
								<td>{{item.coalName}}</td>
								<td>{{item.rlj}}</td>
								<td>{{item.ylj}}</td>
								<td>{{item.nlj}}</td>
							</tr>
						</tbody>
					</table>
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
		name: "Hbrb",
		comments: {},
		props: {

		},
		data() {
			return {

				//综合指标
				fuelSell: {
					sjyxrl: 0,
					yx: 0,
					clxs: 0
				},
				//机组状态
				jzzt: {
					ssyx: '',
					zs: '',
					tj: ''
				},
				//达标排放率
				dbpfl: {
					zhdb: 0,
					zs: 0,
					nox: 0,
					fc: 0
				},
				//超限时长
				hbwrrb: [],
				AqhbToken: ''

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
					this.getZhzb();
				}, 500);
			},
			//环保污染日报
			getMonthTotal: async function() {
				axios.get(
					`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/Environmentalpollutiondaily`, {
						params: {},
					}).then((res) => {
					if (res.status == 200) {
						var data = res.data;
						var str = data.split(",");
						this.dbpfl = {
							zhdb: parseInt(str[6]) + "%",
							zs: parseInt(str[7]) + "%",
							nox: parseInt(str[8]) + "%",
							fc: parseInt(str[9]) + "%"
						};
						this.hbwrrb = [{
								coalName: '启停机',
								rlj: str[10],
								ylj: str[15],
								nlj: str[20]
							},
							{
								coalName: '设备故障',
								rlj: str[11],
								ylj: str[16],
								nlj: str[21]
							},
							{
								coalName: '运行调整',
								rlj: str[12],
								ylj: str[17],
								nlj: str[22]
							},
							{
								coalName: '定期工作',
								rlj: str[13],
								ylj: str[18],
								nlj: str[23]
							},
							{
								coalName: '合计',
								rlj: str[14],
								ylj: str[19],
								nlj: str[24]
							}
						];
					}
				});

			},
			//综合指标、机组状态
			getZhzb: async function() {
				axios.get(
					`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/Environmentalpollutiondaily`, {
						params: {},
					}).then((res) => {
					if (res.status == 200) {
						var data = res.data.replace(/台/g, "");
						data = data.replace(/MW/g, "");
						data = data.replace(/%/g, "");
						var str = data.split(",");
						this.fuelSell = {
							sjyxrl: str[0],
							yx: str[1],
							clxs: str[2]
						};
						this.jzzt = {
							ssyx: str[3],
							zs: str[4],
							tj: str[5]
						};
					}
				});

			},
			toDecimal(x) {
				var f = parseFloat(x);
				if (isNaN(f)) {
					return;
				}
				f = Math.round(x * 100) / 100;
				return f;
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
		border-bottom: 2px solid #e4e4e4;
		font-size: .8rem;
		color: #696c75;
		text-align: center
	}

	.table-content td {
		padding: .5rem .2rem;
		border-bottom: 1px solid #e4e4e4;
		font-size: .8rem;
		color: #000000;
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
		color: #333333;
		line-height: 1.5rem
	}

	.xs ul li p {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p1 {
		font-size: 7.5px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p2 {
		font-size: 24px;
		font-weight: 700;
		color: #EA0000;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p3 {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p4 {
		font-size: 24px;
		font-weight: 700;
		color: #129B00;
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
		width: 25%
	}

	.xp ul li h4 {
		font-size: 12px;
		color: #333333;
		line-height: 1.5rem
	}

	.xp ul li p {
		font-size: 15px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xp ul li p1 {
		font-size: 7.5px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}


	.t_l {
		text-align: left !important
	}
</style>
