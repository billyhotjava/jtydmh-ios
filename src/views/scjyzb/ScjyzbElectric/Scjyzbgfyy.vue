<template>
	<div style="width: 100%;overflow-x: hidden;">
		<div class="main">
			<div class="tab-content">
				<div class="tit" style="text-align: center">
					<h3>{{title}}</h3>
				</div>
				<div class="con clearfix">
					<div class="xp">
						<ul>
							<li v-if="title.indexOf('光伏') !== -1">
								<p>{{ssfhsz.radiation}}<span>{{"W/m"}}</span></p>
								<h4>实时辐照度</h4>
							</li>
							<li v-else>
								<p>{{ssfhsz.avgSpeed}}<span>{{"W/m"}}</span></p>
								<h4>全场平均风速</h4>
							</li>
							<li>
								<p>{{ssfhsz.realTimePower}}<span>{{"MW"}}</span></p>
								<h4>实时功率</h4>
							</li>
							<li>
								<p>{{(ssfhsz.todayTotal)}}<span>{{"万千瓦时"}}</span></p>
								<h4>今日累计电量</h4>
							</li>
							<li>
								<p>{{ssfhsz.todayPlan}}<span>{{"万千瓦时"}}</span></p>
								<h4>今日预计完成</h4>
							</li>
							<li>
								<p>{{ssfhsz.yearRedudion}}<span>{{"万吨"}}</span></p>
								<h4>年度减排CO2</h4>
							</li>
							<li>
								<p>{{ssfhsz.yearSave}}<span>{{"万吨"}}</span></p>
								<h4>年度节标煤</h4>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>实时负荷曲线</h4>
				</div>
				<div style="text-align:center;height:220px;width:100%" ref="myChartgfssqx"></div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>今日运行状态</h4>
				</div>
				<div class="con-ssyx clearfix">
					<div class="con-yxzt-zs clearfix con-clearfix-border-zs">
						<div class="yxzs">
							<ul>
								<li v-if="title.indexOf('光伏') !== -1">
									<p>{{jryxzt.inverterNum}}<span>{{"台"}}</span></p>
									<h4>逆变器台数</h4>
								</li>
								<li v-else>
									<p>{{jryxzt.windNum}}<span>{{"台"}}</span></p>
									<h4>风电台数</h4>
								</li>
								<li>
									<p>{{jryxzt.installedCapacity}}<span>{{"MW"}}</span></p>
									<h4>装机容量</h4>
								</li>
							</ul>
						</div>
					</div>
					<div class="con-yxzt-gs clearfix con-clearfix-border-gt" style="padding: 0px 10px">
						<div class="yxgt">
							<ul style="display: flex;justify-content: space-between; flex-wrap: wrap">
								<li v-for="(item, index) in jryxzt.list" :key="index" v-if="item.status !== '停机'">
									<div class="yxgt-yx">
										<img v-if="item.status == '运行'" src="../../../assets/images/scjyzb/yx.png">
										<img v-if="item.status == '待机'" src="../../../assets/images/scjyzb/dj.png">
										<img v-if="item.status == '故障'" src="../../../assets/images/scjyzb/gz.png">
										<img v-if="item.status == '中断'" src="../../../assets/images/scjyzb/zd.png">
										<p style="text-align: center">{{item.status}}</p>
									</div>
									<div class="yxgt-sl">
										<div>
											<h4>容量</h4>
											<p style="text-align: center">{{item.capacity}}</p>
											<span style="text-align: right">MW</span>
										</div>
										<div style="margin-top: 6px;">
											<h4>台数</h4>
											<p style="text-align: center">{{item.num}}</p>
											<span style="text-align: right">台</span>
										</div>
									</div>
								</li>
								<!--                                <li>-->
								<!--                                    <div class="yxgt-yx">-->
								<!--                                        <img src="../../../assets/images/scjyzb/dj.png">-->
								<!--                                        <p style="">待机</p>-->
								<!--                                    </div>-->
								<!--                                    <div class="yxgt-sl">-->
								<!--                                        <div>-->
								<!--                                            <h4>容量</h4>-->
								<!--                                            <p>{{10}}</p>-->
								<!--                                            <span>MW</span>-->
								<!--                                        </div>-->
								<!--                                        <div>-->
								<!--                                            <h4>台数</h4>-->
								<!--                                            <p>{{10}}</p>-->
								<!--                                            <span>台</span>-->
								<!--                                        </div>-->
								<!--                                    </div>-->
								<!--                                </li>-->
								<!--                                <li>-->
								<!--                                    <div class="yxgt-yx">-->
								<!--                                        <img src="../../../assets/images/scjyzb/gz.png">-->
								<!--                                        <p style="">故障</p>-->
								<!--                                    </div>-->
								<!--                                    <div class="yxgt-sl">-->
								<!--                                        <div>-->
								<!--                                            <h4>容量</h4>-->
								<!--                                            <p>{{10}}</p>-->
								<!--                                            <span>MW</span>-->
								<!--                                        </div>-->
								<!--                                        <div>-->
								<!--                                            <h4>台数</h4>-->
								<!--                                            <p>{{10}}</p>-->
								<!--                                            <span>台</span>-->
								<!--                                        </div>-->
								<!--                                    </div>-->
								<!--                                </li>-->
								<!--                                <li>-->
								<!--                                    <div class="yxgt-yx">-->
								<!--                                        <img src="../../../assets/images/scjyzb/zd.png">-->
								<!--                                        <p style="">中断</p>-->
								<!--                                    </div>-->
								<!--                                    <div class="yxgt-sl">-->
								<!--                                        <div>-->
								<!--                                            <h4>容量</h4>-->
								<!--                                            <p>{{10}}</p>-->
								<!--                                            <span>MW</span>-->
								<!--                                        </div>-->
								<!--                                        <div>-->
								<!--                                            <h4>台数</h4>-->
								<!--                                            <p>{{10}}</p>-->
								<!--                                            <span>台</span>-->
								<!--                                        </div>-->
								<!--                                    </div>-->
								<!--                                </li>-->
							</ul>
						</div>
					</div>
				</div>
			</div>

			<div class="tab-content">
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
				<!-- <div class="con clearfix">
					<div class="fdlwc">
						<ul>
							<li>
								<h4>本月预计完成</h4>
							</li>
							<li>
								<p>{{fdlwcqk.monthPlan}}<span>{{"万千瓦时"}}</span></p>
							</li>
						</ul>
					</div>
				</div> -->
				<!-- <div style="text-align:center;height:220px;width:100%; margin-top: 20px" ref="myChartfdwcqk"></div> -->
        <!--   去掉饼状图   -->
<!--				<div class="con clearfix">-->
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
<!--				<div class="con clearfix" style="margin-top: 15px">-->
<!--					<div class="wctype">-->
<!--						<p class="wctypep">{{fdlwcqkryny.type}}<span class="wctypespan">{{getUnit()}}</span></p>-->
<!--					</div>-->
<!--					<div style="width: 100%; display: flex">-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdMouthWclPie"></div>-->
<!--						<div style="text-align:center;height:180px;width:50%" ref="fdMouthTbPie"></div>-->
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
<!--				<div class="con clearfix" style="margin-top: 15px">-->
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
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>经济性指标</h4>
				</div>
				<div class="con-ssyx clearfix" style="overflow: hidden">
					<div class="con-yxzt-zs clearfix con-clearfix-border-zs">
						<div class="ndsczb" style="margin-top: 21px; margin-bottom: 21px">
							<ul>
								<li style="width: 60%;">
									<h4 style="width: 30%;">年累计</h4>
									<p style="width: 70%;">{{ndsczbYearTotal}}<span>{{"万kwh"}}</span></p>
								</li>
								<li style="width: 40%;margin-left: auto;margin-right: 18px;">
									<h4 style="width: 40%;">同比</h4>
									<p style="width: 50%;margin-left: 18px">{{ndsczbPeriodTotal}}<span>{{"%"}}</span></p>
								</li>
							</ul>
						</div>
					</div>
					<div class="con-yxzt-gs clearfix con-clearfix-border-gt" style="margin-top: 18px">
						<div style="margin-left: 24px">
							<button id="xdl" @click="getXdl()" class="xdl">{{ndsczbXdl.type}}</button>
							<button id="qgl" @click="getQgl()" class="qgl">{{ndsczbQgl.type}}</button>
						</div>
						<div style="text-align:center;height:220px;width:100%; margin-top: 20px" ref="myChartNdsczb">
						</div>
					</div>
				</div>
			</div>

			<div class="tab-content">
				<div class="tit">
					<h4>可利用率及厂用电率</h4>
				</div>
				<!--                <div class="gdmhjcydl-div" v-if="title.indexOf('光伏') !== -1">-->
				<div class="gdmhjcydl-div">
					<div class="gdmhjcydl-gdmh-div">
						<div class="gdmhjcydl-icon-div">
							<img src="../../../assets/images/scjyzb/klyl.png" style="width: 30px;height: 30px">
						</div>
						<div class="gdmhjcydl-bottom-line-div">
							<div class="gdmhjcydl-bottom-line-title-div">可利用率</div>
							<div style="display: flex; margin-left: auto">
								<div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.availability}}</div>
								<div class="gdmhjcydl-bottom-line-unit-div">%</div>
							</div>
						</div>
						<div class="gdmhjcydl-bottom-line-div">
							<div class="gdmhjcydl-bottom-line-title-div">同<span
									style="color: transparent">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>比</div>
							<div style="display: flex; margin-left: auto">
								<div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.avaOnYear}}</div>
								<div class="gdmhjcydl-bottom-line-unit-div">%</div>
							</div>
						</div>
					</div>
					<div class="gdmhjcydl-ydl-div">
						<div class="gdmhjcydl-icon-div">
							<img src="../../../assets/images/scjyzb/cydl.png" style="width: 30px;height: 30px">
						</div>
						<div class="gdmhjcydl-bottom-line-div">
							<div class="gdmhjcydl-bottom-line-title-div">综合厂用电率</div>
							<div style="display: flex; margin-left: auto">
								<div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.powerRate}}</div>
								<div class="gdmhjcydl-bottom-line-unit-div">%</div>
							</div>
						</div>
						<div class="gdmhjcydl-bottom-line-div">
							<div class="gdmhjcydl-bottom-line-title-div">同<span
									style="color: transparent">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>比
							</div>
							<div style="display: flex; margin-left: auto">
								<div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.powerRateOnYear}}</div>
								<div class="gdmhjcydl-bottom-line-unit-div">%</div>
							</div>
						</div>
					</div>
				</div>
				<!--              <div class="gdmhjcydl-div" v-else>-->
				<!--                <div class="gdmhjcydl-gdmh-div">-->
				<!--                  <div class="gdmhjcydl-icon-div">-->
				<!--                    <img class="gdmhjcydl-icon" src="../../../assets/images/scjyzb/klyl.png">-->
				<!--                    <div class="gdmhjcydl-icon-title-div">供电煤耗</div>-->
				<!--                  </div>-->
				<!--                  <div class="gdmhjcydl-bottom-line-div">-->
				<!--                    <div class="gdmhjcydl-bottom-line-title-div">煤耗</div>-->
				<!--                    <div style="display: flex; margin-left: auto">-->
				<!--                      <div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.occupancy}}</div>-->
				<!--                      <div class="gdmhjcydl-bottom-line-unit-div">万吨</div>-->
				<!--                    </div>-->
				<!--                  </div>-->
				<!--                  <div class="gdmhjcydl-bottom-line-div">-->
				<!--                    <div class="gdmhjcydl-bottom-line-title-div">同比</div>-->
				<!--                    <div style="display: flex; margin-left: auto">-->
				<!--                      <div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.occOnYear}}</div>-->
				<!--                      <div class="gdmhjcydl-bottom-line-unit-div">g/kwh</div>-->
				<!--                    </div>-->
				<!--                  </div>-->
				<!--                </div>-->
				<!--                <div class="gdmhjcydl-ydl-div">-->
				<!--                  <div class="gdmhjcydl-icon-div">-->
				<!--                    <img class="gdmhjcydl-icon" src="../../../assets/images/scjyzb/cydl.png">-->
				<!--                    <div class="gdmhjcydl-icon-title-div">综合厂用电率</div>-->
				<!--                  </div>-->
				<!--                  <div class="gdmhjcydl-bottom-line-div">-->
				<!--                    <div class="gdmhjcydl-bottom-line-title-div">煤耗</div>-->
				<!--                    <div style="display: flex; margin-left: auto">-->
				<!--                      <div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.powerRate}}</div>-->
				<!--                      <div class="gdmhjcydl-bottom-line-unit-div">%</div>-->
				<!--                    </div>-->
				<!--                  </div>-->
				<!--                  <div class="gdmhjcydl-bottom-line-div">-->
				<!--                    <div class="gdmhjcydl-bottom-line-title-div">同比</div>-->
				<!--                    <div style="display: flex; margin-left: auto">-->
				<!--                      <div class="gdmhjcydl-bottom-line-value-div">{{klyljcydl.powerRateOnYear}}</div>-->
				<!--                      <div class="gdmhjcydl-bottom-line-unit-div">%</div>-->
				<!--                    </div>-->
				<!--                  </div>-->
				<!--                </div>-->
				<!--              </div>-->
			</div>
		</div>
	</div>
</template>

<script>
	import * as echarts from 'echarts';
	export default {
		name: "Scjyzbgfyy",
		props: {
			proId: Number,
			title: {
				type: String,
				default: ''
			}
		},
		data() {
			return {
				// 实时负荷数值
				ssfhsz: {},
				// 今日运行状态
				jryxzt: {},
				// 发电量完成情况
				fdlwcqk: {},
				// 日月年
				fdlwcqkrynr: {},
				fdlwcqkryny: {},
				fdlwcqkrynn: {},
        fdlwcqkTableData:[],
				// 年度生产指标
				ndsczb: {},
				ndsczbXdl: {},
				ndsczbQgl: {},
				ndsczbYearTotal: '',
				ndsczbPeriodTotal: '',
				klyljcydl: {},
			}
		},
		mounted() {
			this.reloadAllData();
		},
		methods: {
			getUnit(){
				if (this.title.indexOf('光伏') != -1) {
					return '万千瓦时';
				}else{
					return '亿千瓦时';
				}	
			},
			reloadAllData() {
				this.getLoadSummData();
				setTimeout(() => {
					this.getLoadCurveData();
				}, 1000);
				setTimeout(() => {
					this.getRunStatus();
					this.getPowerCompletion();
				}, 2000);
				setTimeout(() => {
					this.getCompletionRate();
					this.getEconomic();
				}, 2000);
				setTimeout(() => {
					this.getProduction();
				}, 3000);
			},
			// 实时负荷数值
			getLoadSummData() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/${this.title.indexOf('光伏') !== -1 ? 'pv' : 'winPlant'}/v1/getLoadSummData`,
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					this.ssfhsz = res.data;
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
			},
			//实时负荷曲线接口
			getLoadCurveData() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/${this.title.indexOf('光伏') !== -1 ? 'pv' : 'winPlant'}/v1/getLoadCurveData`,
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					this.getssfh(this.title.indexOf('光伏') !== -1 ? res.data : res.data.list[0]);
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
			},
			//实时负荷曲线
			getssfh(info) {
				var series = [];
				series.push({
					name: '昨日功率',
					type: 'line',
					data: this.title.indexOf('光伏') !== -1 ? info.yPower : info.ypower,
					symbol: 'none'
				});
				series.push({
					name: '今日功率',
					type: 'line',
					data: this.title.indexOf('光伏') !== -1 ? info.tPower : info.tpower,
					symbol: 'none'
				});
				let name1 = this.title.indexOf('光伏') !== -1 ? '昨日辐照度' : '昨日风速';
				series.push({
					name: name1,
					type: 'line',
					data: this.title.indexOf('光伏') !== -1 ? info.yRadiation : info.ywindSpeed,
					symbol: 'none'
				});
				let name2 = this.title.indexOf('光伏') !== -1 ? '今日辐照度' : '今日风速';
				series.push({
					name: name2,
					type: 'line',
					data: this.title.indexOf('光伏') !== -1 ? info.tRadiation : info.twindSpeed,
					symbol: 'none'
				});
				this.loadSsfhqx(this.title.indexOf('光伏') !== -1 ? info.xData : info.xdata, series);
			},
			//实时负荷曲线
			loadSsfhqx(data, series) {
				let dataList = this.title.indexOf('光伏') !== -1 ? ['昨日功率', '今日功率', '昨日辐照度', '今日辐照度'] : ['昨日功率', '今日功率',
					'昨日风速', '今日风速'
				];
				let myChartgfssqx = echarts.init(this.$refs.myChartgfssqx);
				myChartgfssqx.clear();
				var options = {
					tooltip: {
						trigger: 'axis',
						axisPointer: {
							type: 'shadow'
						}
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
						data: dataList,
						width: '100%', // 图例组件的宽度
						textStyle: {
							fontSize: 10, // 文字的字体大小。
						},
					},
					xAxis: {
						type: 'category',
						boundaryGap: false,
						data: data
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
			// 今日运行状态
			getRunStatus() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/${this.title.indexOf('光伏') !== -1 ? 'pv' : 'winPlant'}/v1/getRunStatus`,
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					console.log('res.data=========', res.data);
					this.jryxzt = res.data;
					var yxCount = 0;
					var djCount = 0;
					var gzCount = 0;
					var zdCount = 0;
					var item = {
						capacity: 10,
						num: 20,
						status: "运行",
					};
					if (res.data.list.length < 5) {
						for (var i = 0; i < res.data.list.length; i++) {
							if (res.data.list[i].status == '运行') {
								yxCount += 1;
							} else if (res.data.list[i].status == '待机') {
								djCount += 1;
							} else if (res.data.list[i].status == '故障') {
								gzCount += 1;
							} else if (res.data.list[i].status == '中断') {
								zdCount += 1;
							}
						}
					}
					if (yxCount == 0) {
						var item = {
							capacity: 0,
							num: 0,
							status: "运行",
						};
						res.data.list.push(item)
					}
					if (djCount == 0) {
						var item = {
							capacity: 0,
							num: 0,
							status: "待机",
						};
						res.data.list.push(item)
					}
					if (gzCount == 0) {
						var item = {
							capacity: 0,
							num: 0,
							status: "故障",
						};
						res.data.list.push(item)
					}
					if (zdCount == 0) {
						var item = {
							capacity: 0,
							num: 0,
							status: "中断",
						};
						res.data.list.push(item)
					}
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
			},
			//发电量完成情况
			getPowerCompletion() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/${this.title.indexOf('光伏') !== -1 ? 'pv' : 'winPlant'}/v1/getPowerCompletion`,
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					this.fdlwcqk = res.data.list;
					// this.getFdlwc();
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
			},

			getFdlwc() {
				var series = [];
				series.push({
					name: '本月',
					type: 'line',
					data: this.fdlwcqk.month,
					symbol: 'none'
				});
				series.push({
					name: '同期',
					type: 'line',
					data: this.fdlwcqk.period,
					symbol: 'none'
				});
				series.push({
					name: '计划',
					type: 'line',
					data: this.fdlwcqk.dayAvgPlan,
					symbol: 'none'
				});
				series.push({
					name: '需发',
					type: 'line',
					data: this.fdlwcqk.dayAvgNeed,
					symbol: 'none'
				});
				this.loadFdlwcqx(this.fdlwcqk.xdata, series);
			},
			//
			// 发电量完成日月年
			getCompletionRate() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/${this.title.indexOf('光伏') !== -1 ? 'pv' : 'winPlant'}/v1/getCompletionRate`,
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
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
					// this.setFdlwcqkRYN();
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
			},
			// 发电量完成情况日月年图表
			setFdlwcqkRYN() {
				this.LoadDayFdwclCircle();
				this.LoadDayFdtbCircle();
				this.LoadMouthFdwclCircle();
				this.LoadMouthFdtbCircle();
				this.LoadYearFdwclCircle();
				this.LoadYearFdtbCircle();
			},
			//发电量完成情况 图
			loadFdlwcqx(data, series) {
				let myChartfdwcqk = echarts.init(this.$refs.myChartfdwcqk);
				myChartfdwcqk.clear();
				var options = {
					tooltip: {
						trigger: 'axis',
						axisPointer: {
							type: 'shadow'
						}
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
						data: data
					},
					yAxis: {
						type: 'value',
						axisLine: {
							show: true
						},
					},
					series: series
				};
				myChartfdwcqk.setOption(options);
			},
			//发电量完成情况(日完成率)
			LoadDayFdwclCircle() {
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
							fontSize: 9,
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
			//发电量完成情况(日同比)
			LoadDayFdtbCircle() {
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
							fontSize: 9,
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
			//发电量完成情况(月完成率)
			LoadMouthFdwclCircle() {
				let fdDayWclPie = echarts.init(this.$refs.fdMouthWclPie);
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
							fontSize: 9,
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
			//发电量完成情况(月同比)
			LoadMouthFdtbCircle() {
				let fdDayTbPie = echarts.init(this.$refs.fdMouthTbPie);
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
							fontSize: 9,
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
			//发电量完成情况(年完成率)
			LoadYearFdwclCircle() {
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
							fontSize: 9,
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
			//发电量完成情况(年同比)
			LoadYearFdtbCircle() {
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
							fontSize: 9,
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
			// 年度生产指标
			getProduction() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/${this.title.indexOf('光伏') !== -1 ? 'pv' : 'winPlant'}/v1/getProduction`,
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					this.ndsczb = res.data;
					this.ndsczbXdl = res.data.list[0];
					this.ndsczbQgl = res.data.list[1];
					this.getXdl();
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
			},
			//年度生产指标（限电量）
			getXdl() {
				this.ndsczbYearTotal = this.ndsczbXdl.yearTotal;
				this.ndsczbPeriodTotal = this.ndsczbXdl.periodTotal;
				document.getElementById("xdl").style.borderBottom = '4px solid #216DEA';
				document.getElementById("qgl").style.borderBottom = '4px solid transparent';
				document.getElementById("xdl").style.color = '#216DEA';
				document.getElementById("qgl").style.color = '#7E7E7E';
				this.loadNdsczb(this.ndsczbXdl);
			},
			//年度生产指标（弃光率）
			getQgl() {
				this.ndsczbYearTotal = this.ndsczbQgl.yearTotal;
				this.ndsczbPeriodTotal = this.ndsczbQgl.periodTotal;
				document.getElementById("xdl").style.borderBottom = '4px solid transparent';
				document.getElementById("qgl").style.borderBottom = '4px solid #216DEA';
				document.getElementById("xdl").style.color = '#7E7E7E';
				document.getElementById("qgl").style.color = '#216DEA';
				this.loadNdsczb(this.ndsczbQgl);
			},
			loadNdsczb(info) {
				let myChartNdsczb = echarts.init(this.$refs.myChartNdsczb);
				myChartNdsczb.clear();
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
						data: this.ndsczb.xData,
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
							// rotate: 50,//倾斜度
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
							emphasis: {
								focus: 'series'
							},
							itemStyle: {
								normal: {
									color: '#FF8A00',
									barBorderRadius: [15, 15, 0, 0]
								}
							},
							data: info.period
						},
						{
							name: '数量',
							type: 'bar',
							emphasis: {
								focus: 'series'
							},
							itemStyle: {
								normal: {
									color: '#3179EE',
									barBorderRadius: [15, 15, 0, 0]
								}
							},
							data: info.year
						},
					]
				};
				myChartNdsczb.setOption(options);
			},
			// 可利用率及厂用电率
			getEconomic() {
				this.$postRequestNoDialog(`${this.$config.YDMH}httpRequest/obtainCommonRequestResult`, {
					url: `http://gsjs.sgeg.chnenergy.com.cn/gsdisplay/${this.title.indexOf('光伏') !== -1 ? 'pv' : 'winPlant'}/v1/getEconomic`,
					paramMap: {
						proId: this.proId
					}
				}).then(res => {
					this.klyljcydl = res.data;
				}).catch((error) => {
					this.$toast({
						message: error,
						className: 'inexa'
					});
					console.log(error);
				});
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

	.tit h3 {
		font-size: 15px;
		color: #5D5D5D;
		font-weight: 700;
		position: relative;
		padding-left: 12px;
		display: inline;
		margin-top: 10px
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

	.con-ssyx {
		background: #EFF8FF;
		border: 1px solid #e5e6e8;
		border-radius: 5px;

	}

	.con-yxzt-zs {
		background: #EFF8FF;
		border: 1px solid #e5e6e8;
		border-radius: 5px 5px 0 0;
	}

	.con-yxzt-gs {
		background: #EFF8FF;
		border: 1px solid #e5e6e8;
		border-radius: 0 0 5px 5px;
	}

	.con-clearfix-border-zs {
		border-top: 4px solid #EFF8FF;
		border-left: 4px solid #EFF8FF;
		border-right: 4px solid #EFF8FF;
		border-bottom: 1px solid #e5e6e8;
	}

	.con-clearfix-border-gt {
		border-top: 4px solid #EFF8FF;
		border-left: 4px solid #EFF8FF;
		border-right: 4px solid #EFF8FF;
		border-bottom: 0;
	}

	.xp {
		padding-top: 10px
	}

	.xp ul {}

	.xp ul li {
		float: left;
		text-align: center;
		width: 33.33%;
		margin-bottom: 10px
	}

	.xp ul li h4 {
		font-size: 12px;
		color: #656565;
		line-height: 1.5rem
	}

	.xp ul li p {
		font-size: 22px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.xp ul li span {
		font-size: 7.5px;
		color: #7F7F7F;
		font-family: arial;
		margin-bottom: .2rem;
		margin-left: 4.5px
	}

	.yxzs {
		padding-top: 10px
	}

	.yxzs ul {}

	.yxzs ul li {
		float: left;
		text-align: center;
		width: 50%;
		margin-bottom: 10px
	}

	.yxzs ul li h4 {
		font-size: 12px;
		color: #656565;
		line-height: 1.5rem
	}

	.yxzs ul li p {
		font-size: 24px;
		font-weight: 700;
		color: #333333;
		font-family: arial;
		margin-bottom: .2rem
	}

	.yxzs ul li span {
		font-size: 7.5px;
		color: #7F7F7F;
		font-family: arial;
		margin-bottom: .2rem;
		margin-left: 4.5px
	}

	.yxgt {
		padding-top: 10px;
	}

	.yxgt ul {}

	.yxgt ul li {
		width: 47%;
		float: left;
		display: flex;
		align-items: center;
		padding: 20px 0px;
		justify-content: center
	}

	.yxgt-yx {
		width: 30px;
	}

	.yxgt-yx img {
		width: 30px;
		height: 30px
	}

	.yxgt-yx p {
		font-size: 12px;
		color: #5D5D5D;
		margin-top: 4px;
		font-weight: 700
	}

	.yxgt-sl {
		width: 100%;
		margin-left: 10px;
		margin-top: 8px
	}

	.yxgt-sl div {
		display: flex;
		width: 100%;
		align-items: center;
		margin-bottom: 4px
	}

	.yxgt-sl div h4 {
		width: 33.33%;
		font-size: 12px;
		color: #656565;
	}

	.yxgt-sl div p {
		width: 33.33%;
		font-size: 15px;
		color: #000000;
		font-weight: 700;
	}

	.yxgt-sl div span {
		width: 33.33%;
		font-size: 8px;
    margin-top: 2px;
		color: #7F7F7F;
	}

	.fdlwc {
		padding-top: 10px
	}

	.fdlwc ul {}

	.fdlwc ul li {
		float: left;
		text-align: center;
		width: 50%;
		margin-bottom: 10px
	}

	.fdlwc ul li h4 {
		font-size: 14px;
		color: #535353;
		line-height: 1.5rem
	}

	.fdlwc ul li p {
		font-size: 20px;
		font-weight: 700;
		color: #000000;
		font-family: arial;
		margin-bottom: .2rem
	}

	.fdlwc ul li span {
		font-size: 9px;
		color: #535353;
		font-family: arial;
		margin-bottom: .2rem;
		margin-left: 4.5px
	}

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
		color: #D60000 !important
	}

  .biaoti {
    font-size: 12px;
    font-weight: 700;
    color: #5c5c5c;
    margin: 20px 0px 10px 0px;
  }

	.ndsczb {}

	.ndsczb ul {
		width: 100%;
		display: flex
	}

	.ndsczb ul li {
		display: flex;
		align-items: center
	}

	.ndsczb ul li h4 {
		font-size: 14px;
		color: #535353;
		margin-left: 14px
	}

	.ndsczb ul li p {
		font-size: 20px;
		color: #000;
		font-weight: 700;
	}

	.ndsczb ul li p span {
		font-size: 9px;
		color: #535353;
		margin-left: 8px
	}

	.xdl {
		font-weight: 700;
		font-size: 15px;
		background: transparent;
		background: transparent;
		padding-bottom: 7px;
	}

	.qgl {
		font-weight: 700;
		font-size: 15px;
		margin-left: 24px;
		background: transparent;
		padding-bottom: 7px;
		border-radius: 2px
	}

	.gdmhjcydl-div {
		background: #EEF6FE;
		border-radius: 10px;
		padding: 25px 10px;
		display: flex;
	}

	.gdmhjcydl-gdmh-div {
		display: flex;
		flex-direction: column;
		text-align: center;
		align-items: center;
		width: 50%;
		padding: 0px 10px;
	}

	.gdmhjcydl-ydl-div {
		display: flex;
		flex-direction: column;
		text-align: center;
		align-items: center;
		width: 50%;
		padding: 0px 10px;
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
		color: #5D5D5D;
		margin-top: 10px;
	}

	.gdmhjcydl-bottom-line-div {
		display: flex;
		width: 100%;
		align-items: center;
		padding-top: 20px;
	}

	.gdmhjcydl-bottom-line-title-div {
		font-size: 9px;
		color: #5D5D5D;
	}

	.gdmhjcydl-bottom-line-value-div {
		font-size: 18px;
		margin-left: auto;
		font-weight: 700
	}

	.gdmhjcydl-bottom-line-unit-div {
		font-size: 7.5px;
		transform: scale(0.7);
		margin-left: auto;
		margin-top: 6px;
		color: #7F7F7F
	}
</style>
