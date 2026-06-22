<template>
	<div style="width: 100%;overflow-x: hidden;">
    <div class="tab-header">
      <mt-header title="煤矿实时数据">
        <a href="javascript:;" slot="left" @click="$router.back(-1 )">
          <mt-button icon="back"/>
        </a>
      </mt-header>
    </div>

    <div class="tbox clearfix">
      <ul>
        <li><p>{{topInfo.num1}}</p><h4 class="red0">呼救</h4></li>
        <li><p>{{topInfo.num2}}</p><h4 class="orange">报警</h4></li>
        <li><p>{{topInfo.num3}}</p><h4 class="yellow">断网</h4></li>
        <li><p>{{topInfo.num4}}</p><h4>故障</h4></li>
        <li><p>{{topInfo.num5}}</p><h4>井下人员</h4></li>
        <li><p>{{topInfo.num6}}</p><h4>井下车辆</h4></li>
        <li><p>{{topInfo.num7}}</p><h4>井下领导</h4></li>
        <li><p>{{topInfo.num8}}</p><h4>安全测点</h4></li>
      </ul>
    </div>

    <div class="main">

      <div class="tab-content">
        <div class="tit"><h4>报警记录</h4></div>
        <div class="con clearfix" style="margin-bottom: 10px" v-for="(item, i) in alarmList">
          <div class="list">
            <ul>
              <li style="width: 30%" class="red bold">{{item.coalName}}</li>
              <li style="width: 30%">{{item.alarmType}}</li>
              <li style="width: 40%">{{item.alarmDate}}</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="tab-content">
        <div class="tit"><h4>产能统计</h4></div>
        <div class="con clearfix">
          <table class="table-content">
            <tbody>
            <tr>
              <th>单位</th>
              <th>设计产能</th>
              <th>核定产能</th>
            </tr>
            <tr v-for="(item,i) in cntj">
              <td>{{item.coalName}}</td>
              <td>{{item.sjcn}}</td>
              <td>{{item.hdcn}}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>


      <div class="tab-content">
        <div class="tit"><h4>商品煤销售</h4></div>
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
      </div>


      <div class="tab-content">
        <div class="tit"><h4>外运列数</h4></div>
        <div class="con clearfix">
          <table class="table-content">
            <tbody>
            <tr v-for="(item,i) in waiyun">
              <td style="width:25%" class="bold">{{item.coalName}}</td>
              <td style="width:10%">自产</td>
              <td style="width:15%" class="t_l bold">{{item.zic}}</td>
              <td style="width:10%">外购</td>
              <td style="width:15%" class="t_l bold">{{item.waig}}</td>
              <td style="width:10%">外运</td>
              <td style="width:5%" class="t_l bold">{{item.waiy}}</td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>


      <div class="tab-content">
        <div class="tit"><h4>煤炭生产信息</h4></div>
        <div style="text-align:center; margin-top:20px;font-size:1.1rem;color: #5c5c5c">年累计</div>
        <div>
          <van-row>
            <van-col span="12">
              <div style="text-align:center;height:180px;width:100%" ref="myChartYearClPie"></div>
              <div style="text-align:center">年产量计划：{{mtsc.yearcl}}</div>
            </van-col>
            <van-col span="12">
              <div style="text-align:center;height:180px;width:100%" ref="myChartYearXlPie"></div>
              <div style="text-align:center">年销量计划：{{mtsc.yearxl}}</div>
            </van-col>
          </van-row>
        </div>
        <div style="text-align:center; margin-top:20px;font-size:1.1rem;color: #5c5c5c">月累计</div>
        <div>
          <van-row>
            <van-col span="12">
              <div style="text-align:center;height:180px;width:100%" ref="myChartMonthClPie"></div>
              <div style="text-align:center">月产量计划：{{mtsc.monthcl}}</div>
            </van-col>
            <van-col span="12">
              <div style="text-align:center;height:180px;width:100%" ref="myChartMonthXlPie"></div>
              <div style="text-align:center">月销量计划：{{mtsc.monthxl}}</div>
            </van-col>
          </van-row>
        </div>
        <div style="text-align:center; margin-top:20px;font-size:1.1rem;color: #5c5c5c">昨日累计</div>
        <div>
          <van-row>
            <van-col span="12">
              <div style="text-align:center;height:180px;width:100%" ref="myChartYesClPie"></div>
              <div style="text-align:center">产量计划：{{mtsc.yesterdaycl}}</div>
            </van-col>
            <van-col span="12">
              <div style="text-align:center;height:180px;width:100%" ref="myChartYesXlPie"></div>
              <div style="text-align:center">销量计划：{{mtsc.yesterdayxl}}</div>
            </van-col>
          </van-row>
        </div>
      </div>

      <van-tabs v-model="activeName" style="margin-top: 20px; margin-bottom: 20px" @click="tabsClick">
        <van-tab v-for="item in coalTabs" :title="item.coalName" :name="item.coalId"></van-tab>
      </van-tabs>

      <div class="tab-content">
        <div class="con clearfix">

        </div>
      </div>

    </div>



	</div>
</template>

<script>
import * as echarts from 'echarts';
	export default {
		name: "CoalRealData",
		comments: {},
		props: {

		},
		data() {
			return {
			  //顶部信息
        topInfo:{
          num1:'1',
          num2:'2',
          num3:'2',
          num4:'2',
          num5:'2',
          num6:'3444',
          num7:'2345',
          num8:'1234'
        },
        //报警信息
        alarmList:[
          {coalName:'准东二矿',alarmType:'氧气',alarmDate:'2021-10-0:15:50:23'},
          {coalName:'大南湖一矿',alarmType:'氧气',alarmDate:'2021-10-0:15:55:23'},
          {coalName:'黄玉川',alarmType:'氧气',alarmDate:'2021-10-0:15:55:23'}
        ],
        //产能统计
        cntj:[
          {coalName:'三道沟',sjcn:900,hdcn:900},
          {coalName:'上源泉',sjcn:500,hdcn:500},
          {coalName:'黄玉川',sjcn:350,hdcn:350},
          {coalName:'大南湖一矿',sjcn:500,hdcn:500},
          {coalName:'大南湖二矿',sjcn:500,hdcn:500}
        ],
        //商品煤销售
        fuelSell:{zic:0,waig:12.45},
        //外运列数
        waiyun:[
          {coalName:'孤山川',zic:2,waig:12,waiy:4},
          {coalName:'新城川',zic:2,waig:12,waiy:4},
          {coalName:'黄玉川',zic:2,waig:12,waiy:4}
        ],
        //煤炭生产信息
        mtsc:{
          yearcl:'',
          yearxl:'',
          monthcl:'',
          monthxl:'',
          yesterdaycl:'',
          yesterdayxl:''
        },
        //煤矿标签
        activeName:'',
        coalTabs:[
          {coalId:'1',coalName:'三道沟'},
          {coalId:'2',coalName:'上榆泉'},
          {coalId:'3',coalName:'黄玉川'},
          {coalId:'4',coalName:'大南湖'},
          {coalId:'5',coalName:'沙吉海'}
        ]
			}
		},
		created() {

		},
    mounted() {
		  var that = this;
      that.loadYearClPie();
      that.loadYearXlPie();
      that.loadMonthClPie();
      that.loadMonthXlPie();
      that.loadYesterDayClPie();
      that.loadYesterDayXlPie();
    },
    methods: {

      tabsClick(name,title){
        console.log(name);
      },
		  //年产量
      loadYearClPie(){
        let myChartPie = echarts.init(this.$refs.myChartYearClPie);
        myChartPie.clear();
        //计划量
        let jihua = 4590;
        this.mtsc.yearcl = jihua;
        //实际
        let shiji = 1877.55;
        //正式后台获取
        let data = [{value: shiji, name: '年产量', itemStyle:{normal:{color:'#226ee8'}} }];
        //加载计划量图形,给定颜色
        let jh = {value: jihua - shiji, name: '年产量计划', itemStyle:{normal:{color:'#d6d6d6'}}};
        data.push(jh);
        myChartPie.setOption({
          title: {
            text: shiji,
            subtext: '年产量',
            textStyle: {
              color: '#565656',
              fontSize: 15
            },
            subtextStyle: {
              fontSize: 15,
              color: '#6a84bc',
            },
            x: 'center',
            y: 'center',
          },
          series: [
            {
              name: '',
              type: 'pie',
              radius: ['50%', '85%'],
              itemStyle: {
                borderRadius: 1,
                borderColor: '#fff',
                borderWidth: 2
              },
              label: {
                show: false,
                position: 'center'
              },
              emphasis: {
                label: {
                  show: false,
                  fontSize: '40',
                  fontWeight: 'bold'
                }
              },
              labelLine: {
                show: false
              },
              data: data
            }
          ]
        });
      },
      //年销量
      loadYearXlPie(){
        let myChartPie = echarts.init(this.$refs.myChartYearXlPie);
        myChartPie.clear();
        //计划量
        let jihua = 5250;
        this.mtsc.yearxl = jihua;
        //实际
        let shiji = 2081.91;
        //正式后台获取
        let data = [{value: shiji, name: '年销量', itemStyle:{normal:{color:'#25c004'}}}];
        //加载计划量图形,给定颜色
        let jh = {value: jihua - shiji, name: '年销量计划', itemStyle:{normal:{color:'#d6d6d6'}}};
        data.push(jh);
        myChartPie.setOption({
          title: {
            text: shiji,
            subtext: '年销量',
            textStyle: {
              color: '#565656',
              fontSize: 15
            },
            subtextStyle: {
              fontSize: 15,
              color: '#6a84bc',
            },
            x: 'center',
            y: 'center',
          },
          series: [
            {
              name: '',
              type: 'pie',
              radius: ['50%', '85%'],
              itemStyle: {
                borderRadius: 1,
                borderColor: '#fff',
                borderWidth: 2
              },
              label: {
                show: false,
                position: 'center'
              },
              emphasis: {
                label: {
                  show: false,
                  fontSize: '40',
                  fontWeight: 'bold'
                }
              },
              labelLine: {
                show: false
              },
              data: data
            }
          ]
        });
      },
      //月产量
      loadMonthClPie(){
        let myChartPie = echarts.init(this.$refs.myChartMonthClPie);
        myChartPie.clear();
        //计划量
        let jihua = 4590;
        this.mtsc.monthcl = jihua;
        //实际
        let shiji = 1877.55;
        //正式后台获取
        let data = [{value: shiji, name: '月产量', itemStyle:{normal:{color:'#21d8bc'}} }];
        //加载计划量图形,给定颜色
        let jh = {value: jihua - shiji, name: '月产量计划', itemStyle:{normal:{color:'#d6d6d6'}}};
        data.push(jh);
        myChartPie.setOption({
          title: {
            text: shiji,
            subtext: '月产量',
            textStyle: {
              color: '#565656',
              fontSize: 15
            },
            subtextStyle: {
              fontSize: 15,
              color: '#6a84bc',
            },
            x: 'center',
            y: 'center',
          },
          series: [
            {
              name: '',
              type: 'pie',
              radius: ['50%', '85%'],
              itemStyle: {
                borderRadius: 1,
                borderColor: '#fff',
                borderWidth: 2
              },
              label: {
                show: false,
                position: 'center'
              },
              emphasis: {
                label: {
                  show: false,
                  fontSize: '40',
                  fontWeight: 'bold'
                }
              },
              labelLine: {
                show: false
              },
              data: data
            }
          ]
        });
      },
      //月销量
      loadMonthXlPie(){
        let myChartPie = echarts.init(this.$refs.myChartMonthXlPie);
        myChartPie.clear();
        //计划量
        let jihua = 5250;
        this.mtsc.monthxl = jihua;
        //实际
        let shiji = 2081.91;
        //正式后台获取
        let data = [{value: shiji, name: '月销量', itemStyle:{normal:{color:'#e9c201'}}}];
        //加载计划量图形,给定颜色
        let jh = {value: jihua - shiji, name: '月销量计划', itemStyle:{normal:{color:'#d6d6d6'}}};
        data.push(jh);
        myChartPie.setOption({
          title: {
            text: shiji,
            subtext: '月销量',
            textStyle: {
              color: '#565656',
              fontSize: 15
            },
            subtextStyle: {
              fontSize: 15,
              color: '#6a84bc',
            },
            x: 'center',
            y: 'center',
          },
          series: [
            {
              name: '',
              type: 'pie',
              radius: ['50%', '85%'],
              itemStyle: {
                borderRadius: 1,
                borderColor: '#fff',
                borderWidth: 2
              },
              label: {
                show: false,
                position: 'center'
              },
              emphasis: {
                label: {
                  show: false,
                  fontSize: '40',
                  fontWeight: 'bold'
                }
              },
              labelLine: {
                show: false
              },
              data: data
            }
          ]
        });
      },
      //昨日产量
      loadYesterDayClPie(){
        let myChartPie = echarts.init(this.$refs.myChartYesClPie);
        myChartPie.clear();
        //计划量
        let jihua = 35;
        this.mtsc.yesterdaycl = jihua;
        //实际
        let shiji = 18.55;
        //正式后台获取
        let data = [{value: shiji, name: '昨日产量', itemStyle:{normal:{color:'#6667d3'}} }];
        //加载计划量图形,给定颜色
        let jh = {value: jihua - shiji, name: '昨日产量计划', itemStyle:{normal:{color:'#d6d6d6'}}};
        data.push(jh);
        myChartPie.setOption({
          title: {
            text: shiji,
            subtext: '昨日产量',
            textStyle: {
              color: '#565656',
              fontSize: 15
            },
            subtextStyle: {
              fontSize: 15,
              color: '#6a84bc',
            },
            x: 'center',
            y: 'center',
          },
          series: [
            {
              name: '',
              type: 'pie',
              radius: ['50%', '85%'],
              itemStyle: {
                borderRadius: 1,
                borderColor: '#fff',
                borderWidth: 2
              },
              label: {
                show: false,
                position: 'center'
              },
              emphasis: {
                label: {
                  show: false,
                  fontSize: '40',
                  fontWeight: 'bold'
                }
              },
              labelLine: {
                show: false
              },
              data: data
            }
          ]
        });
      },
      //昨日销量
      loadYesterDayXlPie(){
        let myChartPie = echarts.init(this.$refs.myChartYesXlPie);
        myChartPie.clear();
        //计划量
        let jihua = 55;
        this.mtsc.yesterdayxl = jihua;
        //实际
        let shiji = 22.91;
        //正式后台获取
        let data = [{value: shiji, name: '昨日销量', itemStyle:{normal:{color:'#02b6e9'}}}];
        //加载计划量图形,给定颜色
        let jh = {value: jihua - shiji, name: '昨日销量计划', itemStyle:{normal:{color:'#d6d6d6'}}};
        data.push(jh);
        myChartPie.setOption({
          title: {
            text: shiji,
            subtext: '昨日销量',
            textStyle: {
              color: '#565656',
              fontSize: 15
            },
            subtextStyle: {
              fontSize: 15,
              color: '#6a84bc',
            },
            x: 'center',
            y: 'center',
          },
          series: [
            {
              name: '',
              type: 'pie',
              radius: ['50%', '85%'],
              itemStyle: {
                borderRadius: 1,
                borderColor: '#fff',
                borderWidth: 2
              },
              label: {
                show: false,
                position: 'center'
              },
              emphasis: {
                label: {
                  show: false,
                  fontSize: '40',
                  fontWeight: 'bold'
                }
              },
              labelLine: {
                show: false
              },
              data: data
            }
          ]
        });
      }
		}
	}
</script>

<style scoped lang="scss">
*{margin: 0;padding: 0;border: 0;list-style: none;text-decoration: none;color: inherit;font-weight: normal;font-family: "微软雅黑";box-sizing: border-box;font-style: normal;}
.clearfix:after{content:".";display:block;height:0;clear:both;visibility:hidden;}
.clearfix{*display:inline-block;*zoom:100%;}
.clear{clear:both;height:0px;font-size:0px;line-height:0px;overflow:hidden;}

.tbox{ background:#226ee8; padding: 2rem 0 0;}
.tbox ul{}
.tbox ul li{width: 25%; float: left; text-align: center; margin-bottom:2rem}
.tbox ul li p{ font-size:1.8rem; font-weight: 700; color:#fff; font-family:arial; margin-bottom:.2rem}
.tbox ul li h4{ font-size:.8rem; color:#fff; line-height: 1.5rem}
.red0{color:#FF7D83!important}
.red{color:#EC070A!important}
.orange{color:#F3A527!important}
.yellow{color:#F7DA45!important}
.blank10{ clear: both; display: block; overflow: hidden; height: .5rem; line-height: .5rem; font-size: 0px;}

.main{ padding: 1rem; padding-top: 0px;}
.tab-content{}
.bold{font-weight: 700!important}
.tit{ margin: .8rem 0}
.tit h4{font-size:1.1rem;color: #5c5c5c;font-weight: 700;position: relative;padding-left:12px;}
.tit h4:after{ content: '';position: absolute;z-index: 0;top: 0px;left: 0;width: 4px;height: 1.1rem;border-radius:3px;background: #1E6DE4;}
.con{ background: #EFF8FF; border: 1px solid #e5e6e8; padding: .5rem; border-radius:5px;}
.list{}
.list ul{}
.list ul li{ float: left; font-size:.8rem; color:#696c75}
.table-content{
  empty-cells: show;
  border-collapse: collapse;
  border-spacing: 0;
  width: 100%
}

table{empty-cells:show;border-collapse:collapse;border-spacing:0;}
.table-content th{ padding:.5rem .2rem; border-bottom: 2px solid #c4def9; font-size:.8rem; color:#696c75; text-align: center}
.table-content td{ padding:.5rem .2rem; border-bottom: 1px solid #e4e4e4; font-size:.8rem; color:#696c75; text-align: center}


.xs{ padding-top: .5rem}
.xs ul{}
.xs ul li{ float: left; text-align: center; width: 33.333%}
.xs ul li h4{font-size:.8rem; color:#696c75; line-height: 1.5rem}
.xs ul li p{font-size:1.4rem; font-weight: 700; color:#696c75; font-family:arial; margin-bottom:.2rem}


.t_l{ text-align: left!important}
</style>
