var IdentifierPlugin = {
    getIden:function(callback){
       Cordova.exec(function(message){
           // alert(message)
           callback(message)
       }, this.onFailIden, "IdentifierPlugin","getIden", []);
    },
    // onSuccessIden:function(message){
    //     // alert(message)
    // },
    onFailIden:function(message){
        // alert("失败:"+message);
    }
};

module.exports = IdentifierPlugin;
