import Vue from 'vue'
import Router from 'vue-router'

const PhonePageManager = () => import('./views/sjb/PhonePageManager.vue');
const PhonePageDetail = () => import('./views/sjb/PhonePageDetail.vue');
const PhonePageEdit = () => import('./views/sjb/PhonePageEdit.vue');
const DutyInfo = () => import('./views/zbxx/DutyInfo.vue');
const DutyDetail = () => import('./views/zbxx/DutyDetail.vue');
const WeatherForecast = () => import('./views/tqyb/WeatherForecast.vue');
const WeatherDetail = () => import('./views/tqyb/WeatherDetail.vue');
const DailyProductionReport = () => import('./views/scrb/DailyProductionReport.vue');
const DailyProductionReportDetail = () => import('./views/scrb/DailyProductionReportDetail.vue');

const Home = () => import('./views/Home.vue');
const Guide = () => import('./views/Guide.vue');
const Login = () => import('./views/Login.vue');
const MessageDetial = () => import('./components/message/MessageDetial.vue');
const PersonInformation = () => import('./components/set/PersonInformation');
const ApplicationEdit = () => import('./components/application/ApplicationEdit');
const GestureLock = () => import('./components/set/GestureLock');
const Zx = () => import('./views/zx/Zx');
const infomationDetail = () => import('./views/zx/html.vue');
const GestureVerification = () => import('./views/GestureVerification');
const Loading = () => import('./views/Loading');
const SearchList  = () => import('./components/application/SearchList');
const PersonAddress = () => import('./views/txl/PersonAddress.vue');
const web = () => import('./views/zx/web');
const tabOld = () => import('./views/TabOld.vue');

Vue.use(Router);

export default new Router({
    mode:'hash',
    routes: [
        {
            // path: '/',
            // redirect: '/login',

            path: '/',
            redirect: '/guide',
        },
		{
		    path: '/tabOld',
		    name: 'tabOld',
		    component: tabOld,
		    meta: {
		        index: 0
		    },
		},
        {
            path: '/guide',
            name: 'guide',
            component: Guide,
            meta: {
                index: 0
            },
        },
        {
            path: '/loading',
            name: 'loading',
            component: Loading,
            meta: {
                index: 0
            },
        },
        {
            path: '/gv',
            name: 'gv',
            component: GestureVerification,
            meta: {
                index: 1
            },
        },
        {
            path: '/login',
            name: 'Login',
            component: Login,
            meta: {
                index: 2
            },
        },
        {
            path: '/home',
            name: 'home',
            component: Home,
            meta: {
                index: 3
            },
        },
        {
            path: '/appedit',
            name: 'appedit',
            component: ApplicationEdit,
            meta: {
                index: 4
            },
        },

        {
            path: '/messagedetal',
            name: 'messagedetal',
            component: MessageDetial,
            meta: {
                index: 4
            },
        },
        {
            path: '/grzx',
            name: 'grzx',
            component: PersonInformation,
            meta: {
                index: 4
            },
        },

        {
            path: '/gesturelock',
            name: 'gesturelock',
            component: GestureLock,
            meta: {
                index: 4,
				allowBack: false
            },
        },
        {
            path: '/appsearch',
            name: 'appsearch',
            component: SearchList,
            meta: {
                index: 4
            },
        },
        {
            path: '/information',
            name: 'zx',
            component: Zx,
            meta: {
                index: 4
            },
        },
		{
		    path: '/infomationDetail',
		    name: 'detail',
		    component: infomationDetail,
		    meta: {
		        index: 5
		    },
		},
        {
            path: '/personaddress',
            name: 'personaddress',
            component: PersonAddress,
            meta: {
                index: 4
            },
        },
        {
            path: '/xinwen',
            name: 'phonepagemanager',
            component: PhonePageManager,
            meta: {
                index: 3
            },
        },
        {
            path: '/phonepagedetail',
            name: 'phonepagedetail',
            component: PhonePageDetail,
            meta: {
                index: 4
            },
        },
        {
            path: '/phonepageedit',
            name: 'phonepageedit',
            component: PhonePageEdit,
            meta: {
                index: 5
            },
        },
        {
            path: '/phonepagepreview',
            name: 'phonepagepreview',
            component: PhonePageDetail,
            meta: {
                index: 6,
            },
        },
		{
		    path: '/web',
		    name: 'web',
		    component: web,
		    meta: {
		        index: 5
		    },
		},
        {
            path: '/zhiban',
            name: 'zhiban',
            component: DutyInfo,
            meta: {
                index: 3
            },
        },
		{
		    path: '/zhibanDetail',
		    name: 'zbDetail',
		    component: DutyDetail,
		    meta: {
		        index: 4
		    },
		},
        {
            path: '/weather',
            name: 'weather',
            component: WeatherForecast,
            meta: {
                index: 3
            },
        },
        {
            path: '/weatherdetail',
            name: 'weatherdetail',
            component: WeatherDetail,
            meta: {
                index: 4
            },
        },
        {
            path: '/rb',
            name: 'rb',
            component: DailyProductionReport,
            meta: {
                index: 3
            }
        },
        {
            path: '/dailyproductionreportdetail',
            name: 'dailyproductionreportdetail',
            component: DailyProductionReportDetail,
            meta: {
                index: 4
            }
        },
        {
            path: '/coal',
            name: 'coal',
            component: () => import('./views/mk/CoalRealData.vue'),
            meta: {
                index: 5
            }
        },
        {
            path: '/hbrb',
            name: 'hbrb',
            component: () => import('./views/hbjd/Hbrb.vue'),
            meta: {
                index: 5
            }
        },
        {
            path: '/hbzb',
            name: 'hbzb',
            component: () => import('./views/hbjd/Hbzb.vue'),
            meta: {
                 index: 7
        }
        },
        {
            path: '/hbjd',
            name: 'hbjd',
            component: () => import('./views/hbjd/Hbjd.vue'),
            meta: {
                 index: 7
        }
        },
        {
            path: '/hdyy',
            name: 'hdyy',
            component: () => import('./views/scjyzb/Hdyy.vue'),
            meta: {
                index: 5
            }
        },
        {
            path: '/fdyy',
            name: 'fdyy',
            component: () => import('./views/scjyzb/Fdyy.vue'),
            meta: {
                index: 5
            }
        },
        {
            path: '/gfyy',
            name: 'gfyy',
            component: () => import('./views/scjyzb/Gfyy.vue'),
            meta: {
                index: 5
            }
        },
        {
            path: '/aqfx',
            name: 'aqfx',
            component: () => import('./views/scjyzb/Aqfx.vue'),
            meta: {
                index: 7
            }
        },
        {
            path: '/scjyzb',
            name: 'scjyzb',
            component: () => import('./views/scjyzb/Scjyzb.vue'),
            meta: {
                index: 6
            }
        },
        {
            path: '/scjyzbelectric',
            name: 'scjyzbelectric',
            component: () => import('./views/scjyzb/ScjyzbElectric/ScjyzbElectric.vue'),
            meta: {
                index: 7
            }
        },
        {
            path: '/hbfx',
            name: 'hbfx',
            component: () => import('./views/scjyzb/Hbfx.vue'),
            meta: {
                index: 8
            }
        },
        {
            path: '/mksssj',
            name: 'mksssj',
            component: () => import('./views/mksssj/Mksssj.vue'),
            meta: {
                index: 9
            }
        },
        {
            path: '/ssjc',
            name: 'ssjc',
            component: () => import('./views/hbjd/Ssjc.vue'),
            meta: {
                index: 10
            }
        },
        {
            path: '/rcxhz',
            name: 'rcxhz',
            component: () => import('./views/hbjd/Rcxhz.vue'),
            meta: {
                index: 10
            }
        },
        {
            path: '/scjyzbgfyy',
            name: 'scjyzbgfyy',
            component: () => import('./views/scjyzb/ScjyzbElectric/Scjyzbgfyy.vue'),
            meta: {
                index: 7
            }
        },
        {
            path: '/zxsearch',
            name: 'zxsearch',
            component: () => import('./components/zx/ZxSearch.vue'),
            meta: {
                index: 10
            }
        },
    ]
})
