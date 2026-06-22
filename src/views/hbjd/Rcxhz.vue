/<template>
	<div style="width: 100%;overflow-x: hidden;">
      <div class="main"> 
        <div class="tab-content">
          <van-tabs v-model="mtcxlActive" @click="tabsClick" title-active-color='#216DEA'
                    title-inactive-color='#7E7E7E'>
            <van-tab title="日汇总">
              <van-row>
                <van-col span="24">
                  <div class="tab-content">
                    <div class="tit">
                      <div style="display: inline">
                        <h4>合计</h4><span>(h)</span>
                      </div>
                      <div style="float: right">
                        <h4 style="font-size: 14px">日累计</h4><span style="font-size: 16px; color: #216DEA; font-weight: 700">{{jzzj.count}}</span>
                      </div>
                    </div>
                    <div class="con clearfix">
                      <div class="xs">
                        <ul>
                          <li>
                            <p>{{jzzj.stopstart}}</p>
                            <h4>机组启停</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.stopstarbfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                          <li>
                            <p>{{jzzj.error}}</p>
                            <h4>设备故障</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.errorbfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                          <li>
                            <p>{{jzzj.operate}}</p>
                            <h4>运行调整</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.operatebfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                          <li>
                            <p>{{jzzj.schedule}}</p>
                            <h4>定期工作</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.schedulebfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div class="tab-content" v-for="index in jzList">
                    <div class="tit">
                      <h4>{{index.type}}</h4>
                    </div>
                    <div class="con clearfix">
                      <div class="con clearfix con-clearfix-border" v-for="jz in index.jzzj">
                        <div class="xp">
                          <ul>
                            <li>
                              <h4>{{jz.unitname}}</h4>
                              <span class="zb-xp" >日累计<span class="zb-count-xp">{{jz.count}}<span class="zb-xp">h</span></span></span>
                            </li>
                          </ul>

                          <div class="xh">
                            <ul>
                              <li>
                                <span class="zb-xh" >机组启停<span class="zb-count-xh">{{jz.stopstart}}</span></span>
                              </li>
                            </ul>
                            <ul>
                              <li>
                                <span class="zb-xh" >设备故障<span class="zb-count-xh">{{jz.error}}</span></span>
                              </li>
                            </ul>
                          </div>
                          <div class="xh">
                            <ul>
                              <li>
                                <span class="zb-xh" >运行调整<span class="zb-count-xh">{{jz.operate}}</span></span>
                              </li>
                            </ul>
                            <ul>
                              <li>
                                <span class="zb-xh" >定期工作<span class="zb-count-xh">{{jz.schedule}}</span></span>
                              </li>
                            </ul>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </van-col>
              </van-row>
            </van-tab>
            <van-tab title="月汇总">
              <van-row>
              <van-col span="24">
                <div class="tab-content">
                  <div class="tit">
                    <div style="display: inline">
                      <h4>合计</h4><span>(h)</span>
                    </div>
                    <div style="float: right">
                      <h4 style="font-size: 14px">月累计</h4><span style="font-size: 16px; color: #216DEA; font-weight: 700">{{jzzj.count}}</span>
                    </div>
                  </div>
                  <div class="con clearfix">
                    <div class="xs">
                      <ul>
                        <li>
                          <p>{{jzzj.stopstart}}</p>
                          <h4>机组启停</h4>
                          <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.stopstarbfb}}<span class="zb-xs">%</span></span></span>
                        </li>
                        <li>
                          <p>{{jzzj.error}}</p>
                          <h4>设备故障</h4>
                          <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.errorbfb}}<span class="zb-xs">%</span></span></span>
                        </li>
                        <li>
                          <p>{{jzzj.operate}}</p>
                          <h4>运行调整</h4>
                          <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.operatebfb}}<span class="zb-xs">%</span></span></span>
                        </li>
                        <li>
                          <p>{{jzzj.schedule}}</p>
                          <h4>定期工作</h4>
                          <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.schedulebfb}}<span class="zb-xs">%</span></span></span>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
                <div class="tab-content" v-for="index in jzList">
                  <div class="tit">
                    <h4>{{index.type}}</h4>
                  </div>
                  <div class="con clearfix">
                    <div class="con clearfix con-clearfix-border" v-for="jz in index.jzzj">
                      <div class="xp">
                        <ul>
                          <li>
                            <h4>{{jz.unitname}}</h4>
                            <span class="zb-xp" >日累计<span class="zb-count-xp">{{jz.count}}<span class="zb-xp">h</span></span></span>
                          </li>
                        </ul>

                        <div class="xh">
                          <ul>
                            <li>
                              <span class="zb-xh" >机组启停<span class="zb-count-xh">{{jz.stopstart}}</span></span>
                            </li>
                          </ul>
                          <ul>
                            <li>
                              <span class="zb-xh" >设备故障<span class="zb-count-xh">{{jz.error}}</span></span>
                            </li>
                          </ul>
                        </div>
                        <div class="xh">
                          <ul>
                            <li>
                              <span class="zb-xh" >运行调整<span class="zb-count-xh">{{jz.operate}}</span></span>
                            </li>
                          </ul>
                          <ul>
                            <li>
                              <span class="zb-xh" >定期工作<span class="zb-count-xh">{{jz.schedule}}</span></span>
                            </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </van-col>
            </van-row>
            </van-tab>
            <van-tab title="年汇总">
              <van-row>
                <van-col span="24">
                  <div class="tab-content">
                    <div class="tit">
                      <div style="display: inline">
                        <h4>合计</h4><span>(h)</span>
                      </div>
                      <div style="float: right">
                        <h4 style="font-size: 14px">年累计</h4><span style="font-size: 16px; color: #216DEA; font-weight: 700">{{jzzj.count}}</span>
                      </div>
                    </div>
                    <div class="con clearfix">
                      <div class="xs">
                        <ul>
                          <li>
                            <p>{{jzzj.stopstart}}</p>
                            <h4>机组启停</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.stopstarbfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                          <li>
                            <p>{{jzzj.error}}</p>
                            <h4>设备故障</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.errorbfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                          <li>
                            <p>{{jzzj.operate}}</p>
                            <h4>运行调整</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.operatebfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                          <li>
                            <p>{{jzzj.schedule}}</p>
                            <h4>定期工作</h4>
                            <span class="zb-xs" >占比<span class="zb-count-xs">{{jzzj.schedulebfb}}<span class="zb-xs">%</span></span></span>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div class="tab-content" v-for="index in jzList">
                    <div class="tit">
                      <h4>{{index.type}}</h4>
                    </div>
                    <div class="con clearfix">
                      <div class="con clearfix con-clearfix-border" v-for="jz in index.jzzj">
                        <div class="xp">
                          <ul>
                            <li>
                              <h4>{{jz.unitname}}</h4>
                              <span class="zb-xp" >日累计<span class="zb-count-xp">{{jz.count}}<span class="zb-xp">h</span></span></span>
                            </li>
                          </ul>

                          <div class="xh">
                            <ul>
                              <li>
                                <span class="zb-xh" >机组启停<span class="zb-count-xh">{{jz.stopstart}}</span></span>
                              </li>
                            </ul>
                            <ul>
                              <li>
                                <span class="zb-xh" >设备故障<span class="zb-count-xh">{{jz.error}}</span></span>
                              </li>
                            </ul>
                          </div>
                          <div class="xh">
                            <ul>
                              <li>
                                <span class="zb-xh" >运行调整<span class="zb-count-xh">{{jz.operate}}</span></span>
                              </li>
                            </ul>
                            <ul>
                              <li>
                                <span class="zb-xh" >定期工作<span class="zb-count-xh">{{jz.schedule}}</span></span>
                              </li>
                            </ul>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </van-col>
              </van-row>
            </van-tab>
          </van-tabs>
        </div>
      </div>
    </div>

</template>

<script>
import * as echarts from 'echarts';
import axios from 'axios';
import qs from 'qs';
export default {
    name: "Rcxhz",
    data() {
        return {
            mtcxlActive: 0,
            jzzj:{
                count: '',
                stopstart: '',
                error: '',
                operate: '',
                schedule: '',
                stopstarbfb: '',
                errorbfb: '',
                operatebfb: '',
                schedulebfb: '',
            },
            jzList:[],
        }
    },
    mounted() {
        this.loadDLimitSummary();
    },
    methods: {
        tabsClick(name, title) {
            this.$nextTick(() => {
                if (name == 0) {
                    this.loadDLimitSummary();
                }
                if (name == 1) {
                    this.loadMLimitSummary();
                }
                if (name == 2) {
                    this.loadYLimitSummary();
                }
            });
        },
        loadDLimitSummary: async function(){
            axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/DLimitSummary`, {
                params: {},
            }).then((res) => {
                if(res.status == 200){
                    this.getTable(res.data.TABLE);
                }
            });
        },
        loadMLimitSummary: async function(){
            axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/MLimitSummary`, {
                params: {},
            }).then((res) => {
                if(res.status == 200){
                    this.getTable(res.data.TABLE);
                }
            });
        },
        loadYLimitSummary: async function(){
            axios.get(`${this.$config.YDMHEJYY}httpRequest/getRequestResult?apiUrl=/hbjd/YLimitSummary`, {
                params: {},
            }).then((res) => {
                if(res.status == 200){
                   this.getTable(res.data.TABLE);
                }
            });
        },
        getTable(data){
            this.jzList = [];
            this.jzzj = {};
            this.jzzj.count = data[13].count;
            this.jzzj.stopstart = data[13].stopstart;
            this.jzzj.error = data[13].error;
            this.jzzj.operate = data[13].operate;
            this.jzzj.schedule = data[13].schedule;
            this.jzzj.stopstarbfb = (data[13].stopstart / data[13].count * 100).toFixed(2);
            this.jzzj.errorbfb = (data[13].error / data[13].count * 100).toFixed(2);
            this.jzzj.operatebfb = (data[13].operate / data[13].count * 100).toFixed(2);
            this.jzzj.schedulebfb = (data[13].schedule / data[13].count * 100).toFixed(2);
            var list1 = [{
                "unitname": data[12].FACT_NAME,
                "count": data[12].count,
                "stopstart": data[12].stopstart,
                "error": data[12].error,
                "operate": data[12].operate,
                "schedule": data[12].schedule,
            }
            ];
            var list2 = [
                {
                    "type": "部分超低排放机组",
                    "unitname": "哈密",
                    "count": data[1].count,
                    "stopstart": data[1].stopstart,
                    "error": data[1].error,
                    "operate": data[1].operate,
                    "schedule": data[1].schedule,
                },
                {
                    "unitname": data[0].FACT_NAME,
                    "count": data[0].count,
                    "stopstart": data[0].stopstart,
                    "error": data[0].error,
                    "operate": data[0].operate,
                    "schedule": data[0].schedule,
                },
                {
                    "unitname": data[2].FACT_NAME,
                    "count": data[2].count,
                    "stopstart": data[2].stopstart,
                    "error": data[2].error,
                    "operate": data[2].operate,
                    "schedule": data[2].schedule,
                },
                {
                    "unitname": data[4].FACT_NAME,
                    "count": data[4].count,
                    "stopstart": data[4].stopstart,
                    "error": data[4].error,
                    "operate": data[4].operate,
                    "schedule": data[4].schedule,
                },
                {
                    "unitname": "店塔660",
                    "count": data[6].count,
                    "stopstart": data[6].stopstart,
                    "error": data[6].error,
                    "operate": data[6].operate,
                    "schedule": data[6].schedule,
                },
                {
                    "unitname": data[3].FACT_NAME,
                    "count": data[3].count,
                    "stopstart": data[3].stopstart,
                    "error": data[3].error,
                    "operate": data[3].operate,
                    "schedule": data[3].schedule,
                }
            ];
            var list3 = [
                {
                    "type": "",
                    "unitname": data[5].FACT_NAME,
                    "count": data[5].count,
                    "stopstart": data[5].stopstart,
                    "error": data[5].error,
                    "operate": data[5].operate,
                    "schedule": data[5].schedule,
                },
            ];
            var list4 = [
                {
                    "unitname": data[8].FACT_NAME,
                    "count": data[8].count,
                    "stopstart": data[8].stopstart,
                    "error": data[8].error,
                    "operate": data[8].operate,
                    "schedule": data[8].schedule,
                },
                {
                    "unitname": data[9].FACT_NAME,
                    "count": data[9].count,
                    "stopstart": data[9].stopstart,
                    "error": data[9].error,
                    "operate": data[9].operate,
                    "schedule": data[9].schedule,
                },
                {
                    "unitname": data[10].FACT_NAME,
                    "count": data[10].count,
                    "stopstart": data[10].stopstart,
                    "error": data[10].error,
                    "operate": data[10].operate,
                    "schedule": data[10].schedule,
                },
            ];
            var list5 = [
                {
                    "unitname": "店塔135",
                    "count": data[7].count,
                    "stopstart": data[7].stopstart,
                    "error": data[7].error,
                    "operate": data[7].operate,
                    "schedule": data[7].schedule,
                },
                {
                    "unitname": data[11].FACT_NAME,
                    "count": data[11].count,
                    "stopstart": data[11].stopstart,
                    "error": data[11].error,
                    "operate": data[11].operate,
                    "schedule": data[11].schedule,
                },
            ];
            var cdpfjj = {
                type:'超低排放机组',
                jzzj:list1,
            };
            var bfcdpfjj = {
                type:'部分超低排放机组',
                jzzj:list2,
            };
            var cgmfljz = {
                type:'常规煤粉炉机组',
                jzzj:list3,
            };
            var cfb200 = {
                type:'200MW级及以上CFB',
                jzzj:list4,
            };
            var cfb135 = {
                type:'135MW级及以下CFB',
                jzzj:list5,
            };
            this.jzList.push(cdpfjj,bfcdpfjj,cgmfljz,cfb200,cfb135)
        }
    }
}
</script>

<style scoped lang="scss">
*{margin: 0;padding: 0;border: 0;list-style: none;text-decoration: none;color: inherit;font-weight: normal;font-family: "微软雅黑";box-sizing: border-box;font-style: normal;}

.main{ padding: 1rem; padding-top: 0px;}
.tit{ margin: .8rem 0}
.tit h4{font-size:15px;color: #5D5D5D;font-weight: 700;position: relative;padding-left:12px;display: inline;}
.tit h4:after{ content: '';position: absolute;z-index: 0;top:50%; transform:translateY(-50%);left: 0;width: 4px;height: 1.1rem;border-radius:3px;background: #1E6DE4;display: inline;}
.tit span{font-size:7px;color: #8A8A8A;;position: relative;padding-left:12px;}
.table-content{
  empty-cells: show;
  border-collapse: collapse;
  border-spacing: 0;
  width: 100%
}
.tab-content{overflow-y: hidden;}
.con{ background: #EFF8FF; border: 1px solid #e5e6e8; padding: .5rem; border-radius:5px;}
.clearfix:after{content:".";display:block;height:0;clear:both;visibility:hidden;}
.clearfix{*display:inline-block;*zoom:100%;}
.con-clearfix-border{
  border-top: 4px solid #EFF8FF;border-left: 4px solid #EFF8FF;border-right: 4px solid #EFF8FF;border-bottom: 4px solid #ffffff;}
.xs{ padding-top: .5rem}
.xs ul{}
.xs ul li{ float: left; text-align: center; width: 25%}
.xs ul li p{font-size:26px; font-weight: 700; color:#333333; font-family:arial; margin-bottom:.2rem}
.xs ul li h4{font-size:14px; font-weight: 700; color:#656565; line-height: 1.5rem; margin-bottom: 5px}
.zb-xs{
  font-size:8.5px; color:#656565; font-family:arial; margin-bottom:.2rem
}
.zb-count-xs{
  font-size:20px; color:#325183; font-family:arial; margin-bottom:.2rem; font-weight: 500;
}
.xp{padding-top: .5rem;}
.xp ul{}
.xp ul li{ float: left; text-align: center; width: 25%}
.xp ul li p{font-size:26px; font-weight: 700; color:#333333; font-family:arial; margin-bottom:.2rem}
.xp ul li h4{font-size:18px; font-weight: 700; color:#333333; line-height: 1.5rem; margin-bottom: 5px}
.zb-xp{
  font-size:9px; color:#767676; font-family:arial; margin-bottom:.2rem
}
.zb-count-xp {
  font-size: 18px;
  color: #325183;
  font-family: arial;
  margin-bottom: .2rem;
  font-weight: 500;
}

.xh{}
.xh ul{}
.xh ul li{ float: right; text-align: center; width:30%; padding-bottom: 10px;}
.xh ul li p{font-size:26px; font-weight: 700; color:#333333; font-family:arial; margin-bottom:.2rem}
.zb-xh{
  font-size:14px; color:#656565; font-family:arial; margin-bottom:.2rem; font-weight: 500;
}
.zb-count-xh{
  font-size:18px; color:#333333; font-family:arial; margin-bottom:.2rem; font-weight: 700;margin-left: 15px;
}

::v-deep .van-tab {
  font-size: 15px;
  font-weight: 700;
}

::v-deep .van-tabs__line{
  background-color: #216DEA;
}
::v-deep .van-tab--active{
  color: #216DEA;
  font-size: 15px;
  font-weight: 700;
}

</style>
