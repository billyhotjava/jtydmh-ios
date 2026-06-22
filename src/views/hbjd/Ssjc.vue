<template>
	<div style="width: 100%;overflow-x: hidden;">
		<van-dropdown-menu>
			<van-dropdown-item v-model="type" :options="option1" @change="typeChange" />
			<van-dropdown-item v-model="dcId" :options="option2" @change="dcChange" />
		</van-dropdown-menu>
		<div class="main">
			<div style="text-align:center;margin-top: 20px;font-weight:bold">{{Ssdata.dcName}}</div>
			<van-tabs v-model="sellId" style="margin-top: 10px; margin-bottom: 20px" @click="tabsClick">
				<van-tab v-for="item in coalTabs" :title="item.coalName" :name="item.coalId"></van-tab>
			</van-tabs>
			<div class="tab-content">
				<div class="con clearfix">
					<div class="xs">
						<ul>
							<li>
								<h4>{{Ssdata.edrl}}</h4>
								<p5>额定容量<p6>{{"(MW)"}}</p6>
								</p5>
							</li>
							<li>
								<h4>{{Ssdata.dqcl}}</h4>
								<p5>当前出力<p6>{{"(MW)"}}</p6>
								</p5>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>排放指标<p6>(mg/m³)</p6>
					</h4>
				</div>
				<div class="con clearfix">
					<p5 style="margin-left:30px;">排放标准</p5>
					<p5 style="margin-left:150px;">{{Ssdata.pfbz}}</p5>
					<div class="xt" style="margin-top:20px;">
						<ul>
							<li>
								<h4>{{Ssdata.yc}}</h4>
								<p1>烟尘</p1>
							</li>
							<li>
								<h4>{{Ssdata.so2}}</h4>
								<p1>SO₂</p1>
							</li>
							<li>
								<h4>{{Ssdata.nox}}</h4>
								<p1>NOx</p1>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>净烟气指标</h4>
				</div>
				<div class="con clearfix">
					<div class="xs">
						<ul>
							<li>
								<h4>{{Ssdata.yl}}</h4>
								<p5>氧量<p6>(%)</p6>
								</p5>
							</li>
							<li>
								<h4>{{Ssdata.yqll}}</h4>
								<p5>烟气流量<p6>(Nm³/h)</p6>
								</p5>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>氮逃逸</h4>
				</div>
				<div class="con clearfix">
					<div class="xs">
						<ul>
							<li>
								<h4>{{Ssdata.ttya}}</h4>
								<p5>A侧<p6>(ppm)</p6>
								</p5>
							</li>
							<li>
								<h4>{{Ssdata.ttyb}}</h4>
								<p5>B侧<p6>(ppm)</p6>
								</p5>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>原烟气SO₂</h4>
				</div>
				<div class="con clearfix">
					<div class="xd">
						<ul>
							<li>
								<h4>{{Ssdata.yyq}}</h4>
								<p6>(ppm)</p6>
							</li>
						</ul>
					</div>
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
		name: "Ssjc",
		comments: {},
		props: {

		},
		data() {
			return {
				type: 0,
				dcId: '',
				sellId: '1',
				option1: [{
						text: '实时',
						value: 0
					},
					{
						text: '小时',
						value: 1
					},
				],
				option2: [{
						text: '河曲电厂',
						value: 'HQDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}, {
							coalId: '3',
							coalName: '#3机组'
						}, {
							coalId: '4',
							coalName: '#4机组'
						}]
					},
					{
						text: '花园电厂',
						value: 'HMDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}, {
							coalId: '3',
							coalName: '#3机组'
						}, {
							coalId: '4',
							coalName: '#4机组'
						}]
					},
					{
						text: '大南湖电厂',
						value: 'DNHDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '和丰电厂',
						value: 'HFDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '鄂温克电厂',
						value: 'EWKDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '府谷电厂',
						value: 'FGDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '店塔B电厂',
						value: 'DTXC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '店塔电厂',
						value: 'DT135DC',
						sell: [{
							coalId: '3',
							coalName: '#3机组'
						}, {
							coalId: '4',
							coalName: '#4机组'
						}]
					},
					{
						text: '白马电厂',
						value: 'BMDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '郭家湾电厂',
						value: 'GJWDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '亿利电厂',
						value: 'YLDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}, {
							coalId: '3',
							coalName: '#3机组'
						}, {
							coalId: '4',
							coalName: '#4机组'
						}]
					},
					{
						text: '大柳塔电厂',
						value: 'DLTDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}]
					},
					{
						text: '宝清电厂',
						value: 'BQDC',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}, {
							coalId: '2',
							coalName: '#2机组'
						}]
					},
					{
						text: '乌中旗热力厂',
						value: 'WZQ',
						sell: [{
							coalId: '1',
							coalName: '#1机组'
						}]
					}
				],
				coalTabs: [{
						coalId: '1',
						coalName: '#1机组'
					},
					{
						coalId: '2',
						coalName: '#2机组'
					},
					{
						coalId: '3',
						coalName: '#3机组'
					},
					{
						coalId: '4',
						coalName: '#4机组'
					}
				],
				list: [],
				listA: [],
				listB: [],
				//实时数据
				Ssdata: {
					dcId: '',
					dcName: '',
					sellId: '',
					sellName: '',
					edrl: '',
					dqcl: '',
					pfbz: '',
					yc: '',
					so2: '',
					nox: '',
					yl: '',
					yqll: '',
					ttya: '',
					ttyb: '',
					yyq: ''
				},

			}
		},
		created() {

		},
		mounted() {
			var that = this;
			that.getSsData();
			setTimeout(() => {
				that.getXsData();
			}, 500);
		},
		methods: {
			typeChange(value) {
				this.list = [];
				if (value == "0") {
					this.list = this.listA;
				} else {
					this.list = this.listB;
				}
				this.selChange(this.dcId, this.sellId);
			},
			dcChange(id) {
				if (id == 'DT135DC') {
					this.sellId = 3;
				}else{
					this.sellId = 1;
				}
				this.selChange(id, this.sellId);
				for (var i = 0; i < this.option2.length; i++) {
					if (this.option2[i].value == id) {
						this.coalTabs = [];
						this.coalTabs = this.option2[i].sell;
						break;
					}

				}

			},
			tabsClick(name, title) {
				this.selChange(this.dcId, name);
			},
			selChange(dcid, sellid) {
				for (var i = 0; i < this.list.length; i++) {
					if (this.list[i].dcId == dcid && this.list[i].sellId == sellid) {
						this.Ssdata = null;
						this.Ssdata = this.list[i];
						this.dcId = dcid;
						this.sellid = sellid;
						break;
					}

				}
			},
			//实时监测数据
			getSsData: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/Realtimemon`, {
					params: {},
				}).then((res) => {
					if (res.status == 200) {
						var data = res.data;
						var num = 0;
						for (var i = 0; i < this.option2.length; i++) {
							for (var j = 0; j < this.option2[i].sell.length; j++) {
								var sell = this.option2[i].sell[j];
								var map = {
									dcId: this.option2[i].value,
									dcName: this.option2[i].text,
									sellId: sell.coalId,
									sellName: sell.coalName,
									edrl: '',
									dqcl: '',
									pfbz: '',
									yc: '',
									so2: '',
									nox: '',
									yl: '',
									yqll: '',
									ttya: '',
									ttyb: '',
									yyq: ''
								};
								map.edrl = data[num * 11].v;
								map.dqcl = data[num * 11 + 1].v;
								map.pfbz = data[num * 11 + 2].v;
								map.yc = data[num * 11 + 3].v;
								map.so2 = data[num * 11 + 4].v;
								map.nox = data[num * 11 + 5].v;
								map.yl = data[num * 11 + 6].v;
								map.yqll = data[num * 11 + 7].v;
								map.ttya = data[num * 11 + 8].v;
								map.ttyb = data[num * 11 + 9].v;
								map.yyq = data[num * 11 + 10].v;
								this.listA.push(map);
								num++;
							}
						}
						this.list = this.listA;
						this.Ssdata = this.list[0];
						this.dcId = this.list[0].dcId;
						this.sellId = this.list[0].sellId;
					}
				});

			},
			//小时监测数据
			getXsData: async function() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/Hourmvmon`, {
					params: {},
				}).then((res) => {
					if (res.status == 200) {
						var data = res.data;
						var num = 0;
						for (var i = 0; i < this.option2.length; i++) {
							for (var j = 0; j < this.option2[i].sell.length; j++) {
								var sell = this.option2[i].sell[j];
								var map = {
									dcId: this.option2[i].value,
									dcName: this.option2[i].text,
									sellId: sell.coalId,
									sellName: sell.coalName,
									edrl: '',
									dqcl: '',
									pfbz: '',
									yc: '',
									so2: '',
									nox: '',
									yl: '',
									yqll: '',
									ttya: '',
									ttyb: '',
									yyq: ''
								};
								map.edrl = data[num * 11].v;
								map.dqcl = data[num * 11 + 1].v;
								map.pfbz = data[num * 11 + 2].v;
								map.yc = data[num * 11 + 3].v;
								map.so2 = data[num * 11 + 4].v;
								map.nox = data[num * 11 + 5].v;
								map.yl = data[num * 11 + 6].v;
								map.yqll = data[num * 11 + 7].v;
								map.ttya = data[num * 11 + 8].v;
								map.ttyb = data[num * 11 + 9].v;
								map.yyq = data[num * 11 + 10].v;
								this.listB.push(map);
								num++;
							}
						}

					}
				});

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
		width: 50%
	}

	.xs ul li h4 {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .4rem;
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

	.xs ul li p5 {
		font-size: 10px;
		color: #656565;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xs ul li p6 {
		font-size: 1px;
		color: #8A8A8A;
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
		color: #656565;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xt {
		padding-top: .5rem
	}

	.xt ul {}

	.xt ul li {
		float: left;
		text-align: center;
		width: 33.333%
	}

	.xt ul li h4 {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .4rem;
		line-height: 1.5rem
	}

	.xt ul li p {
		font-size: 10px;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xt ul li p1 {
		font-size: 10px;
		color: #656565;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xd {
		padding-top: .5rem
	}

	.xd ul {}

	.xd ul li {
		float: left;
		text-align: center;
		width: 100%
	}

	.xd ul li h4 {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .4rem;
		line-height: 1.5rem
	}

	.xd ul li p {
		font-size: 10px;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xd ul li p1 {
		font-size: 1px;
		color: #656565;
		font-family: arial;
		margin-bottom: .2rem
	}

	.t_l {
		text-align: left !important
	}
</style>
