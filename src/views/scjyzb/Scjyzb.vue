<template>
  <div class="tab-page has-header">
    <div class="tab-header">
      <mt-header title="生产经营指标">
        <a href="javascript:;" slot="left" @click="$router.back(-1)">
          <mt-button icon="back" />
        </a>
       <mt-button slot="right" @click="electricQuota">
          厂侧指标
        </mt-button>
      </mt-header>
    </div>
    <div class="content-container tab-content">
    <van-tabs type="card" v-model="active">
      <van-tab title="电力">
        <van-tabs v-model="activeDl">
          <van-tab title="火电">
            <Hdyy/>
          </van-tab>
          <van-tab title="风电">
            <Fdyy/>
          </van-tab>
          <van-tab title="光伏">
            <Gfyy/>
          </van-tab>
        </van-tabs>
      </van-tab>
      <van-tab title="煤矿">
        <Mkyy/>
      </van-tab>
      <van-tab title="安全">
        <Aqfx/>
      </van-tab>
      <van-tab title="环保">
        <Hbfx/>
      </van-tab>
    </van-tabs>
    </div>
  </div>
</template>
<script>
import Mkyy from "../../views/scjyzb/Mkyy";
import Aqfx from "../../views/scjyzb/Aqfx";
import Hbfx from "../../views/scjyzb/Hbfx";
import Hdyy from "../../views/scjyzb/Hdyy";
import Fdyy from "../../views/scjyzb/Fdyy";
import Gfyy from "../../views/scjyzb/Gfyy";
export default {
  name: "Scjyzb",
  components: {
    Mkyy,
    Aqfx,
    Hbfx,
    Hdyy,
    Fdyy,
    Gfyy
  },
  data() {
    return {
      active: 0,
      activeDl: 0
    }
  },
  methods: {
    electricQuota() {
      this.$router.push('/scjyzbelectric');
    }
  }
};
</script>


<style scoped>
>>>.van-tabs--card > .van-tabs__wrap {
  height: 50px; 
  background: #2a77f7;
  padding: 10px 0px;
}

>>>.van-tab--active {
  color: #216DEA;
  font-weight: 500;
}

>>>.van-tabs__nav--card {
  border: 0;
  background: #2a77f7;
}
/*.van-tabs__nav {*/
/*color: #E5E5E5;*/
/*background: white;*/
/*}*/
>>>.van-tabs__nav--card .van-tab {
  color: #fff;
  border-right: 0px solid #fff;
}
>>>.van-tabs__nav--card .van-tab.van-tab--active {
  color: #2a77f7;
  background-color: #fff;
  border-radius: 100px;
}

>>>.van-tab__text--ellipsis {
  font-size: 14px;
  font-weight: 700;
}
</style>