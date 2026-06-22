import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        user: {},
        org: {
            deptId: '',
            deptName: '',
            orgId: '',
            orgName: ''
        },
        device: {
            serial: '',
            platform: ''
        },
        keepAlive: [],
		gvcanback: true,
    },
    getters: {
        getUser(state) {
            return state.user;
        },
        getOrg(state) {
            return state.org;
        },
        getDevice(state) {
            return state.device;
        },
        getKeepAlive(state) {
            return state.keepAlive;
        },
		getGvcanBack(state){
			 return state.gvcanback;
		},
    },
    mutations: {
        login(state, user) {
            state.user = user;
        },
        changeKeepAlive(state, keepAlive) {
            state.keepAlive = keepAlive;
        },
        changeOrg(state, org) {
            state.org.deptId = org.deptId;
            state.org.deptName = org.deptName;
            state.org.orgId = org.orgId;
            state.org.orgName = org.orgName;
        },
        changeDevice(state, device) {
            state.device.serial = device.serial;
            state.device.platform = device.platform;
        },
        logout(state) {
            state.user = {};
            state.keepAlive = [];
            state.org.deptId = '';
            state.org.deptName = '';
            state.org.orgId = '';
            state.org.orgName = '';
        },
		changegvback(state, gvcanback){
			state.gvcanback = gvcanback;
		}
    },
    actions: {}
})
