import Vue from 'vue'
import Banner from './Banner.vue'
const module = {
    install:function(){
        Vue.component('Banner',Banner)
    }
};
export default module
