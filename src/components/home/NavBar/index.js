import Vue from 'vue'
import NavBar from './NavBar.vue'
const module = {
    install:function(){
        Vue.component('NavBar',NavBar)
    }
};
export default module
