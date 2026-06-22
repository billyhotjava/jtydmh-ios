<!--个人中心-->
<template>
    <div class="tab-page has-header noticeinfo_page">
        <div class="tab-header">
            <mt-header title="个人中心">
                <a href="javascript:;" slot="left" @click="$router.back(-1)">
                    <mt-button icon="back"/>
                </a>
            </mt-header>
        </div>

        <div class="tab-content">
            <div class="person-detial">
                <div class="user_img background-blue-2">
                    <img :src="imgSrc==''?img:imgSrc" alt="">
                    <div class="vertical-center">
                        <h2>{{item.jobName}}</h2>
<!--                        <p>{{'国神集团' + '(' + item.jobName + ')'}}</p>-->
<!--                      <p>国神集团</p>-->
                    </div>
                </div>

                <div class="div-line">
                    <img src="../../assets/images/set/grzx_gs.png"/>
                    <h3>工号</h3>
                    <p>{{item.employeeCode}}</p>
                </div>

                <div class="div-line">
                    <img src="../../assets/images/set/grzx_bm.png"/>
                    <h3>部门</h3>
                    <p>{{item.orgName}}</p>
                </div>

                <div class="div-line">
                    <img src="../../assets/images/set/grzx_sj.png" @click="callMobile"/>
                    <h3>手机</h3>
                    <p>{{item.mobile}}</p>
                </div>

                <div class="div-line">
                    <img src="../../assets/images/set/grzx_yx.png"/>
                    <h3>邮箱</h3>
                    <p>{{item.email}}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import img from "../../assets/images/set/user.png"
    export default {
        name: "PersonInformation",
        data(){
            return{
                item: {},
                img,
                imgSrc:'',
            }
        },
        created(){
            if (!this.isEmpty()) {
              this.item = this.$route.params.item;
            } else {
              let user = JSON.parse(localStorage.getItem('user'));
              this.item = {
                jobName: user.fullName,
                employeeCode: user.employeeCode,
                email: user.email,
                mobile: user.telephoneNumber,
              }
            }
        },
        methods: {
          isEmpty() {
            for (let key in this.$route.params.item) {
              return false;
            }
            return true;
          },
            getUserTouXiang(){
                this.$getRequest(`${this.$config.IP3}file/${this.item.photo}/presignedurl`).then(res => {
                    if(res.data.succes){
                        this.imgSrc = res.presignedAgentUrl;
                    }else {
                        this.$toast({message: res.data.msg, className: 'inexa'});
                    }
                }).catch(() => {
                    this.$toast({message: '请求头像失败', className: 'inexa'});
                    this.imgSrc = '';
                })
            },
            callMobile(number) {
                window.plugins.CallNumber.callNumber(() => {

                }, () => {

                }, number, true);
            },
            callPhone(number){
                window.plugins.CallNumber.callNumber(() => {

                }, () => {

                }, number, true);
            }
        },

    }
</script>

<style scoped lang="scss">
    .person-detial{
        .user_img {
            width: 100%;
            height: 120px;
            div{
                float: left;
                margin-left: 20px;
            }
            img {
                width: 80px;
                height: 80px;
                float: left;
                margin-left: 40px;
                position: relative;
                top: 50%;
                transform: translateY(-50%);
                border-radius: 50%;
            }

            h2 {
                color: #fff;
                font-size: 20px;
                margin-top: 0.2rem;
                font-weight: normal;
                margin-bottom: 10px;
            }

            p {
                color: #E5E5E5;
                font-size: 16px;
            }
        }
        .div-line{
            width: 100%;
            border-bottom: 1px solid #D7D7D7;
            padding:15px 0px 15px 0px;
            display: flex;
            align-items: center;
            img{
                width: 15px;
                height: 20px;
                margin-left: 20px;
            }
            h3{
                width: 30%;
                font-size: 16px;
                font-weight: normal;
                margin-left: 10px;
                color: #525252;
            }
            p{
                width: 70%;
                font-size:16px;
                text-align: right;
                margin-right: 20px;
                margin-left: 10px;
                word-break: break-all;
                word-wrap: break-word
            }
        }

    }
</style>