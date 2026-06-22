<!-- 生产经营指标-煤矿运营 -->
<template>
	<div style="width: 100%;overflow-x: hidden;">
		<div class="main">
			<div class="tab-content" style="overflow-y: hidden;">
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
										<div style="text-align:center;height:180px;width:100%" ref="mtDayClPie"></div>
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
										<div style="text-align:center;height:180px;width:100%" ref="mtDayXlPie"></div>
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
										<div style="text-align:center;height:180px;width:100%" ref="mtMonthClPie"></div>
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
										<div style="text-align:center;height:180px;width:100%" ref="mtMonthXlPie"></div>
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
										<div style="text-align:center;height:180px;width:100%" ref="mtYearClPie"></div>
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
										<div style="text-align:center;height:180px;width:100%" ref="mtYearXlPie"></div>
									</div>
								</div>
							</van-col>
						</van-row>
					</van-tab>
				</van-tabs>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>装车外运</h4>
				</div>
				<van-tabs v-model="zcqyActive">
					<van-tab title="自产煤">
						<van-row>
							<div class="con clearfix mb10 mt10">
								<tbody class="lb">
									<tr>
										<th></th>
										<th>日完成</th>
										<th>月计划</th>
										<th>月完成</th>
										<th>月超欠</th>
									</tr>
									<tr v-for="index in zcmList">
										<td style="width:16%;">
											<div class="biaoti">{{index.mk}}</div>
										</td>
										<td class="t_c" style="width: 20%;">
											<!-- <div>{{index.rwcl + '列'}}</div> -->
											<div style="margin-top: 5px;">{{index.rwcd + '万吨'}}</div>
										</td>
										<td class="t_c" style="width: 20%;">
											<!-- <div>{{index.yjhl + '列'}}</div> -->
											<div style="margin-top: 5px;">{{index.yjhd + '万吨'}}</div>
										</td>
										<td class="t_c" style="width: 21%;">
											<!-- <div>{{index.ywcl + '列'}}</div> -->
											<div style="margin-top: 5px;">{{index.ywcd + '万吨'}}</div>
										</td>	
										<td class="t_c" style="width: 21%;">
											<!-- <div>{{index.ycql + '列'}}</div> -->
											<div style="margin-top: 5px;">{{index.ycqd + '万吨'}}</div>
										</td>
									</tr>
                <tr>
                  <td style="width:16%;" v-if="zcmList != null && zcmList.length != 0">
                    <div class="biaoti">{{zcmTotal.name}}</div>
                  </td>
                  <td class="t_c" style="width: 20%;">
                    <!-- <div>{{index.rwcl + '列'}}</div> -->
                    <div style="margin-top: 5px;">{{zcmTotal.rwcTotal + '万吨'}}</div>
                  </td>
                  <td class="t_c" style="width: 20%;">
                    <!-- <div>{{index.yjhl + '列'}}</div> -->
                    <div style="margin-top: 5px;">{{zcmTotal.yjhTotal + '万吨'}}</div>
                  </td>
                  <td class="t_c" style="width: 21%;">
                    <!-- <div>{{index.ywcl + '列'}}</div> -->
                    <div style="margin-top: 5px;">{{zcmTotal.ywcTotal + '万吨'}}</div>
                  </td>
                  <td class="t_c" style="width: 21%;">
                    <!-- <div>{{index.ycql + '列'}}</div> -->
                    <div style="margin-top: 5px;">{{zcmTotal.ycqTotal + '万吨'}}</div>
                  </td>
                  </td>
                </tr>
								</tbody>
								<!-- <table class="lb">
									<tr>
										<td style="width:30%;" class="t_c">
											<strong>日完成</strong>
										</td>
										<td style="width:25%" class="t_r">
											<strong>{{index.rwcl}}</strong>
										</td>
										<td style="width:10%" class="t_l">列</td>
										<td style="width:25%" class="t_r">
											<strong>{{index.rwcd}}</strong>
										</td>
										<td style="width:10%" class="t_l">万吨</td>
									</tr>

									<tr>
										<td class="t_c">
											<strong>月计划</strong>
										</td>
										<td class="t_r">
											<strong>{{index.yjhl}}</strong>
										</td>
										<td class="t_l">列</td>
										<td class="t_r">
											<strong>{{index.yjhd}}</strong>
										</td>
										<td class="t_l">万吨</td>
									</tr>

									<tr>
										<td class="t_c">
											<strong>月完成</strong>
										</td>
										<td class="t_r">
											<strong>{{index.ywcl}}</strong>
										</td>
										<td class="t_l">列</td>
										<td class="t_r">
											<strong>{{index.ywcd}}</strong>
										</td>
										<td class="t_l">万吨</td>
									</tr>

									<tr>
										<td class="t_c">
											<strong>月超欠</strong>
										</td>
										<td class="t_r">
											<strong>{{index.ycql}}</strong>
										</td>
										<td class="t_l">列</td>
										<td class="t_r">
											<strong>{{index.ycqd}}</strong>
										</td>
										<td class="t_l">万吨</td>
									</tr> 
								</table>-->
							</div>
						</van-row>
					</van-tab>
				<!-- 	<van-tab title="外购煤">
						<van-row v-for="index in wgmList">
							<div class="con clearfix mb10">
								<div class="biaoti">{{index.mk}}</div>
								<table class="lb">
									<tr>
										<td style="width:30%;" class="t_c">
											<strong>日完成</strong>
										</td>
										<td style="width:25%" class="t_r">
											<strong>{{index.rwcl}}</strong>
										</td>
										<td style="width:10%" class="t_l">列</td>
										<td style="width:25%" class="t_r">
											<strong>{{index.rwcd}}</strong>
										</td>
										<td style="width:10%" class="t_l">万吨</td>
									</tr>

									<tr>
										<td class="t_c">
											<strong>月计划</strong>
										</td>
										<td class="t_r">
											<strong>{{index.yjhl}}</strong>
										</td>
										<td class="t_l">列</td>
										<td class="t_r">
											<strong>{{index.yjhd}}</strong>
										</td>
										<td class="t_l">万吨</td>
									</tr>

									<tr>
										<td class="t_c">
											<strong>月完成</strong>
										</td>
										<td class="t_r">
											<strong>{{index.ywcl}}</strong>
										</td>
										<td class="t_l">列</td>
										<td class="t_r">
											<strong>{{index.ywcd}}</strong>
										</td>
										<td class="t_l">万吨</td>
									</tr>

									<tr>
										<td class="t_c">
											<strong>月超欠</strong>
										</td>
										<td class="t_r">
											<strong>{{index.ycql}}</strong>
										</td>
										<td class="t_l">列</td>
										<td class="t_r">
											<strong>{{index.ycqd}}</strong>
										</td>
										<td class="t_l">万吨</td>
									</tr>
								</table>
							</div>
						</van-row>
					</van-tab> -->
				</van-tabs>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>CH4（%）</h4>
				</div>
				<div style="text-align:center;height:180px;width:100%" ref="ch4Line"></div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>CO（PPM）</h4>
				</div>
				<div style="text-align:center;height:180px;width:100%" ref="coLine"></div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>O2（%）</h4>
				</div>
				<div style="text-align:center;height:180px;width:100%" ref="o2Line"></div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>井工矿人员车辆信息</h4>
				</div>
				<div class="con clearfix" style="padding:20px 10px">
					<div class="xs">
						<ul>
							<li style="width:25%">
								<p>{{jgk.jxry}}</p>
								<h4>井下人员</h4>
							</li>
							<li style="width:25%">
								<p>{{jgk.jxcl}}</p>
								<h4>井下车辆</h4>
							</li>
							<li style="width:25%">
								<p>{{jgk.gsld}}</p>
								<h4>公司领导</h4>
							</li>
							<li style="width:25%">
								<p>{{jgk.kjld}}</p>
								<h4>矿级领导</h4>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>主扇运行情况</h4>
				</div>
				<div v-for="(zsyx,index) in zsyxList">
					<van-row v-if="index%2==0">
						<van-col span="12">
							<div class="con clearfix mr5 mb10">
								<div class="zsyxbt">{{zsyx.mkjkName}}</div>
								<div class="zsyx_con">
									<div style="position:relative;">
										<span v-if="zsyx.fan.length > 0 && zsyx.fan[0] != null"
											style="position:absolute; right:-15px; top:8px">{{zsyx.fan[0].fanName}}</span>
										<span v-if="zsyx.fan.length > 1 && zsyx.fan[1] != null"
											style="position:absolute; right:-15px; bottom:8px">{{zsyx.fan[1].fanName}}</span>
										<img class="fs-img-wrap" v-if="zsyx.fan.length > 0 && zsyx.fan[0] != null && zsyx.fan[0].status.length > 0"
											:src="zsyx.fan[0].status[0]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:50px; top:6px">
										<img class="fs-img-wrap" v-if="zsyx.fan.length > 0 && zsyx.fan[0] != null && zsyx.fan[0].status.length > 1"
											:src="zsyx.fan[0].status[1]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:20px; top:6px">
										<img class="fs-img-wrap" v-if="zsyx.fan.length > 1 && zsyx.fan[1] != null && zsyx.fan[1].status.length > 0"
											:src="zsyx.fan[1].status[0]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:50px; bottom:8px">
										<img class="fs-img-wrap" v-if="zsyx.fan.length > 1 && zsyx.fan[1] != null && zsyx.fan[1].status.length > 1"
											:src="zsyx.fan[1].status[1]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:20px; bottom:8px">
										<img src="../../assets/images/mk.png">
									</div>
								</div>
							</div>
						</van-col>
						<van-col v-if="index <= zsyxList.length-2" span="12">
							<div class="con clearfix ml5">
								<div class="zsyxbt">{{zsyxList[index+1].mkjkName}}</div>
								<div class="zsyx_con">
									<div style="position:relative;">
										<span
											v-if="zsyxList[index+1].fan.length > 0 && zsyxList[index+1].fan[0] != null"
											style="position:absolute; right:-15px; top:8px">{{zsyxList[index+1].fan[0].fanName}}</span>
										<span
											v-if="zsyxList[index+1].fan.length > 1 && zsyxList[index+1].fan[1] != null"
											style="position:absolute; right:-15px; bottom:8px">{{zsyxList[index+1].fan[1].fanName}}</span>
										<img class="fs-img-wrap" v-if="zsyxList[index+1].fan.length > 0 && zsyxList[index+1].fan[0] != null && zsyxList[index+1].fan[0].status.length > 0"
											:src="zsyxList[index+1].fan[0].status[0]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:50px; top:6px">
										<img class="fs-img-wrap" v-if="zsyxList[index+1].fan.length > 0 && zsyxList[index+1].fan[0] != null && zsyxList[index+1].fan[0].status.length > 1"
											:src="zsyxList[index+1].fan[0].status[1]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:20px; top:6px">
										<img class="fs-img-wrap" v-if="zsyxList[index+1].fan.length > 1 && zsyxList[index+1].fan[1] != null && zsyxList[index+1].fan[1].status.length > 0"
											:src="zsyxList[index+1].fan[1].status[0]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:50px; bottom:8px">
										<img class="fs-img-wrap" v-if="zsyxList[index+1].fan.length > 1 && zsyxList[index+1].fan[1] != null && zsyxList[index+1].fan[1].status.length > 1"
											:src="zsyxList[index+1].fan[1].status[1]==0?require('../../assets/images/hbzb/ls.png'):require('../../assets/images/hbzb/hsg.gif')"
											style="position:absolute; right:20px; bottom:8px">
										<img src="../../assets/images/mk.png">
									</div>
								</div>
							</div>
						</van-col>
					</van-row>
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
				zcmList: [],
        zcmTotal:{
				  rwcTotal: 0.0,
          yjhTotal: 0.0,
          ywcTotal: 0.0,
          ycqTotal: 0.0
        },
				wgmList: [],
				jgk: {
					jxry: "",
					jxcl: "",
					gsld: "",
					kjld: ""
				},
				zsyxList: []
			};
		},
		mounted() {
			this.loadMtcxl();
			setTimeout(() => {
				this.loadZcwy();
			}, 500);
			setTimeout(() => {
				this.loadCh4CoO2();
			}, 1000);
			setTimeout(() => {
				this.loadJgkrycl();
			}, 1500);
			setTimeout(() => {
				this.loadZsyx();
			}, 2000);
		},
		methods: {
			//煤炭产销量
			loadMtcxl() {
				axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/coalproductionsales`, {
							params: {}
						}
					)
					.then(res => {
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
			//装车外运
			loadZcwy() {
				axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/aqhb/AqhbZcwy`, {
							params: {}
						}
					)
					.then(res => {
						if (res.list) {
							let list = res.list;
							let zcName = [];
							let wgName = [];
							for (let i = 0; i < list.length; i++) {
								let type1 = list[i].type1; // NUM
								let type2 = list[i].type2; // 自产煤
								let name = list[i].name;
								let obj = {
									mk: name,
									rwcl: "",
									rwcd: "",
									yjhl: "",
									yjhd: "",
									ywcl: "",
									ywcd: "",
									ycql: "",
									ycqd: ""
								};

								if (type2 == "自产煤") {
									let flag = true;
									this.zcmTotal.name = '总计';
									for (let j = 0; j < this.zcmList.length; j++) {
										if (this.zcmList[j].mk == name) {
											flag = false;
											if (type1 == "NUM") {
												this.zcmList[j].rwcl = list[i].dayActual;
												this.zcmList[j].yjhl = list[i].mounthPlan;
												this.zcmList[j].ywcl = list[i].mounthActual;
												this.zcmList[j].ycql = list[i].mounthDiff;
											}
											if (type1 == "AMOUNT") {
												this.zcmList[j].rwcd = list[i].dayActual;
												this.zcmList[j].yjhd = list[i].mounthPlan;
												this.zcmList[j].ywcd = list[i].mounthActual;
												this.zcmList[j].ycqd = list[i].mounthDiff;
											}
                      this.zcmTotal.rwcTotal = parseFloat(this.zcmTotal.rwcTotal) + parseFloat(list[i].dayActual);
                      this.zcmTotal.yjhTotal = parseFloat(this.zcmTotal.yjhTotal) + parseFloat(list[i].mounthPlan);
                      this.zcmTotal.ywcTotal = parseFloat(this.zcmTotal.ywcTotal) + parseFloat(list[i].mounthActual);
                      this.zcmTotal.ycqTotal = parseFloat(this.zcmTotal.ycqTotal) + parseFloat(list[i].mounthDiff);
											break;
										}
									}
									if (flag) {
										if (type1 == "NUM") {
											obj.rwcl = list[i].dayActual;
											obj.yjhl = list[i].mounthPlan;
											obj.ywcl = list[i].mounthActual;
											obj.ycql = list[i].mounthDiff;
										}
										if (type1 == "AMOUNT") {
											obj.rwcd = list[i].dayActual;
											obj.yjhd = list[i].mounthPlan;
											obj.ywcd = list[i].mounthActual;
											obj.ycqd = list[i].mounthDiff;
										}
										this.zcmList.push(obj);
									}
									console.log("rwcTotal " + parseFloat(this.zcmTotal.rwcTotal) + '  dayActual   ' + parseFloat(list[i].dayActual));
                  // this.zcmTotal.rwcTotal = parseFloat(this.zcmTotal.rwcTotal) + parseFloat(list[i].dayActual);
                  // this.zcmTotal.yjhTotal = parseFloat(this.zcmTotal.yjhTotal) + parseFloat(list[i].mounthPlan);
                  // this.zcmTotal.ywcTotal = parseFloat(this.zcmTotal.yjhTotal) + parseFloat(list[i].mounthActual);
                  // this.zcmTotal.ycqTotal = parseFloat(this.zcmTotal.yjhTotal) + parseFloat(list[i].mounthDiff);
								}

								if (type2 == "外购煤") {
									let flag = true;
									for (let j = 0; j < this.wgmList.length; j++) {
										if (this.wgmList[j].mk == name) {
											flag = false;
											if (type1 == "NUM") {
												this.wgmList[j].rwcl = list[i].dayActual;
												this.wgmList[j].yjhl = list[i].mounthPlan;
												this.wgmList[j].ywcl = list[i].mounthActual;
												this.wgmList[j].ycql = list[i].mounthDiff;
											}
											if (type1 == "AMOUNT") {
												this.wgmList[j].rwcd = list[i].dayActual;
												this.wgmList[j].yjhd = list[i].mounthPlan;
												this.wgmList[j].ywcd = list[i].mounthActual;
												this.wgmList[j].ycqd = list[i].mounthDiff;
											}
											break;
										}
									}
									if (flag) {
										if (type1 == "NUM") {
											obj.rwcl = list[i].dayActual;
											obj.yjhl = list[i].mounthPlan;
											obj.ywcl = list[i].mounthActual;
											obj.ycql = list[i].mounthDiff;
										}
										if (type1 == "AMOUNT") {
											obj.rwcd = list[i].dayActual;
											obj.yjhd = list[i].mounthPlan;
											obj.ywcd = list[i].mounthActual;
											obj.ycqd = list[i].mounthDiff;
										}
										this.wgmList.push(obj);
									}
								}
							}
              console.log(JSON.stringify(this.zcmList));
							console.log(this.zcmTotal);
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
							interval: function(index, value) {
								if (
									value == "00:00" ||
									value == "02:00" ||
									value == "04:00" ||
									value == "06:00" ||
									value == "08:00" ||
									value == "10:00" ||
									value == "12:00" ||
									value == "14:00" ||
									value == "16:00" ||
									value == "18:00" ||
									value == "20:00" ||
									value == "22:00" ||
									value == "24:00"
								) {
									return true;
								}
								return false;
							},
							formatter: (value, index) => {
								return value.substr(0, 2);
							},
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
								},
								{
									silent: false, //鼠标悬停事件  true没有，false有
									lineStyle: {
										//警戒线的样式  ，虚实  颜色
										type: "solid",
										color: "#FF8C00"
									},
									label: {
										position: "middle"
									},
									yAxis: 0.5 // 警戒线的标注值，可以有多个yAxis,多条警示线   或者采用   {type : 'average', name: '平均值'}，type值有  max  min  average，分为最大，最小，平均值
								}
							]
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
							interval: function(index, value) {
								if (
									value == "00:00" ||
									value == "02:00" ||
									value == "04:00" ||
									value == "06:00" ||
									value == "08:00" ||
									value == "10:00" ||
									value == "12:00" ||
									value == "14:00" ||
									value == "16:00" ||
									value == "18:00" ||
									value == "20:00" ||
									value == "22:00" ||
									value == "24:00"
								) {
									return true;
								}
								return false;
							},
							formatter: (value, index) => {
								return value.substr(0, 2);
							},
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
								},
								{
									silent: false, //鼠标悬停事件  true没有，false有
									lineStyle: {
										//警戒线的样式  ，虚实  颜色
										type: "solid",
										color: "#FF8C00"
									},
									label: {
										position: "middle"
										// formatter:"优秀(350)",
										// fontSize:'8'
									},
									yAxis: 24 // 警戒线的标注值，可以有多个yAxis,多条警示线   或者采用   {type : 'average', name: '平均值'}，type值有  max  min  average，分为最大，最小，平均值
								}
							]
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
							interval: function(index, value) {
								if (
									value == "00:00" ||
									value == "02:00" ||
									value == "04:00" ||
									value == "06:00" ||
									value == "08:00" ||
									value == "10:00" ||
									value == "12:00" ||
									value == "14:00" ||
									value == "16:00" ||
									value == "18:00" ||
									value == "20:00" ||
									value == "22:00" ||
									value == "24:00"
								) {
									return true;
								}
								return false;
							},
							formatter: (value, index) => {
								return value.substr(0, 2);
							},
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

				axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/gasmonitoring`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							let timeData = [];
							var dates = res.data.date;
							for (var i = 0; i < dates.length; i++) {
								var date = dates[i];
								var substr = date.substr(11, 5);
								timeData.push(substr);
							}
							var curStr = dates[dates.length - 1];
							var curStr = curStr.substr(0, 17) + "00";
							var curDate = new Date(curStr);
							var minNum =
								24 * 60 -
								(parseInt(curStr.substr(11, 2)) * 60 +
									parseInt(curStr.substr(14, 2)));
							for (var i = 0; i < minNum * 2; i++) {
								curDate = new Date(curDate.getTime() + 1000 * 30);
								var hour = curDate.getHours();
								if (hour < 10) hour = "0" + hour;
								var minute = curDate.getMinutes();
								if (minute < 10) minute = "0" + minute;
								var addStr = hour + ":" + minute;
								timeData.push(addStr);
							}
							timeData.push("24:00");
							//CH4
							ch4Option.xAxis.data = timeData;
							ch4Option.series[0].data = res.data.ch4;
							var flag = true;
							for (var i = 0; i < res.data.ch4.length; i++) {
								var data = res.data.ch4[i];
								if (data > 1) {
									flag = false;
									break;
								}
							}
							if (flag) ch4Option.yAxis.max = 1;
							ch4Line.setOption(ch4Option);

							//CO
							coOption.xAxis.data = timeData;
							coOption.series[0].data = res.data.co;
							var flag = true;
							for (var i = 0; i < res.data.co.length; i++) {
								var data = res.data.co[i];
								if (data > 80) {
									flag = false;
									break;
								}
							}
							if (flag) coOption.yAxis.max = 80;
							coLine.setOption(coOption);

							//O2
							o2Option.xAxis.data = timeData;
							o2Option.series[0].data = res.data.o2;
							o2Line.setOption(o2Option);
						}
					});
			},
			//井工矿人员车辆信息
			loadJgkrycl() {
				axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/GsjsMkryclxx`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							var data = res.data.jgk[0];
							this.jgk.jxry = data.staffNum;
							this.jgk.jxcl = data.carNum;
							this.jgk.gsld = data.cleaderNum;
							this.jgk.kjld = data.oleaderNum;
						}
					});
			},
			async loadZsyx() {
				//三道沟
				await axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/GsjsZsSdg`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							var list = res.data.list;
							for (var i = 0; i < list.length; i++) {
								var record = list[i];
								var name = record.name;
								if (name == null) {
									var fanList = record.fanList;
									var map = new Map(); //存放煤矿名称及详细信息
									for (var j = 0; j < fanList.length; j++) {
										var fan = fanList[j];
										var mkjkName = fan.mkjkName;
										var senName = fan.senName;
										// var motorName = fan.motorName;
										var fanName = "";
										var status = fan.status;
										if (fan.fanName == "1#") {
											fanName = "#1";
										}
										if (fan.fanName == "2#") {
											fanName = "#2";
										}

										var obj = {
											mkjkName: "", //煤矿名称
											fan: [] //点击
										};
										if (
											mkjkName == "三道沟煤矿" &&
											senName.indexOf("朴牛圪塔") > -1
										) {
											obj.mkjkName = "三道沟煤矿-朴牛圪塔";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}

										if (
											mkjkName == "三道沟煤矿" &&
											senName.indexOf("大路墕") > -1
										) {
											obj.mkjkName = "三道沟煤矿-大路墕";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}
									}
								}
							}
						}
					});
				//黄玉川
				await axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/GsjsZsHyc`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							var list = res.data.list;
							for (var i = 0; i < list.length; i++) {
								var record = list[i];
								var name = record.name;
								if (name == null) {
									var fanList = record.fanList;
									var map = new Map(); //存放煤矿名称及详细信息
									for (var j = 0; j < fanList.length; j++) {
										var fan = fanList[j];
										var mkjkName = fan.mkjkName;
										var senName = fan.senName;
										// var motorName = fan.motorName;
										var fanName = "";
										var status = fan.status;
										if (fan.fanName == "1#") {
											fanName = "#1";
										}
										if (fan.fanName == "2#") {
											fanName = "#2";
										}

										var obj = {
											mkjkName: "", //煤矿名称
											fan: [] //点击
										};
										if (
											mkjkName == "黄玉川煤矿" &&
											senName.indexOf("一水平") > -1
										) {
											obj.mkjkName = "黄玉川煤矿-一水平";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}

										if (
											mkjkName == "黄玉川煤矿" &&
											senName.indexOf("二水平") > -1
										) {
											obj.mkjkName = "黄玉川煤矿-二水平";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}
									}
								}
							}
						}
					});

				//沙吉海
				await axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/GsjsZsSjh`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							var list = res.data.list;
							for (var i = 0; i < list.length; i++) {
								var record = list[i];
								var name = record.name;
								if (name == null) {
									var fanList = record.fanList;
									var map = new Map(); //存放煤矿名称及详细信息
									for (var j = 0; j < fanList.length; j++) {
										var fan = fanList[j];
										var mkjkName = fan.mkjkName;
										var senName = fan.senName;
										// var motorName = fan.motorName;
										var fanName = "";
										var status = fan.status;
										if (fan.fanName == "1#") {
											fanName = "#1";
										}
										if (fan.fanName == "2#") {
											fanName = "#2";
										}

										var obj = {
											mkjkName: "", //煤矿名称
											fan: [] //点击
										};
										if (mkjkName == "沙吉海煤矿") {
											obj.mkjkName = "沙吉海煤矿";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}
									}
								}
							}
						}
					});

				//敏东一矿
				await axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/GsjsZsMd1`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							var list = res.data.list;
							for (var i = 0; i < list.length; i++) {
								var record = list[i];
								var name = record.name;
								if (name == null) {
									var fanList = record.fanList;
									var map = new Map(); //存放煤矿名称及详细信息
									for (var j = 0; j < fanList.length; j++) {
										var fan = fanList[j];
										var mkjkName = fan.mkjkName;
										var senName = fan.senName;
										// var motorName = fan.motorName;
										var fanName = "";
										var status = fan.status;
										if (fan.fanName == "1#") {
											fanName = "#1";
										}
										if (fan.fanName == "2#") {
											fanName = "#2";
										}

										var obj = {
											mkjkName: "", //煤矿名称
											fan: [] //点击
										};
										if (mkjkName == "敏东一矿") {
											obj.mkjkName = "敏东一矿";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}
									}
								}
							}
						}
					});

				//上榆泉煤矿
				await axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/GsjsZsSyq`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							var list = res.data.list;
							for (var i = 0; i < list.length; i++) {
								var record = list[i];
								var name = record.name;
								if (name == null) {
									var fanList = record.fanList;
									var map = new Map(); //存放煤矿名称及详细信息
									for (var j = 0; j < fanList.length; j++) {
										var fan = fanList[j];
										var mkjkName = fan.mkjkName;
										var senName = fan.senName;
										// var motorName = fan.motorName;
										var fanName = "";
										var status = fan.status;
										if (fan.fanName == "1#") {
											fanName = "#1";
										}
										if (fan.fanName == "2#") {
											fanName = "#2";
										}

										var obj = {
											mkjkName: "", //煤矿名称
											fan: [] //点击
										};
										if (mkjkName == "上榆泉煤矿") {
											obj.mkjkName = "上榆泉煤矿";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}
									}
								}
							}
						}
					});

				//大南湖一矿
				await axios
					.get(
						`${
            this.$config.YDMHEJYY
          }httpRequest/getRequestResult?apiUrl=/gsjs/GsjsZsDnh1`, {
							params: {}
						}
					)
					.then(res => {
						if (res.success) {
							var list = res.data.list;
							for (var i = 0; i < list.length; i++) {
								var record = list[i];
								var name = record.name;
								if (name == null) {
									var fanList = record.fanList;
									var map = new Map(); //存放煤矿名称及详细信息
									for (var j = 0; j < fanList.length; j++) {
										var fan = fanList[j];
										var mkjkName = fan.mkjkName;
										var senName = fan.senName;
										// var motorName = fan.motorName;
										var fanName = "";
										var status = fan.status;
										if (fan.fanName == "1#") {
											fanName = "#1";
										}
										if (fan.fanName == "2#") {
											fanName = "#2";
										}

										var obj = {
											mkjkName: "", //煤矿名称
											fan: [] //点击
										};
										if (mkjkName == "大南湖一矿") {
											obj.mkjkName = "大南湖一矿";
											if (map.get(obj.mkjkName) != null) {
												//判断是否存在相同煤矿
												let fan = map.get(obj.mkjkName).fan;
												let flag = true;
												fan.forEach(item => {
													if (item.fanName == fanName) {
														//存在相同电机，只需更新状态
														item.status.push(status);
														flag = false;
													}
												});
												if (flag) {
													//不存在相同电机，添加电机名称及状态
													var obj1 = {
														fanName: "",
														status: []
													};
													obj1.fanName = fanName;
													obj1.status.push(status);
													fan.push(obj1);
												}
											} else {
												var obj1 = {
													fanName: "",
													status: []
												}; //电机及状态
												obj1.fanName = fanName;
												obj1.status.push(status);
												obj.fan.push(obj1);
												this.zsyxList.push(obj);
												map.set(obj.mkjkName, obj);
											}
										}
									}
								}
							}
						}
					});
			}
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
		font-size: 1.8rem;
		font-weight: 700;
		color: #fff;
		font-family: arial;
		margin-bottom: 0.2rem;
	}

	.tbox ul li h4 {
		font-size: 15px;
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

	.tab-content {
		overflow-y: hidden;
	}

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

	.con {
		background: #eff8ff;
		border: 1px solid #e5e6e8;
		padding: 0.5rem;
		border-radius: 5px;
	}

	.list {}

	.list ul {}

	.list ul li {
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
		font-size: 13px;
	}

	.lb td strong {
		font-size: 14px;
		font-weight: 700;
		color: #5c5c5c;
	}
	.lb th{
		font-size: 15px;
		font-weight: 700;
		color: #5c5c5c;
	}
	.lb tr{
		width: 100%;
	}

	.biaoti {
		font-size: 14px;
		font-weight: 700;
		color: #5c5c5c;
		margin: 20px 0px 10px 0px;
		// padding-left: 28px;
		// line-height: 30px;
		// background: url("../../assets/images/huoche.png") no-repeat 0px 3px;
		// background-size: 25px;
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
	
	.fs-img-wrap{
		width: 20px;
		height: 20px;
	}
</style>
