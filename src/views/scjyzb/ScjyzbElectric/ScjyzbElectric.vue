<template>
  <div class="tab-page has-header">
    <div class="tab-header">
      <mt-header title="生产经营指标" class="nav-header">
        <a href="javascript:;" slot="left" @click="$router.back(-1)">
          <mt-button icon="back" />
        </a>
      </mt-header>
      <div>
        <van-dropdown-menu active-color="#206EEA" class="dropdown-item">
          <van-dropdown-item v-model="leftValue" :options="leftDropDownList" @change="selectLeftChange()" v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击筛选火电/光伏/风电的按钮', actionType:'scjyzbelectric-tab1-click'}"/>
          <van-dropdown-item v-model="rightValue" :options="rightDropDownList[leftValue]" @change="selectRightChange()"  v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击筛选具体火电/光伏/风电的按钮', actionType:'scjyzbelectric-tab2-click'}"/>
        </van-dropdown-menu>
      </div>
    </div>
    <div class="content-container tab-content" style="background: white">
      <div>
        <div v-if="leftValue == 0">
          <scjyzbhdyy :title="title" :proId="this.rightValue"></scjyzbhdyy>
        </div>
        <div v-else>
          <Scjyzbgfyy :title="title":proId="this.rightValue"></Scjyzbgfyy>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

// 勿删 有引用样式
import Mksssj from "@/views/mksssj/Mksssj";
import Scjyzbhdyy from "@/views/scjyzb/ScjyzbElectric/Scjyzbhdyy";
import Scjyzbgfyy from "@/views/scjyzb/ScjyzbElectric/Scjyzbgfyy"

export default {
  name: "ScjyzbElectric",
  components: {
    Scjyzbhdyy,
    Scjyzbgfyy
  },
  data() {
    return {
      leftValue: 0,
      leftDropDownList: [
        {
          text: '火电', value: 0
        },
        {
          text: '光伏', value: 1
        },
        {
          text: '风场', value: 2
        }
      ],
      rightValue: 2,
      rightDropDownList: [
        [
          {text: '花园电厂', value: 2, set: ['#1机组', '#2机组', '#3机组', '#4机组']},
          {text: '河曲电厂', value: 12, set: ['#1机组', '#2机组', '#3机组', '#4机组']},
          {text: '大南湖电厂', value: 16, set: ['#1机组', '#2机组']},
          {text: '和丰电厂', value: 17, set: ['#1机组', '#2机组']},
          {text: '店塔电厂', value: 18, set: ['#1机组', '#2机组', '#3机组', '#4机组']},
          {text: '府谷电厂', value: 19, set: ['#1机组', '#2机组', '#3机组', '#4机组']},
          {text: '郭家湾电厂', value: 20, set: ['#1机组', '#2机组']},
          {text: '鄂温克电厂', value: 21, set: ['#1机组', '#2机组']},
          {text: '亿利电厂', value: 22, set: ['#1机组', '#2机组', '#3机组', '#4机组']},
          {text: '白马电厂', value: 26, set: ['#1机组', '#2机组']},
          {text: '宝清电厂', value: 29, set: ['#1机组', '#2机组']},
        ],
        [
          {text: '白云光伏电厂', value: 33},
        ],
        [
          {text: '乌拉特风电场', value: 30},
          {text: '白云风电场', value: 31},
          // {text: '康保风电场', value: 32},
        ]
      ],
      dataList: [],
      filterList: [],
    }
  },
  computed: {
    title: function () {
      let rightList = this.rightDropDownList[this.leftValue];
      var text = '';
      rightList.forEach((item, index) => {
        if (item.value == this.rightValue) {
          text = item.text;
        }
      })
      // console.log('text !!! ', text);
      return text;
    }
  },
  mounted() {
    this.selectLeftChange();
  },
  methods: {
    selectLeftChange() {
      if (this.leftValue == 0) {
        this.rightValue = 2;
      } else if (this.leftValue == 1) {
        this.rightValue = 33;
      } else if (this.leftValue == 2) {
        this.rightValue = 30;
      } else {
        this.rightValue = 2;
      }
      this.selectRightChange();
    },
    selectRightChange() {

    },
  },
}
</script>

<style scoped>
.van-tabs--line .van-tabs__wrap {
  height: 44px;
  margin-bottom: 10px;
}
.van-tabs__line {
  background: #216dea;
}
</style>