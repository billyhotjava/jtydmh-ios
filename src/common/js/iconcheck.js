function check(name) {
	switch (name) {
		case '常用应用':
			return require('../../assets/images/appicon/changyongyingyong.png');
		case '环保监督':
			return require('../../assets/images/appicon/huanbaojiandu.png')
		case '煤矿数据':
			return require('../../assets/images/appicon/meikuangshuju.png')
		case '生产日报':
			return require('../../assets/images/appicon/shengchanribao.png')
		case '生产指标':
			return require('../../assets/images/appicon/shengchanzhibiao.png')
		case '手机报':
			return require('../../assets/images/appicon/shoujibao.png')
		case '手机报管理':
			return require('../../assets/images/appicon/shoujibaoguanli.png')
		case '天气':
			return require('../../assets/images/appicon/tianqi.png')
		case '通讯录':
			return require('../../assets/images/appicon/tongxunlu.png')
		case '通知公告':
			return require('../../assets/images/appicon/tongzhigonggao.png')
		case '值班信息':
			return require('../../assets/images/appicon/zhibanxinxi.png')
		case '资讯中心':
			return require('../../assets/images/appicon/zixunzhongxin.png')
		case 'banner':
			return require('../../assets/images/appicon/banner.png')
		case '会议纪要':
			return require('../../assets/images/appicon/huiyijiyao.png')
		default:
			return null;
	}
}



export default {
	check
}
