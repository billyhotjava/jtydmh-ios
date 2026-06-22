//全局常量/函数

/**
 * 系统代码
 */
const sysCode='ydmh';

//是否
const yesOrNo={
    yes: '1',
    no:'0'
};

//登陆日志类型
const loginLogType={
    login: '1', //登陆
    logout:'2'  //退出
};
/**
 * 获取query请求形式参数
 */
export function getQueryUrl(url, params){
    let _url = url;
	// console.log(params);
    if(params){
        _url += '?';
        for(let i in params){
            _url += `${i}=${params[i]}&`
        }
        _url = _url.slice(0,_url.length-1)
    }
    return _url;
}

/**
 * 日期格式 yyyy-mm-dd
 */
function formatDate (date) {
    if (!date) return '';
    let DATE = new Date(date);
    return `${DATE.getFullYear()}-${DATE.getMonth() + 1}-${DATE.getDate()}`;
}

//去除数组中的空值
function trimSpace(array){
    for(var i = 0 ;i<array.length;i++) {
        if(array[i] == "" || typeof(array[i]) == "undefined") {
            array.splice(i,1);
            i= i-1;
        }
    }
    return array;
}


    

export default {
    sysCode,
    yesOrNo,
    loginLogType,
    formatDate,
    trimSpace,
 
}




