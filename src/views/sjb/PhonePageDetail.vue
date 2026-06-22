<template>
  <div class="tab-page has-header">
    <div class="tab-header">
      <mt-header title="手机报详情" class="sjb-header">
        <a href="javascript:;" slot="left" @click="$router.back(-1 )">
          <mt-button icon="back"/>
        </a>
      </mt-header>
    </div>
    <div class="content-container tab-content">
      <div class="content-title">
        {{draftInfo.title}}
      </div>
      <div class="content-date">
        {{draftInfo.releaseDate}}
      </div>
      <div class="content-date">
        {{draftInfo.chineseLunarCalendar}}
      </div>
      <div class="content-div" id="container-parent">
<!--        <main v-exchangeHtml:foo='htmlContent'/>-->
        <div v-html="htmlContent"></div>
      </div>
      <div class="final-sign">发布：{{draftInfo.inscribe}}</div>
    </div>
  </div>
</template>

<script>

import { calendar } from '@/lunarCalendar.js';
// var HtmlComponent = Vue.extend({
//   template: this.htmlContent,
//   methods: {
//     showPreview() {
//       console.log('点击图片');
//     }
//   }
// });
// var component = new HtmlComponent().$mount();
export default {
name: "PhonePageDetail",
  comments: {

  },
  props: {

  },
  data() {
    return {
      // lunarDate: '',
      draftInfo: {},//this.$route.params.item,
      htmlContent: '',//this.$route.params.item.content,
    }
  },
  mounted() {
    // this.getLunarDate();
    this.getDetailById();
  },
  methods: {
  //   getLunarDate() {
  //     let date = this.$route.params.item.replace(/\s*/g,'');
  //     let list = date.split('-');
  //     if (list.length < 3) {
  //       list = date.split('/');
  //       if (list.length >= 3 && list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
  //         let lunarInfo = calendar.solar2lunar(list[0], list[1], list[2]);
  //         this.lunarDate = lunarInfo.gzYear + '(' + lunarInfo.Animal + ')年' + ' ' + lunarInfo.IMonthCn + lunarInfo.IDayCn + ' ' + lunarInfo.ncWeek;
  //       } else {
  //         console.log('in 日期格式错误', list);
  //       }
  //     } else {
  //       if (list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
  //         let lunarInfo = calendar.solar2lunar(list[0], list[1], list[2]);
  //         this.lunarDate = lunarInfo.gzYear + '(' + lunarInfo.Animal + ')年' + ' ' + lunarInfo.IMonthCn + lunarInfo.IDayCn + ' ' + lunarInfo.ncWeek;
  //       } else {
  //         this.lunarDate = '';
  //         console.log('in 日期格式错误', list);
  //       }
  //     }
  //   },
    getDetailById() {
      if (this.$route.params.isLoadLocalData) {
        this.draftInfo = this.$route.params.item;
        this.htmlContent = this.$route.params.item.content;
      } else {
        var params = {};
        if (this.$route.params != {} && this.$route.params.id) {
          params = this.$route.params;
          localStorage.setItem('offlinePhonePageParams', JSON.stringify(params));
        } else {
          params = localStorage.getItem('offlinePhonePageParams');
          params = JSON.parse(params);
          if (params == {}) {
            console.log('！！！ 数据错误');
            return;
          }
        }
        this.$getRequest(`${this.$config.YDMH}mobileNews/findById`, {
          id: params.id,
        }).then(res => {
          console.log('获取手机报详情成功 ', res.object.content);
          // console.log("", this.$route.params.item.content);
          this.draftInfo = res.object;
          this.htmlContent = res.object.content;
          // var reg = new RegExp(/ src="(.*?)"/g);
          // let regList = this.htmlContent.match(reg);
          // regList.forEach((item, index) => {
          //   console.log(item);
          //   this.htmlContent = this.htmlContent.replace(item, ' @click="showPreview()" ' + item);
          // })
          // console.log("替换以后", this.htmlContent);
          // document.getElementById('container-parent').appendChild(component.$el);
          // var index = 0;
          // while ((index = this.htmlContent.indexOf('<img ', index)) != -1) {
          //   index += key.length;
          //   this.htmlContent = this.htmlContent.splice(index, '@click="showPreview()"')
          // }
        }).catch(err => {
          console.log('获取手机报详情失败 ', err);
          this.$toast({message: err, className: 'inexa'});
        });
      }
    },
  }
}
</script>

<style scoped>
.content-container {
  /*margin-top: 15px;*/
}
.content-title {
  margin-top: 15px;
  font-size: x-large;
  text-align: center;
}
.content-date {
  margin: 15px 0px;
  font-size: 14px;
  color: #999999;
  text-align: center;
}
.content-div {
  margin: 20px 20px;
  color: #3c3c3c;
  font-size: small;
  line-height: 28px;
}
.final-sign {
  float: right;
  padding-bottom: 30px;
  margin-right: 30px;
}
</style>