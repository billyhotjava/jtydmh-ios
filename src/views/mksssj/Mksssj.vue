<!-- 生产经营指标-煤矿运营 -->
<template>
	<div style="width: 100%;overflow-x: hidden;" class="tab-page has-header">
		<div class="tab-header">
			<mt-header title="煤矿实时数据">
				<a href="javascript:;" slot="left" @click="$router.back(-1 )">
					<mt-button icon="back" />
				</a>
			</mt-header>
		</div>

		<div class="tab-content">
			<div class="tbox clearfix">
				<ul>
					<!-- <li>
						<p>{{topInfo.num1}}</p>
						<h4 class="red0">呼救</h4>
					</li>
					<li>
						<p>{{topInfo.num2}}</p>
						<h4 class="orange">报警</h4>
					</li> -->
					<!-- <li>
						<p>{{topInfo.num3}}</p>
						<h4 class="yellow">断网</h4>
					</li> -->
					<!-- <li>
						<p>{{topInfo.num4}}</p>
						<h4>故障</h4>
					</li> -->
					<li>
						<p>{{topInfo.num5}}</p>
						<h4>井下人员</h4>
					</li>
					<li>
						<p>{{topInfo.num6}}</p>
						<h4>井下车辆</h4>
					</li>
					<li>
						<p>{{topInfo.num7}}</p>
						<h4>井下领导</h4>
					</li>
					<li>
						<p>{{topInfo.num8}}</p>
						<h4>安全测点</h4>
					</li>
				</ul>
			</div>

			<div class="main content-container">

				<div class="tab-in-content">
					<div class="tit">
						<h4>
							煤炭产销量
							<span style="font-size:12px;margin-left:5px">万吨</span>
						</h4>
					</div>
					<van-tabs v-model="mtcxlActive" @click="tabsClick">
						<van-tab title="日">
							<van-row>
								<van-col span="12">
									<div class="con clearfix mr5">
										<div class="xs">
											<div class="chanliang">产量</div>
											<ul class="mtcxl0">
												<li>
													<p>{{mtcxl.dayplancl}}</p>
													<h4>计划</h4>
												</li>
												<li>
													<p>{{mtcxl.daycqcl}}</p>
													<h4>超欠</h4>
												</li>
											</ul>
											<div style="text-align:center;height:180px;width:100%" ref="mtDayClPie">
											</div>
										</div>
									</div>
								</van-col>
								<van-col span="12">
									<div class="con clearfix ml5">
										<div class="xs">
											<div class="xiaoliang">销量</div>
											<ul class="mtcxl0">
												<li>
													<p>{{mtcxl.dayplanxl}}</p>
													<h4>计划</h4>
												</li>
												<li>
													<p>{{mtcxl.daycqxl}}</p>
													<h4>超欠</h4>
												</li>
											</ul>
											<div style="text-align:center;height:180px;width:100%" ref="mtDayXlPie">
											</div>
										</div>
									</div>
								</van-col>
							</van-row>
						</van-tab>
						<van-tab title="月">
							<van-row>
								<van-col span="12">
									<div class="con clearfix mr5">
										<div class="xs">
											<div class="chanliang">产量</div>
											<ul class="mtcxl0">
												<li>
													<p>{{mtcxl.monthplancl}}</p>
													<h4>计划</h4>
												</li>
												<li>
													<p>{{mtcxl.monthcqcl}}</p>
													<h4>超欠</h4>
												</li>
											</ul>
											<div style="text-align:center;height:180px;width:100%" ref="mtMonthClPie">
											</div>
										</div>
									</div>
								</van-col>
								<van-col span="12">
									<div class="con clearfix ml5">
										<div class="xs">
											<div class="xiaoliang">销量</div>
											<ul class="mtcxl0">
												<li>
													<p>{{mtcxl.monthplanxl}}</p>
													<h4>计划</h4>
												</li>
												<li>
													<p>{{mtcxl.monthcqxl}}</p>
													<h4>超欠</h4>
												</li>
											</ul>
											<div style="text-align:center;height:180px;width:100%" ref="mtMonthXlPie">
											</div>
										</div>
									</div>
								</van-col>
							</van-row>
						</van-tab>
						<van-tab title="年">
							<van-row>
								<van-col span="12">
									<div class="con clearfix mr5">
										<div class="xs">
											<div class="chanliang">产量</div>
											<ul class="mtcxl0">
												<li>
													<p style="font-size:20px;">{{mtcxl.yearplancl}}</p>
													<h4>计划</h4>
												</li>
												<li>
													<p style="font-size:20px;">{{mtcxl.yearcqcl}}</p>
													<h4>超欠</h4>
												</li>
											</ul>
											<div style="text-align:center;height:180px;width:100%" ref="mtYearClPie">
											</div>
										</div>
									</div>
								</van-col>
								<van-col span="12">
									<div class="con clearfix ml5">
										<div class="xs">
											<div class="xiaoliang">销量</div>
											<ul class="mtcxl0">
												<li>
													<p style="font-size:20px;">{{mtcxl.yearplanxl}}</p>
													<h4>计划</h4>
												</li>
												<li>
													<p style="font-size:20px;">{{mtcxl.yearcqxl}}</p>
													<h4>超欠</h4>
												</li>
											</ul>
											<div style="text-align:center;height:180px;width:100%" ref="mtYearXlPie">
											</div>
										</div>
									</div>
								</van-col>
							</van-row>
						</van-tab>
					</van-tabs>
				</div>

				<div class="tab-content">
					<div class="tit">
						<h4>报警记录</h4>
					</div>
					<div class="con clearfix" style="margin-bottom: 10px" v-for="(item, i) in alarmList">
						<div class="baojing-list">
							<ul>
								<li style="width: 30%" class="red bold">{{item.coalName}}</li>
								<li style="width: 30%">{{item.alarmType}}</li>
								<li style="width: 40%">{{item.alarmDate}}</li>
							</ul>
						</div>
					</div>
					<div class="con clearfix" style="margin-bottom: 10px" v-if="alarmList.length <= 0">
						<p style="font-size: 12px; color: #5c5c5c">暂无数据</p>
					</div>
				</div>

				<!-- <div class="tab-content" style="overflow-y: hidden;">
					<div class="tit">
						<h4>商品煤销售</h4>
					</div>
					<div class="con clearfix">
						<div class="xs">
							<ul>
								<li>
									<p>{{fuelSell.zic}}</p>
									<h4>自产</h4>
								</li>
								<li>
									<p>{{fuelSell.waig}}</p>
									<h4>外购</h4>
								</li>
								<li>
									<p>{{fuelSell.zic + fuelSell.waig}}</p>
									<h4>合计</h4>
								</li>
							</ul>
						</div>
					</div>
				</div> -->

				<div class="tab-content" style="overflow-y: hidden;">
					<div class="tit">
						<h4>昨日外运列数</h4>
					</div>
					<div class="con clearfix">
						<table class="table-content">
							<tbody>
								<tr v-for="(item,i) in waiyun">
									<div v-if="i < 2">
										<td style="width:25%" class="bold">{{item.unit}}</td>
										<td style="width:10%">自产</td>
										<td style="width:15%" class="t_l bold">{{item.zic}}</td>
									</div>
									<div v-else>
										<td style="width:25%" class="bold">{{item.unit}}</td>
										<td style="width:10%">外运</td>
										<td style="width:15%" class="t_l bold">{{item.waiy}}</td>
									</div>
									<!-- <td style="width:10%">外购</td>
									<td style="width:15%" class="t_l bold">{{item.waig}}</td> -->
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<van-tabs v-model="activeName" style="margin-top: 20px; margin-bottom: 20px" @click="tabMkClick">
					<van-tab v-for="item in coalTabs" :title="item.coalName" :name="item.coalId"></van-tab>
				</van-tabs>

				<div class="con clearfix">
					<div class="list" style="margin-top:5px;">
						<div style="display: flex;justify-content: center;align-items: center">
							<img src="../../assets/images/hbzb/tx.png" style="width: 25px;height: 30px;float: left" />
							<p
								style="color: #216DEA;font-size: 15px;font-weight: 700;float: left;line-height: 25px;margin-left: 20px">
								{{gkjxInfo.ldxx}}
							</p>
						</div>
					</div>

					<van-divider style="background: #BEBBBB;"></van-divider>
					<div class="usert"><span>井下人员<span
								style="margin-left:10px;color: #216DEA;font-size: 18px;font-weight: 700;">{{gkjxInfo.jxry}}</span></span><span
							style="margin-left:50px;">井下车辆<span
								style="margin-left:10px;color: #216DEA;font-size: 18px;font-weight: 700;">{{gkjxInfo.jxcl}}</span></span>
					</div>
					<van-divider style="background: #BEBBBB;"></van-divider>

					<div class="tab-content" style="background: #eff8ff;overflow-y: hidden;">
						<div class="tit">
							<h3>主通风机</h3>
						</div>
						<div class="con clearfix" style="border:0px;">
							<div class="zsy-list">
								<div style="flex: 1.5; flex-direction: column;" v-if="activeName == '三道沟煤矿' || activeName == '黄玉川煤矿'">
									<h4></h4>
									<h4 style="margin-top: 35px;">{{gettopfsName()}}</h4>
									<h4 style="margin-top: 40px;">{{getbottomfsName()}}</h4>
								</div>
								<div style="flex: 2; flex-direction: column;">
									<h4>#1</h4>
									<ul v-for="zsy1 in zsy1List">
										<li style="margin-top: 10px;">
											<img style="width: 40px; height: 40px;" v-if="zsy1.detectionValue == '0'"
												src="../../assets/images/hbzb/ls.png" />
											<img style="width: 40px; height: 40px;" v-else-if="zsy1.detectionValue == '1'"
												src="../../assets/images/hbzb/hsg.gif" />
										</li>
									</ul>
								</div>
								<div style="flex: ;flex-direction: column;">
									<h4>#2</h4>
									<ul v-for="zsy2 in zsy2List">
										<li style="margin-top: 10px;">
											<img style="width: 40px; height: 40px;" v-if="zsy2.detectionValue == '0'"
												src="../../assets/images/hbzb/ls.png" />
											<img style="width: 40px; height: 40px;" v-else-if="zsy2.detectionValue == '1'"
												src="../../assets/images/hbzb/hsg.gif" />
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>

					<div class="tab-content" style="background: #eff8ff;">
						<div class="tit">
							<h3>局部通风机</h3>
						</div>
						<div class="js-list" style="margin-top: 15px;">
							<div class="js-list-item" v-for="(js,index) in jsList" :key="index">
								<div class="js-gzm" id="jsy" v-if="index == 0"
									style="border-top-left-radius: 4.5px;border-bottom-left-radius: 4.5px">
									工作面{{js.rowNumber}}</div>
								<div class="js-gzm" v-else-if="index == jsList.length-1"
									style="border-top-right-radius: 4.5px;border-bottom-right-radius: 4.5px">
									工作面{{js.rowNumber}}</div>
								<div class="js-gzm" v-else>工作面{{js.rowNumber}}</div>
								<div class="js-sy">
									<img v-if="js.zjsDdetectionValue == '0'" src="../../assets/images/hbzb/ls.png" />
									<img v-else-if="js.zjsDdetectionValue == '1'"
										src="../../assets/images/hbzb/hsg.gif" />
									<p style="">{{js.place}}</p>
								</div>
								<div class="js-sy">
									<img v-if="js.bjsDetectionValue == '0'" src="../../assets/images/hbzb/ls.png" />
									<img v-else-if="js.bjsDetectionValue == '1'"
										src="../../assets/images/hbzb/hsg.gif" />
									<p>{{js.place}}</p>
								</div>
							</div>
						</div>
					</div>

					<div class="tab-content" style="background: #eff8ff;">
						<div class="tit">
							<h3>气体监测</h3>
						</div>
						<table class="table-content">
							<tbody>
								<tr>
									<th> </th>
									<th>测点数</th>
									<th>区间</th>
									<th>数值</th>
								</tr>
								<tr v-for="(item,i) in qtjc">
									<td>{{item.coalName}}</td>
									<td>{{item.cds}}</td>
									<td>{{item.qj}}</td>
									<td>{{item.sz}}</td>
								</tr>
							</tbody>
						</table>

					</div>

					<div class="tab-in-content">
						<div class="tit1">
							<h4>CH4（%）</h4>
						</div>
						<div style="text-align:center;height:180px;width:100%" ref="ch4Line"></div>
					</div>

					<div class="tab-in-content">
						<div class="tit1">
							<h4>CO（PPM）</h4>
						</div>
						<div style="text-align:center;height:180px;width:100%" ref="coLine"></div>
					</div>

					<div class="tab-in-content">
						<div class="tit1">
							<h4>O2（%）</h4>
						</div>
						<div style="text-align:center;height:180px;width:100%" ref="o2Line"></div>
					</div>

				</div>
				
				<div class="tab-content" style="overflow-y: hidden;">
					<div class="tit">
						<h4>核定产能统计</h4>
					</div>
					<div class="con clearfix">
						<table class="table-content">
							<tbody>
								<tr>
									<th>单位</th>
									<!-- <th>设计产能</th> -->
									<th>核定产能</th>
								</tr>
								<tr v-for="(item,i) in cntj">
									<td style="color: #000000">{{item.coalMine}}</td>
									<!-- <td style="color: #000000">{{item.designCapacity}}</td> -->
									<td style="color: #000000">{{item.approvedCapacity}}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

			</div>
		</div>

	</div>
</template>

<script>
	import * as echarts from "echarts";
	import axios from "axios";
	import qs from "qs";
	import {
		fork
	} from "child_process";
	import {
		setInterval
	} from "timers";
	export default {
		name: "Mkyy",
		comments: {},
		props: {},
		data() {
			return {

				//顶部信息
				topInfo: {
					num1: '--',
					num2: '--',
					num3: '--',
					num4: '--',
					num5: '--',
					num6: '--',
					num7: '--',
					num8: '--'
				},
				//报警信息
				alarmList: [],
				//产能统计
				cntj: [],

				//商品煤销售
				fuelSell: {
					zic: '',
					waig: ''
				},

				//外运列数
				waiyun: [],

				mtcxlActive: 0,
				zcqyActive: 0,
				AqhbToken: "",
				mtcxl: {
					daywccl: "",
					daycqcl: "",
					dayplancl: "",
					daywcxl: "",
					daycqxl: "",
					dayplanxl: "",
					monthwccl: "",
					monthcqcl: "",
					monthplancl: "",
					monthwcxl: "",
					monthcqxl: "",
					monthplanxl: "",
					yearwccl: "",
					yearcqcl: "",
					yearplancl: "",
					yearwcxl: "",
					yearcqxl: "",
					yearplanxl: ""
				},
				gkjxInfo: {
					ldxx: "--",
					jxry: "--",
					jxcl: "--"
				},

				//煤矿标签
				activeName: '三道沟煤矿',
				coalTabs: [{
						coalId: '三道沟煤矿',
						coalName: '三道沟煤矿'
					},
					{
						coalId: '上榆泉煤矿',
						coalName: '上榆泉煤矿'
					},
					{
						coalId: '黄玉川煤矿',
						coalName: '黄玉川煤矿'
					},
					{
						coalId: '大南湖一矿',
						coalName: '大南湖一矿'
					},
					{
						coalId: '沙吉海煤矿',
						coalName: '沙吉海煤矿'
					},
					{
						coalId: '敏东一矿',
						coalName: '敏东一矿'
					},
					{
						coalId: '准东二矿',
						coalName: '准东二矿'
					}
				],

				//气体监控
				qtjc: [{
						coalName: 'CH₄',
						cds: "--",
						qj: 1.0,
						sz: "--"
					},
					{
						coalName: 'CO',
						cds: "--",
						qj: 24,
						sz: "--"
					},
					{
						coalName: 'O₂',
						cds: "--",
						qj: 18,
						sz: "--"
					}
				],
				zsy1List: [],
				zsy2List: [],
				jsList: [],
			};
		},
		mounted() {
			this.loadTopInfo1();
			this.loadTopInfo2();
			setTimeout(() => {
				this.loadTopInfo3();
				this.loadTopInfo4();
			}, 1000);
			setTimeout(() => {
				this.loadCntj();
				this.loadSpmxs();
			}, 2000);
			setTimeout(() => {
				this.loadWyls();
				this.loadMkjxxx();
			}, 3000);
			setTimeout(() => {
				this.loadZsy();
				this.loadJs();
			}, 4000);
			setTimeout(() => {
				this.loadMtcxl();
				this.loadCh4CoO2();
				this.loadQtjc();
			}, 5000);
		},
		methods: {
			gettopfsName(){
				if (this.activeName == '三道沟煤矿') {
					return '朴牛圪塔';
				}else if (this.activeName == '黄玉川煤矿') {
					return '一水平';
				}
			},
			getbottomfsName(){
				if (this.activeName == '三道沟煤矿') {
					return '大路墕';
				}else if (this.activeName == '黄玉川煤矿') {
					return '二水平';
				}
			},
			//顶部统计信息(呼救、报警、断网、故障)
			loadTopInfo1() {
				// axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/zhlgj`, {
				// 	params: {}
				// }).then(res => {
				// 	if (res.success) {
				// 		var list = res.list;
				// 		var num1 = 0;
				// 		// var num2=0;
				// 		var num3 = 0;
				// 		var num4 = 0;
				// 		for (var i = 0; i < list.length; i++) {
				// 			num1 += parseInt(list[i].callHelpNumber);
				// 			//	num2+=parseInt(list[i].alarmNumber);
				// 			num3 += parseInt(list[i].disconnectedNumber);
				// 			num4 += parseInt(list[i].failuresNumber);
				// 		}
				// 		this.topInfo.num1 = "" + num1;
				// 		//this.topInfo.num2=""+num2;
				// 		this.topInfo.num3 = "" + num3;
				// 		this.topInfo.num4 = "" + num4;

				// 	}
				// });
			},
			//顶部统计信息(报警)//报警记录
			loadTopInfo2() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/ssbjxx`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.list;
						var num2 = 0;
						this.alarmList = [];
						for (var i = 0; i < list.length; i++) {
							num2 += parseInt(list[i].alarmNumber);
							if (list[i] != null) {
								if (list[i].mineName != null) {
									this.alarmList.push({
										coalName: list[i].mineName,
										alarmType: list[i].alarmDescription,
										alarmDate: list[i].alarmTime
									});
								}
							}
						}
						this.topInfo.num2 = num2;
					}
				});
			},
			//顶部统计信息（井下人员、井下车辆、井下领导）
			loadTopInfo3() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/jxryclldzsxx`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.list;
						this.topInfo.num5 = list[0].totalStaff;
						this.topInfo.num6 = list[0].totalVehicle;
						this.topInfo.num7 = list[0].totalLeader;

					}
				});
			},
			//顶部统计信息（安全测点）
			loadTopInfo4() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/aqcdzssl`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.list;
						this.topInfo.num8 = list[0].safepointNumber;

					}
				});
			},

			//产能统计
			loadCntj() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/mkcn`, {
					params: {}
				}).then(res => {
					if (res.success) {
						this.cntj = res.list;
					}
				});
			},
			//商品煤销售
			loadSpmxs() {
				// axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/spmxs`, {
				// 	params: {}
				// }).then(res => {
				// 	if (res.success) {
				// 		var list = res.list;
				// 		for (var i = 0; i < list.length; i++) {
				// 			if (list[i].category == "外购") {
				// 				this.fuelSell.waig = parseFloat(list[i].value);
				// 			}
				// 			if (list[i].category == "自产") {
				// 				this.fuelSell.zic = parseFloat(list[i].value);
				// 			}
				// 		}
				// 	}
				// });
			},
			//外运列数
			loadWyls() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/wyls`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.list;
						var map = [];
						var str = "";
						this.waiyun = [];
						for (var i = 0; i < list.length; i++) {
							var name = list[i].unit.substring(0, list[i].unit.length - 2);
							if (str.indexOf(name + ",") == -1) {
								str += name + ","
								map.push(name);
							}
						}
						for (var i = 0; i < map.length - 1; i++) {
							var zic = "--";
							var waig = "--";
							var waiy = "--";
							for (var j = 0; j < list.length; j++) {
								if (list[j].unit.substring(0, list[j].unit.length - 2) == map[i]) {
									if (list[j].category == "自产") {
										zic = list[j].value;
									}
									if (list[j].category == "外购") {
										waig = list[j].value;
									}
									if (list[j].category == "外运") {
										waiy = list[j].value;
									}
								}

							}
							this.waiyun.push({
								unit: map[i],
								zic: zic,
								waig: waig,
								waiy: waiy
							});
						}
					}
				});
			},
			//各个煤矿井下信息统计
			loadMkjxxx() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gkjxryclldxx`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.list;
						for (var i = 0; i < list.length; i++) {
							if (list[i].mineName.indexOf(this.activeName) != -1) {
								this.gkjxInfo.ldxx = list[i].leaderName;
								this.gkjxInfo.jxry = list[i].undergroundPersonnel;
								this.gkjxInfo.jxcl = list[i].undergroundVehicles;
								break;
							}
						}
					}
				});
			},
			//主扇叶
			loadZsy() {
				this.zsy1List = [];
				this.zsy2List = [];
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gmkzsxx`, {
					params: {}
				}).then(res => {
					if (res.success) {
						for (var i = 0; i < res.list.length; i++) {
							if (res.list[i].coalMine.indexOf(this.activeName) != -1) {
								if (res.list[i].place.indexOf('1#') != -1) {
									this.zsy1List.push({
										detectionValue: res.list[i].detectionValue
									});
								}
								if (res.list[i].place.indexOf('2#') != -1) {
									this.zsy2List.push({
										detectionValue: res.list[i].detectionValue
									});
								}
							}
						}
					}
				});
			},
			//局扇
			loadJs() {
				this.jsList = [];
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gkjsxx`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var zjslist = [];
						var bjslist = [];
						for (var i = 0; i < res.list.length; i++) {
							if (res.list[i].coalMine.indexOf(this.activeName) != -1) {
								if (res.list[i].name == '主局扇') {
									zjslist.push(res.list[i]);
								}
								if (res.list[i].name == '备局扇') {
									bjslist.push(res.list[i]);
								}
							}
						}
						for (var j = 0; j < zjslist.length; j++) {
							for (var k = 0; k < bjslist.length; k++) {
								if (j == k) {
									this.jsList.push({
										place: zjslist[j].place,
										zjsDdetectionValue: zjslist[j].detectionValue,
										bjsDetectionValue: bjslist[k].detectionValue,
										rowNumber: zjslist[j].rowNumber,
									});
								}
							}
						}
					}
				});
			},
			//气体监测
			loadQtjc() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gkjwcoyqssjcz`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.list;
						this.qtjc[0].sz = "--";
						this.qtjc[1].sz = "--";
						this.qtjc[2].sz = "--";
						for (var i = 0; i < list.length; i++) {
							if (list[i].coalMine.indexOf(this.activeName) != -1) {
								if (list[i].gasType == "甲烷") {
									this.qtjc[0].sz = list[i].realtimeMonitoringValue;
								}
								if (list[i].gasType == "一氧化碳") {
									this.qtjc[1].sz = list[i].realtimeMonitoringValue;
								}
								if (list[i].gasType == "氧气") {
									this.qtjc[2].sz = list[i].realtimeMonitoringValue;
								}
							}
						}
					}
				});

				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gkjwcoyqcdsl`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.list;
						this.qtjc[0].cds = "--";
						this.qtjc[1].cds = "--";
						this.qtjc[2].cds = "--";
						for (var i = 0; i < list.length; i++) {
							if (list[i].coalMine.indexOf(this.activeName) != -1) {
								this.qtjc[0].cds = list[i].methane;
								this.qtjc[1].cds = list[i].carbonMonoxide;
								this.qtjc[2].cds = list[i].oxygen;
							}
						}
					}
				});
			},

			//煤炭产销量
			loadMtcxl() {
				axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/gsjs/coalproductionsales`, {
					params: {}
				}).then(res => {
					if (res.success) {
						var list = res.data.list;
						this.mtcxl.daywccl = list[0].dayActural; //日完成产量
						this.mtcxl.daycqcl = list[0].dayDiff; //日超欠产量
						this.mtcxl.dayplancl = list[0].dayPlan; //日计划产量
						this.mtcxl.monthwccl = list[0].monthActural; //月完成产量
						this.mtcxl.monthcqcl = list[0].monthDiff; //月超欠产量
						this.mtcxl.monthplancl = list[0].monthPlan; //月计划产量
						this.mtcxl.yearwccl = list[0].yearActural; //年完成产量
						this.mtcxl.yearcqcl = list[0].yearDiff; //年超欠产量
						this.mtcxl.yearplancl = list[0].yearPlan; //年计划产量

						this.mtcxl.daywcxl = list[1].dayActural; //日完成销量
						this.mtcxl.daycqxl = list[1].dayDiff; //日超欠销量
						this.mtcxl.dayplanxl = list[1].dayPlan; //日计划销量
						this.mtcxl.monthwcxl = list[1].monthActural; //月完成销量
						this.mtcxl.monthcqxl = list[1].monthDiff; //月超欠销量
						this.mtcxl.monthplanxl = list[1].monthPlan; //月计划销量
						this.mtcxl.yearwcxl = list[1].yearActural; //年完成销量
						this.mtcxl.yearcqxl = list[1].yearDiff; //年超欠销量
						this.mtcxl.yearplanxl = list[1].yearPlan; //年计销产量

						//加载饼图
						this.loadMtDayPie();
					}
				});
			},
			loadMtDayPie() {
				//日产量
				let mtDayClPie = echarts.init(this.$refs.mtDayClPie);
				mtDayClPie.clear();
				let daycldata = [{
						value: this.mtcxl.daywccl + this.mtcxl.daycqcl,
						name: "完成+超欠",
						itemStyle: {
							normal: {
								color: "#226ee8"
							}
						}
					},
					{
						value: this.mtcxl.dayplancl - this.mtcxl.daywccl - this.mtcxl.daycqcl,
						name: "计划",
						itemStyle: {
							normal: {
								color: "#d6d6d6"
							}
						}
					}
				];
				mtDayClPie.setOption({
					title: {
						text: this.mtcxl.daywccl,
						left: "center",
						top: "42%",
						textStyle: {
							color: "#226ee8",
							fontSize: 20,
							align: "center"
						}
					},
					series: [{
						name: "",
						type: "pie",
						radius: ["50%", "85%"],
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
						data: daycldata
					}]
				});

				//日销量
				let mtDayXlPie = echarts.init(this.$refs.mtDayXlPie);
				mtDayXlPie.clear();
				let dayxldata = [{
						value: this.mtcxl.daywcxl + this.mtcxl.daycqxl,
						name: "完成+超欠",
						itemStyle: {
							normal: {
								color: "#FF9C00"
							}
						}
					},
					{
						value: this.mtcxl.dayplanxl - this.mtcxl.daywcxl - this.mtcxl.daycqxl,
						name: "计划",
						itemStyle: {
							normal: {
								color: "#d6d6d6"
							}
						}
					}
				];
				mtDayXlPie.setOption({
					title: {
						text: this.mtcxl.daywcxl,
						left: "center",
						top: "42%",
						textStyle: {
							color: "#FF9C00",
							fontSize: 20,
							align: "center"
						}
					},
					series: [{
						name: "",
						type: "pie",
						radius: ["50%", "85%"],
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
						data: dayxldata
					}]
				});
			},
			loadMtMonthPie() {
				//月产量
				let mtMonthClPie = echarts.init(this.$refs.mtMonthClPie);
				mtMonthClPie.clear();
				let monthcldata = [{
						value: this.mtcxl.monthwccl + this.mtcxl.monthcqcl,
						name: "完成+超欠",
						itemStyle: {
							normal: {
								color: "#226ee8"
							}
						}
					},
					{
						value: this.mtcxl.monthplancl -
							this.mtcxl.monthwccl -
							this.mtcxl.monthcqcl,
						name: "计划",
						itemStyle: {
							normal: {
								color: "#d6d6d6"
							}
						}
					}
				];
				mtMonthClPie.setOption({
					title: {
						text: this.mtcxl.monthwccl,
						left: "center",
						top: "42%",
						textStyle: {
							color: "#226ee8",
							fontSize: 20,
							align: "center"
						}
					},
					series: [{
						name: "",
						type: "pie",
						radius: ["50%", "85%"],
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
						data: monthcldata
					}]
				});

				//月销量
				let mtMonthXlPie = echarts.init(this.$refs.mtMonthXlPie);
				mtMonthXlPie.clear();
				let monthxldata = [{
						value: this.mtcxl.monthwcxl + this.mtcxl.monthcqxl,
						name: "完成+超欠",
						itemStyle: {
							normal: {
								color: "#FF9C00"
							}
						}
					},
					{
						value: this.mtcxl.monthplanxl -
							this.mtcxl.monthwcxl -
							this.mtcxl.monthcqxl,
						name: "计划",
						itemStyle: {
							normal: {
								color: "#d6d6d6"
							}
						}
					}
				];
				mtMonthXlPie.setOption({
					title: {
						text: this.mtcxl.monthwcxl,
						left: "center",
						top: "42%",
						textStyle: {
							color: "#FF9C00",
							fontSize: 20,
							align: "center"
						}
					},
					series: [{
						name: "",
						type: "pie",
						radius: ["50%", "85%"],
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
						data: monthxldata
					}]
				});
			},
			loadMtYearPie() {
				//年产量
				let mtYearClPie = echarts.init(this.$refs.mtYearClPie);
				mtYearClPie.clear();
				let yearcldata = [{
						value: this.mtcxl.yearwccl + this.mtcxl.yearcqcl,
						name: "完成+超欠",
						itemStyle: {
							normal: {
								color: "#226ee8"
							}
						}
					},
					{
						value: this.mtcxl.yearplancl - this.mtcxl.yearwccl - this.mtcxl.yearcqcl,
						name: "计划",
						itemStyle: {
							normal: {
								color: "#d6d6d6"
							}
						}
					}
				];
				mtYearClPie.setOption({
					title: {
						text: this.mtcxl.yearwccl,
						left: "center",
						top: "42%",
						textStyle: {
							color: "#226ee8",
							fontSize: 20,
							align: "center"
						}
					},
					series: [{
						name: "",
						type: "pie",
						radius: ["50%", "85%"],
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
						data: yearcldata
					}]
				});

				//年销量
				let mtYearXlPie = echarts.init(this.$refs.mtYearXlPie);
				mtYearXlPie.clear();
				let yearxldata = [{
						value: this.mtcxl.yearwcxl + this.mtcxl.yearcqxl,
						name: "完成+超欠",
						itemStyle: {
							normal: {
								color: "#FF9C00"
							}
						}
					},
					{
						value: this.mtcxl.yearplanxl - this.mtcxl.yearwcxl - this.mtcxl.yearcqxl,
						name: "计划",
						itemStyle: {
							normal: {
								color: "#d6d6d6"
							}
						}
					}
				];
				mtYearXlPie.setOption({
					title: {
						text: this.mtcxl.yearwcxl,
						left: "center",
						top: "42%",
						textStyle: {
							color: "#FF9C00",
							fontSize: 20,
							align: "center"
						}
					},
					series: [{
						name: "",
						type: "pie",
						radius: ["50%", "85%"],
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
						data: yearxldata
					}]
				});
			},
			tabMkClick(name, title) {
				this.activeName = name;
				this.loadMkjxxx();
				this.loadQtjc();
				this.loadCh4CoO2();
				this.loadZsy();
				this.loadJs();
			},
			tabsClick(name, title) {
				this.$nextTick(() => {
					if (name == 1) {
						this.loadMtMonthPie();
					}
					if (name == 2) {
						this.loadMtYearPie();
					}
				});
			},
			//CH4
			loadCh4CoO2() {
				//CH4
				var ch4Line = echarts.init(this.$refs.ch4Line);
				ch4Line.clear();
				var ch4Option = {
					title: {
						//text: 'CH₄监控'
					},
					tooltip: {
						trigger: "axis"
					},
					grid: {
						left: "3%",
						right: "4%",
						bottom: "3%",
						containLabel: true
					},
					toolbox: {
						feature: {
							// saveAsImage: {}
						}
					},
					xAxis: {
						type: "category",
						boundaryGap: false,
						axisLabel: {
							show: true,
							textStyle: {
								// color: "#a9a9a9", //更改坐标轴文字颜色
								fontSize: 10 //更改坐标轴文字大小
							},
							// rotate: 90, //文字倾斜使用此属性
							showMinLabel: true, //显示最小值
							showMaxLabel: true //显示最大值
						},
						data: []
					},
					yAxis: {
						type: "value",
						scale: true,
						min: 0
						//max: 1,
					},
					series: [{
						name: "CH₄",
						type: "line",
						showSymbol: false,
						smooth: true,
						data: [],
						//实现辅助线部分
						markLine: {
							symbol: "none", //去掉警戒线最后面的箭头
							data: [{
								silent: false, //鼠标悬停事件  true没有，false有
								lineStyle: {
									//警戒线的样式  ，虚实  颜色
									type: "solid",
									color: "#FA3934"
								},
								label: {
									position: "middle", //将警示值放在哪个位置，三个值“start”,"middle","end"  开始  中点 结束
									formatter: "警戒线(1)"
								},
								yAxis: 1 // 警戒线的标注值，可以有多个yAxis,多条警示线   或者采用   {type : 'average', name: '平均值'}，type值有  max  min  average，分为最大，最小，平均值
							}, ]
						}
					}]
				};
				//CO
				var coLine = echarts.init(this.$refs.coLine);
				coLine.clear();
				var coOption = {
					title: {
						//text: 'CO监控'
					},
					tooltip: {
						trigger: "axis"
					},
					grid: {
						left: "3%",
						right: "4%",
						bottom: "3%",
						containLabel: true
					},

					xAxis: {
						type: "category",
						boundaryGap: false,
						axisLabel: {
							show: true,
							textStyle: {
								// color: "#a9a9a9", //更改坐标轴文字颜色
								fontSize: 10 //更改坐标轴文字大小
							},
							// rotate: 40, 文字倾斜使用此属性
							showMinLabel: true, //显示最小值
							showMaxLabel: true //显示最大值
						},
						data: []
					},
					yAxis: {
						type: "value",
						scale: true,
						min: 0
						//max: 180,
					},
					series: [{
						name: "CO",
						type: "line",
						showSymbol: false,
						smooth: true,
						data: [],
						//实现辅助线部分
						markLine: {
							symbol: "none", //去掉警戒线最后面的箭头
							data: [{
								silent: false, //鼠标悬停事件  true没有，false有
								lineStyle: {
									//警戒线的样式  ，虚实  颜色
									type: "solid",
									color: "#FA3934"
								},
								label: {
									position: "middle", //将警示值放在哪个位置，三个值“start”,"middle","end"  开始  中点 结束
									formatter: "警戒线(80)"
								},
								yAxis: "80" // 警戒线的标注值，可以有多个yAxis,多条警示线   或者采用   {type : 'average', name: '平均值'}，type值有  max  min  average，分为最大，最小，平均值
							}, ]
						}
					}]
				};

				//O2
				var o2Line = echarts.init(this.$refs.o2Line);
				o2Line.clear();
				var o2Option = {
					title: {
						//text: 'O₂监控'
					},
					tooltip: {
						trigger: "axis"
					},
					// legend: {
					//     data: ['O₂','CO','CH₄']
					// },
					grid: {
						left: "3%",
						right: "4%",
						bottom: "3%",
						containLabel: true
					},

					xAxis: {
						type: "category",
						boundaryGap: false,
						axisLabel: {
							show: true,
							textStyle: {
								// color: "#a9a9a9", //更改坐标轴文字颜色
								fontSize: 10 //更改坐标轴文字大小
							},
							// rotate: 40, 文字倾斜使用此属性
							showMinLabel: true, //显示最小值
							showMaxLabel: true //显示最大值
						},
						data: []
					},
					yAxis: {
						type: "value",
						scale: true,
						min: 17
						// max: 18,
					},

					series: [{
						name: "O₂",
						type: "line",
						showSymbol: false,
						smooth: true,
						data: [],
						//实现辅助线部分
						markLine: {
							symbol: "none",
							data: [{
								silent: false, //鼠标悬停事件  true没有，false有
								lineStyle: {
									//警戒线的样式  ，虚实  颜色
									type: "solid",
									color: "#FA3934"
								},
								label: {
									position: "middle",
									formatter: "警戒线(18)"
								},
								yAxis: "18" // 警戒线的标注值，可以有多个yAxis,多条警示线   或者采用   {type : 'average', name: '平均值'}，type值有  max  min  average，分为最大，最小，平均值
							}]
						}
					}]
				};

				axios.get(
					`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gkjwssjczqx?coalMine=${this.activeName}`, {
						// params: {}
					}).then(res => {
					if (res.success) {
						let timeData = ['00', '02', '04', '06', '08', '10', '12', '14', '16', '18', '20', '22',
							'24'
						];
						var ch4List = [];
						for (var i = 0; i < res.list.length; i++) {
							ch4List.push(res.list[i].realtimeMonitoringValue);
						}
						ch4Option.xAxis.data = timeData;
						ch4Option.series[0].data = ch4List;
						var flag = true;
						for (var i = 0; i < res.list.length; i++) {
							var data = res.list[i];
							if (data > 1) {
								flag = false;
								break;
							}
						}
						if (flag) ch4Option.yAxis.max = 1;
						ch4Line.setOption(ch4Option);
					}
				});

				axios.get(
					`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gkcossjczqx?coalMine=${this.activeName}`, {
						params: {
							coalMine: this.activeName
						}
					}).then(res => {
					if (res.success) {
						//CO
						let timeData = ['00', '02', '04', '06', '08', '10', '12', '14', '16', '18', '20', '22',
							'24'
						];
						var coList = [];
						for (var i = 0; i < res.list.length; i++) {
							coList.push(res.list[i].realtimeMonitoringValue);
						}
						coOption.xAxis.data = timeData;
						coOption.series[0].data = coList;
						var flag = true;
						for (var i = 0; i < coList.length; i++) {
							var data = coList[i];
							if (data > 1) {
								flag = false;
								break;
							}
						}
						if (flag) coOption.yAxis.max = 80;
						coLine.setOption(coOption);
					}
				});

				axios.get(
					`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/visu/gkyqssjczqx?coalMine=${this.activeName}`, {
						params: {
							coalMine: this.activeName
						}
					}).then(res => {
					if (res.success) {
						//O2
						let timeData = ['00', '02', '04', '06', '08', '10', '12', '14', '16', '18', '20', '22',
							'24'
						];
						var o2List = [];
						for (var i = 0; i < res.list.length; i++) {
							o2List.push(res.list[i].realtimeMonitoringValue);
						}
						o2Option.xAxis.data = timeData;
						o2Option.series[0].data = o2List;
						var flag = true;
						for (var i = 0; i < o2List.length; i++) {
							var data = o2List[i];
							if (data > 1) {
								flag = false;
								break;
							}
						}
						if (flag) o2Option.yAxis.max = 80;
						o2Line.setOption(o2Option);
					}
				});
			},

		}
	};
</script>

<style lang="scss">
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
		margin-bottom: 2rem;
	}

	.tbox ul li p {
		font-size: 26px;
		font-weight: 700;
		color: #fff;
		font-family: arial;
		margin-bottom: 0.2rem;
	}

	.tbox ul li h4 {
		font-size: 12px;
		color: #fff;
		line-height: 1.5rem;
	}

	.red0 {
		color: #ff7d83 !important;
	}

	.red {
		color: #ec070a !important;
	}

	.orange {
		color: #f3a527 !important;
	}

	.yellow {
		color: #f7da45 !important;
	}

	.blank10 {
		clear: both;
		display: block;
		overflow: hidden;
		height: 0.5rem;
		line-height: 0.5rem;
		font-size: 0px;
	}

	.main {
		padding: 1rem;
		padding-top: 0px;
	}

	.tab-in-content {}

	.bold {
		font-weight: 700 !important;
	}

	.tit {
		margin: 0.8rem 0;
	}

	.tit h4 {
		font-size: 15px;
		color: #5c5c5c;
		font-weight: 700;
		position: relative;
		padding-left: 12px;
	}

	.tit h3 {
		font-size: 15px;
		color: #5c5c5c;
		font-weight: 700;
		position: relative;
		/*padding-left: 12px;*/
	}

	.tit h4:after {
		content: "";
		position: absolute;
		z-index: 0;
		top: 0px;
		left: 0;
		width: 4px;
		height: 1.1rem;
		border-radius: 3px;
		background: #1e6de4;
	}

	.tit1 {
		margin-top: 20px;
		text-align: center;
	}

	.tit1 h4 {
		font-size: 15px;
		color: #5c5c5c;
		font-weight: 700;
		position: relative;
		padding-left: 12px;
	}

	.con {
		background: #eff8ff;
		border: 1px solid #e5e6e8;
		padding: 0.5rem;
		border-radius: 5px;
	}

	.zsy-list {
		width: 100%;
		display: flex;
		padding-left: 5px;
	}

	.zsy-list div {
		width: 50%;
		/*flex-grow: 1;*/
		display: flex;
		align-items: center;
	}

	.zsy-list h4 {
		float: left;
		font-weight: 700;
	}

	.zsy-list ul {
		float: left;
		margin-left: 10px
	}

	.zsy-list ul li img {
		width: 30px;
		height: 30px;
		margin-right: 8px;
	}

	.js-list {
		/*width: 100%;*/
		/*display: flex;*/
		/*flex-wrap: wrap;*/
		text-align: center;
		display: -webkit-box;
		overflow-x: scroll;
		-webkit-overflow-scrolling: touch;
	}

	.js-list-item {
		width: 25%;
		/*flex-grow: 1;*/
		padding-bottom: 23px;
	}

	.js-gzm {
		font-size: 10px;
		background: #CEE5FF;
		padding: 5px;
		color: #5D5D5D;
		/*border-radius: 15px;*/
	}

	.js-sy {
		margin-top: 23px;
		justify-content: center
	}

	.js-sy img {
		width: 30px;
		height: 30px;
	}

	.js-sy p {
		font-size: 8px;
		color: #949494;
		font-family: 'Times New Roman';
		margin-top: 7px;
		display: block;
		/* 当前元素本身是inline的，因此需要设置成block模式 */
		white-space: nowrap;
		/* 因为设置了block，所以需要设置nowrap来确保不换行 */
		overflow: hidden;
		/* 超出隐藏结合width使用截取采用效果*/
		text-overflow: ellipsis;
		/* 本功能的主要功臣，超出部分的剪裁方式 */
	}

	.list {}

	.list ul {}

	.list ul li {
		float: left;
		font-size: 0.8rem;
		color: #696c75;
	}
	
	.baojing-list{
		width: 100%;
		float: left;
		margin-left: 5px;
	}
	
	.baojing-list ul li {
		float: left;
		font-size: 0.8rem;
		color: #696c75;
	}

	.table-content {
		empty-cells: show;
		border-collapse: collapse;
		border-spacing: 0;
		width: 100%;

	}

	.tab-content {
		overflow-y: hidden;
	}

	table {
		empty-cells: show;
		border-collapse: collapse;
		border-spacing: 0;
	}

	.table-content th {
		padding: 0.5rem 0.2rem;
		border-bottom: 2px solid #c4def9;
		font-size: 0.8rem;
		color: #696c75;
		text-align: center;
	}

	.table-content td {
		padding: 0.5rem 0.2rem;
		border-bottom: 1px solid #e4e4e4;
		font-size: 0.8rem;
		color: #696c75;
		text-align: center;
	}

	.xs {
		padding-top: 0.5rem;
	}

	.xs ul {}

	.xs ul li {
		float: left;
		text-align: center;
		width: 33.333%;
	}

	.xs ul li h4 {
		font-size: 0.8rem;
		color: #696c75;
		line-height: 1.5rem;
	}

	.xs ul li p {
		font-size: 17px;
		font-weight: 700;
		color: #696c75;
		font-family: arial;
		margin-bottom: 0.2rem;
	}

	.xs h3 {
		font-size: 1.1rem;
		font-weight: 700;
		color: #696c75;
		font-family: arial;
		margin-bottom: 0.5rem;
	}

	.xs0 {
		padding-top: 0.5rem;
	}

	.xs0 ul {}

	.xs0 ul li {
		float: left;
		text-align: center;
		width: 33.333%;
		padding: 5px 0px;
	}

	.xs0 ul li h4 {
		font-size: 0.8rem;
		color: #696c75;
		line-height: 1.5rem;
	}

	.xs0 ul li p {
		font-size: 1.2rem;
		font-weight: 700;
		color: #696c75;
		font-family: arial;
		margin-bottom: 0.2rem;
	}

	.xs0 h3 {
		font-size: 1.1rem;
		font-weight: 700;
		color: #696c75;
		font-family: arial;
		margin-bottom: 0.5rem;
	}

	.t_l {
		text-align: left !important;
	}

	.t_r {
		text-align: right !important;
	}

	.mtcxl0 {
		margin-top: 3px;
		margin-bottom: 50px;
	}

	.mtcxl0 li {
		width: 50% !important;
		float: left !important;
		text-align: center !important;
	}

	.mtcxl0 li h4 {
		font-size: 12px;
		text-align: center;
	}

	.mtcxl0 li p {
		text-align: center;
		font-size: 19px;
		font-weight: 700;
		margin-top: 8px;
	}

	.chanliang {
		text-align: center;
		font-size: 16px;
		font-weight: 700;
		color: #226eea;
	}

	.xiaoliang {
		text-align: center;
		font-size: 16px;
		font-weight: 700;
		color: #ff9c01;
	}

	.mr5 {
		margin-right: 5px;
	}

	.ml5 {
		margin-left: 5px;
	}

	.van-tabs--line .van-tabs__wrap {
		height: 44px;
		margin-bottom: 10px;
	}

	.van-col--12 {
		width: 50%;
		/*margin-top: 10px;*/
	}

	.van-tabs__line {
		background: #216dea;
	}

	.mb10 {
		margin-bottom: 10px;
	}

	.t_c {
		text-align: center !important;
	}

	.lb {
		width: 100%;
	}

	.lb td {
		// padding: 10px 2px;
		font-size: 10px;
	}

	.lb td strong {
		font-size: 15px;
		font-weight: 700;
		color: #5c5c5c;
	}


	.zsyxbt {
		font-size: 0.9rem;
		color: #5c5c5c;
		font-weight: 700;
	}

	.zsyx_con {
		padding: 10px;
	}

	.mb10 {
		margin-bottom: 10px;
	}

	.zsyx_con span {
		font-size: 12px;
	}

	.van-tab--active {
		color: #216DEA;
		font-weight: 700;
	}

	.usert {
		text-align: center;
	}

	.usert p {
		margin: 10px;
		text-align: center;
		color: #216DEA;
		font-size: 14px;
	}
</style>
