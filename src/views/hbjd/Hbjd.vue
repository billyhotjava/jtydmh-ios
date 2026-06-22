<template>
  <div class="tab-page has-header">
    <div class="tab-header">
      <mt-header title="环保监督">
        <a href="javascript:;" slot="left" @click="$router.back(-1)">
          <mt-button icon="back" />
        </a>
      </mt-header>
    </div>
    <div class="content-container tab-content">
      <van-tabs type="card" v-model="active">
	      <van-tab title="实时监测">
          <Ssjc/>
        </van-tab>
        <van-tab title="超限汇总">
          <Rcxhz/>
        </van-tab>
        <van-tab title="昨日日报">
          <Hbrb/>
        </van-tab>
        <van-tab title="环保指标">
          <Hbzb/>
        </van-tab>
      </van-tabs>
    </div>
  </div>
</template>
<script>

import Ssjc from "../../views/hbjd/Ssjc";
import Rcxhz from "../../views/hbjd/Rcxhz";
import Hbrb from "../../views/hbjd/Hbrb";
import Hbzb from "../../views/hbjd/Hbzb";

export default {
  name: "Hbjd",
  components: {
    Ssjc,
    Rcxhz,
    Hbrb,
    Hbzb,
    
  },
  data() {
    return {
      active: 0,
      activeDl: 0
    };
  }
};
</script>


<style scoped>
>>>.van-tabs--card > .van-tabs__wrap {
    background: #2a77f7;
    padding: 10px 0px;
    height: auto;
}

>>>.van-tabs__nav--card {
  background: #2a77f7;
}
>>>.van-tabs__nav--card .van-tab.van-tab--active {
  color: #2a77f7;
  background-color: #fff;
  border-radius: 100px;
}
>>>.van-tabs__nav--card {
  border: 0px solid #2a77f7;
}

>>>.van-tabs__nav--card .van-tab {
  border-right: 0px solid rgb(191, 209, 240);
}

>>>.van-tabs__nav--card .van-tab {
  color: #fff;
  background: #2a77f7;
}
</style>