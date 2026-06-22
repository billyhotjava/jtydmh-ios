<template>
    <div class="guide">
        <mt-swipe :auto="0" :continuous="false" :prevent="true" @change="handleChange">
            <mt-swipe-item v-for="(item,index) in list" :key="index">
                <img :src="item.src" alt="banner">

                <h2>{{item.title}}</h2>
                <p>{{item.desc}}</p>
            </mt-swipe-item>
        </mt-swipe>

        <mt-button type="primary"  v-if="showBtn" @click="$router.replace('/login')">开始体验</mt-button>
    </div>
</template>


<script>
    import src1 from './../assets/images/guide1.png'
    import src2 from './../assets/images/guide2.png'
    import src3 from './../assets/images/guide3.png'
    export default {
        name: 'Guide',
        data() {
            return {
                src1,
                list:[
                    {
                        src: src1,
                        title: '指标数据随时掌握',
                        // desc: '工作进度实时掌握'
                    },{
                        src: src2,
                        title: '通知公告统一查看',
                        // desc: '任务进度一目了然'
                    },{
                        src: src3,
                        title: '移动应用方便高效',
                        // desc: '团队沟通、协作更高效'
                    },
                ],
                showBtn: false,
            }
        },
        methods:{
            handleChange(index){
                if(index == 2){
                    this.showBtn = true;
                }
            },
        }
    }
</script>

<style lang="scss">
   .guide{
       height: 100%;
       overflow: hidden;
       text-align: center;

       .mint-swipe {
           height: 100vh;
           padding-top: 0vh;
           width: 100vw;
           box-sizing: border-box;
       }

       .mint-swipe-item {
           img {
               height: 331px;
               width: 316px;
               margin: 18vh 10vw 5vh 10vw;
           }
       }

       .mint-swipe-indicators {
           bottom: 15vh;

           .mint-swipe-indicator {
               margin: 0 .25rem;
               background-color: #fff;
               border: 1px solid #427fed;
               opacity: 1;

               &.is-active {
                   background-color: #427fed;
               }
           }

       }

       h2{
           color: #58647d;
           margin-top: 2vh;
		   font-size: 20px;
       }
       p{
           margin-top: 1rem;
           font-size: 0.8rem;
           color: #c9ccd4;
       }

       .mint-button{
           position: absolute;
           bottom:2rem;
           transform: translateX(-50%);
       }
   }
</style>
