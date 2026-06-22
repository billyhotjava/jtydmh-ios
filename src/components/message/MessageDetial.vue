<template>
    <div class="tab-page has-header noticeinfo_page">
        <div class="tab-header">
            <mt-header title="消息详情" class="bb">
                <a href="javascript:;" slot="left" @click="$router.back(-1)">
                    <mt-button icon="back"/>
                </a>
            </mt-header>
        </div>

        <div class="tab-content">
            <div class="notice_inner">
                <div class="content mt10" v-html="myHtml"></div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "MessageDetial",
        data(){
            return{
                myHtml: '',
            }
        },
    }
</script>

<style scoped>

</style>