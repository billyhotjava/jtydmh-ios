<!--应用编辑页面-->
<template>
    <div class="tab-page has-header noticeinfo_page">
        <div class="tab-header">
            <mt-header title="常用应用编辑">
                <a href="javascript:;" slot="left" @click="$router.back(-1)">
                    <mt-button icon="back"/>
                </a>
                <mt-button slot="right" style="margin-right: 10px" @click="saveMenu()" v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击常用应用编辑的保存按钮', actionType:'application-edit-save-click'}">保存</mt-button>
            </mt-header>
        </div>

        <div class="tab-content">

            <!--<div v-for="(menu, index) in menus" :key="index">-->
                <!--<div style="height: 20px; padding: 10px;">-->
                    <!--<div style="font-size: 16px; font-weight: bold; margin-left: 5px; margin-top: 10px">{{menu.name}}</div>-->
                <!--</div>-->

                <!--<div v-if="menu.name=='常用应用'" class="div-wrap">-->
                    <!--<div v-for="(item, j) in menu.data" :key="j"  class="colum-item"-->
                         <!--v-dragging="{item: item, list: menu.data, group: 'item'}">-->
                        <!--<img :src="item.url" alt="图标"  class="icon-yy">-->
                        <!--<img src="../../assets/images/application/delete.png" class="icon-add-delete" @click="deleteApp(item, j)"/>-->
                        <!--<div class="icon-name">{{item.name}}</div>-->
                    <!--</div>-->
                <!--</div>-->

                <!--<div v-else class="div-wrap">-->
                    <!--<div v-for="(item, j) in menu.data" :key="j"  class="colum-item">-->
                        <!--<img :src="item.url" alt="图标" class="icon-yy">-->
                        <!--<img src="../../assets/images/application/add.png" class="icon-add-delete" @click="addApp(item, j)"/>-->
                        <!--<div class="icon-name">{{item.name}}</div>-->
                    <!--</div>-->
                <!--</div>-->
            <!--</div>-->

            <div v-for="(cymenu, index) in cyMenus" :key="index">
                <div style="height: 20px; padding: 10px;">
                    <div style="font-size: 16px; font-weight: bold; margin-left: 5px; margin-top: 10px">{{cymenu.name}}</div>
                </div>

                <div class="div-wrap">
                  <vuedraggable v-model="cymenu.data" class="div-wrap" :delay="100">
                    <div v-for="(cyitem, cy) in cymenu.data" :key="cy"  class="colum-item">
                      <img v-if="cyitem.url != undefined && cyitem.url.length != 0" :src="getImgUrl(cyitem)" alt="图标"  class="icon-yy"/>
                      <img v-else :src='application_placeholder_image' alt="图标"  class="icon-yy">
                      <img src="../../assets/images/application/delete.png" class="icon-add-delete" @click="deleteApp(cyitem, cy)"/>
                      <div class="icon-name">{{cyitem.name}}</div>
                    </div>
                  </vuedraggable>
                </div>
            </div>

            <div v-for="(allmenu, index1) in allMenus" :key="index1">
                <div style="height: 20px; padding: 10px;">
                    <div style="font-size: 16px; font-weight: bold; margin-left: 5px; margin-top: 10px">{{allmenu.classifyName}}</div>
                </div>

                <div class="div-wrap">
                    <div v-for="(allitem, all) in allmenu.applicationList" :key="all"  class="colum-item">
                        <div>
                          <img v-if="allitem.url != undefined && allitem.url.length != 0" :src="getImgUrl(allitem)" alt="图标" class="icon-yy">
                          <img v-else :src='application_placeholder_image' alt="图标" class="icon-yy">
                            <img src="../../assets/images/application/add.png" class="icon-add-delete" @click="addApp(allitem, all)"/>
                            <div class="icon-name">{{allitem.name}}</div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>

<script>
    import scroll from '../../components/application/scroll'
    import application_placeholder_image from '@/assets/images/application/placeholder_image.png'
    import vuedraggable from 'vuedraggable'

    export default {
        name: "ApplicationEdit",
        components:{
          scroll,
          vuedraggable,
        },
        data(){
            return{
                cyMenus: [],
                allMenus: [],
                positionId:[],
                user: JSON.parse(localStorage.getItem('user')),
              application_placeholder_image: application_placeholder_image
            }
        },
        mounted(){
          // 拖拽后触发的事件
          this.$dragging.$on('dragged', (res) => {
            console.log('拖拽', JSON.stringify(res.value.list));
            console.log('数据', JSON.stringify(this.cyMenus));
          });
          this.positionId = this.user.positionId.split(",");
          this.queryCyApp();
        },
      methods:{
            queryCyApp(){
                this.$postRequest(`${this.$config.YDMH}application/obtainCommonUseApplication`, {
                    userCode: this.user.employeeCode,
                    orgCode: this.user.orgCode,
                    positionIdList: this.positionId,
                }).then(res => {
                  let name = '常用应用';
                  this.cyMenus.push({
                    name: name,
                    data:res.list,
                  });
                  this.queryAllApp();
                  this.cyMenuData(res.list,name);
                    // if (res.list.length > 0) {
                    //     var name = '常用应用';
                    //     this.cyMenuData(res.list,name);
                    // }
                }).catch(() => {

                });
            },

            async cyMenuData(applicationList,name){
              if(applicationList.length > 0) {
                let that = this;
                applicationList.forEach(function (menu, index) {
                  that.$set(menu, 'url', `${that.$config.YDMH}transformDownload/download?type=2&fileId=${menu.iconAttachmentId}`);
                  // that.$getRequest(`${that.$config.FILE_IP}file/${menu.iconAttachmentId}/presignedurl`, {}).then(res => {
                  //   that.$set(menu, 'url', res.presignedAgentUrl);
                  // }).catch((err) => {
                  //   console.log('获取 图标 失败', err);
                  // });
                });
              }
            },

            queryAllApp(){
                this.$postRequest(`${this.$config.YDMH}application/obtainApplicationListByUser`, {
                    userCode: this.user.employeeCode,
                    orgCode: this.user.orgCode,
                    positionIdList: this.positionId,
                }).then(res => {
                      res.list.forEach((menu) => {
                        let applicationList = menu.applicationList;
                        let cyList = this.cyMenus[0].data;
                        for (let m = 0; m < cyList.length; m++) {
                          for (let j = 0; j < applicationList.length; j++) {
                            if (cyList[m].id == applicationList[j].id) {
                              applicationList.splice(j, 1);
                            }
                          }
                        }
                      });
                      this.allMenus = res.list;
                      this.allMenuData();
                }).catch(() => {

                });
            },
            async allMenuData(){
              let that = this;
              this.allMenus.forEach((menu) => {
                let applicationList = menu.applicationList;
                applicationList.forEach((application) => {
                  that.$set(application, 'url', `${that.$config.YDMH}transformDownload/download?type=2&fileId=${application.iconAttachmentId}`);
                  // that.$getRequest(
                  //     `${that.$config.FILE_IP}file/${application.iconAttachmentId}/presignedurl`, {}
                  // ).then(res => {
                  //   that.$set(application, 'url', res.presignedAgentUrl);
                  // }).catch((err) => {
                  //   console.log('获取 图标 失败', err);
                  // });
                });
              });
            },
            addApp(item, index){
                this.cyMenus[0].data.push(item);
                for(let i = 0; i < this.allMenus.length; i++){
                    let data = this.allMenus[i].applicationList;
                    for(var j = 0; j < data.length; j++){
                        if(data[j].id == item.id){
                            data.splice(index,1);
                        }
                    }
                }
            },
            deleteApp(item, index){
                this.cyMenus[0].data.splice(index,1);
                for(var i = 0; i < this.allMenus.length; i++){
                    if(this.allMenus[i].classifyId == item.appClassifyId){
                        this.allMenus[i].applicationList.push(item);
                    }
                }
            },
            saveMenu(){
                var applicationIds = [];
                for(let comApp of this.cyMenus[0].data){
                    applicationIds.push(comApp.id);
                }
                let that = this;
                let newApplicationIds = applicationIds.map((item, index) => {
                    var info = {'applicationId': item};
                    info.showIndex = index;
                    // info.userCode = that.user.employeeCode;
                    return info;
                });
                this.$postRequest(`${this.$config.YDMH}application/saveCommonUseApplication`, {
                  'commonUseApplicationList': newApplicationIds,
                  'userCode': this.user.employeeCode
                }).then(res => {
                    this.$toast({message: '保存成功', className: 'inexa'});
                    this.bus.$emit('refresh');
                    this.$router.back(-1);
                }).catch(() => {

                });
            },
			getImgUrl(item) {
				let img = this.$check.check(item.name);
				if (img != null) {
					console.log();
					return img;
				}else{
					return item.url;
				}
			}
        }
    }
</script>

<style scoped>

    /*设置自动换行*/
    .div-wrap{
      display: flex;
      flex-wrap: wrap;
      margin: 10px 0px;
      width: 100%;
    }
    .colum-item{
        /*设置每一个小组建的宽度占比*/
      width: 25%;
      margin: 10px 0px 10px 0px;
    }
    .icon-yy{
        width: 45px;
        height: 45px;
        position: relative;
        left: 55%;
        transform: translateX(-50%);
        position: relative;
        transform: translateX(-50%);
        margin-left: -10px;
    }
    .icon-add-delete{
        width: 15px;
        height: 15px;
        position: relative;
        left: 50%;
        transform: translateX(-50%);
        vertical-align:top;
        margin-left: -10px;
    }
    .icon-name{
        line-height: 40px;
        height: 40px;
        text-align: center;
        margin-left: -10px;
    }
</style>