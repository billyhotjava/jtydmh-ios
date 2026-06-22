const IP1 = process.env.NODE_ENV === 'production' ?
	'https://ydmh.eccl.net.cn:6443/api/uia/' : '/ip1/';
const IP2 = process.env.NODE_ENV === 'production' ?
	'https://ydmh.eccl.net.cn:6443/api/ydmh/' : '/ip2/';
const IP3 = process.env.NODE_ENV === 'production' ?
	'https://ydmh.eccl.net.cn:6443/api/file/' : '/ip3/';
// 'http://10.150.104.44/api2/file/' : '/ip3/';
const IP4 = process.env.NODE_ENV === 'production' ?
	'https://ydmh.eccl.net.cn:6443/api/uia/' : '/ip4/';
const IP5 = process.env.NODE_ENV === 'production' ?
	'https://ydmh.eccl.net.cn:6443/api/ydmh/' : '/ip5/';

const IP6 = process.env.NODE_ENV === 'production' ?
	'http://10.150.104.69/api/jtdgdw/' : '/ip6/';

const YDMH = process.env.NODE_ENV === 'production' ?
	'https://mgs.sgeg.chnenergy.com.cn/' : '/ydmh/';

// App 下载
// const APP_DOWNLOAD_IP = process.env.NODE_ENV === 'production' ?
// 	'https://mgscheck.sgeg.chnenergy.com.cn/' : 'http://jtydmhapi.cloud.eccl/';

// App 下载
const APP_DOWNLOAD_IP = process.env.NODE_ENV === 'production' ?
	'https://m.sgeg.ceic.com/' : 'http://jtydmhapi.cloud.eccl/';

// const FILE_IP = process.env.NODE_ENV === 'production' ?
//     'http://10.150.104.86:30004/' : '/api/file/';

const SCRB_IMG_IP = process.env.NODE_ENV === 'production' ?
	'https://mgs.sgeg.chnenergy.com.cn/' : 'http://10.150.100.42:8080';

const YDMHEJYY = process.env.NODE_ENV === 'production' ?
	'https://mgs.sgeg.chnenergy.com.cn/' : '/idxUrl';

const FILE_IP = process.env.NODE_ENV === 'production' ?
	'http://mhfile.sgeg.ceic.com/' : '/api/file/';

export default {
	IP1,
	IP2,
	IP3,
	IP4,
	IP5,
	IP6,
	YDMH,
	FILE_IP,
	SCRB_IMG_IP,
	YDMHEJYY,
	APP_DOWNLOAD_IP,
}
