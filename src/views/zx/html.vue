<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header :title="title" class="bb">
				<a href="javascript:;" slot="left" @click="back()">
					<mt-button icon="back" />
				</a>
			</mt-header>
		</div>
		<div class="tab-content">
			<div v-if="pageType == 5">
				<div class="bb-title">{{bbtitle}}</div>
				<div class="bb-subtitle">{{bbsubtitle}}</div>
				<div v-html="html" class="MsoNormal" @click="tokenDetail($event)"></div>
				<div class="zx-file-wrap">
					<div v-for="(item,index) in fileList" :key="index">
						<div class="file" @click="clickFile(item)">{{item.fileName}}</div>
					</div>
				</div>
			</div>
			<div v-else>
				<div v-html="html" class="xw_box" @click="tokenDetail($event)"></div>
			</div>
		</div>
	</div>
</template>

<script>
	import eventBus from '../../utils/eventBus.js';
	export default {
		name: 'html',
		data() {
			return {
				html: '',
				url: '',
				pageType: 0,
				title: '',
				fileList: [],
				bbtitle: '',
				bbsubtitle: '',
                intoType:'',
                dataList:[],
			}
		},
		mounted() {
			this.url = this.$route.query.url;
			this.pageType = this.$route.query.type;
			if (this.pageType == 1) {
				this.title = '集团公告';
			} else if (this.pageType == 2) {
				this.title = '公司公告';
			} else if (this.pageType == 3) {
				this.title = '早会纪要';
			} else if (this.pageType == 4) {
				this.title = '例会纪要';
			} else {
				this.title = '本部公告';
			};
			if (this.pageType == 5) {
				this.$getRequest(
					`${this.$config.YDMH}external/queryAnnouncementById`, {
						id: this.url,
					}).then(res => {
					this.html = res.object.msgContent;
					this.html = this.html.replace(/text-indent: [1-9][4-9][0-9].([0-9]*)+pt/g, 'text-align: right').replace(/text-indent: [1-9][4-9][0-9]+pt/g, 'text-align: right');
					this.bbtitle = res.object.titile;
					this.getName(res.object);
					if (res.object.fileList != null) {
						var list = res.object.fileList.split(',');
						if (list.length > 0) {
							for (var i = 0; i < list.length; i++) {
								let obj = {};
								this.$set(obj, 'filePath', list[i]);
								if (list[i].indexOf('附件') != -1) {
									this.$set(obj, 'fileName', list[i].replace("menhu/announcement/", ""));
								} else {
									this.$set(obj, 'fileName', list[i].replace("menhu/announcement/", "附件："));
								}
								this.fileList.push(obj);
							}
						}
					}
					// this.html = this.html.replace(/line-height: [0-9\.]+pt/g, 'font-size: 25pt');

					//修改本部公告阅读状态
					this.$getRequest(
						`${this.$config.YDMH}external/editByAnntIdAndUserId`, {
							anntId: this.url,
							employeeCode: JSON.parse(localStorage.getItem('user')).employeeCode,
						}).catch(() => {

					});
				}).catch(() => {

				});
			} else {
				this.$postRequestQuery(
					`${this.$config.YDMH}news/getHtmlDetail`, {
						url: this.url,
						type: this.pageType
					}).then(res => {
					this.html = res.object;
				}).catch(() => {

				});
			}
		},
		methods: {
			back() {
				//传递一个map，selectedId，this.pageType是value
				// eventBus.$emit('selectedId', this.pageType);
                this.$router.go(-1);
			},
			clickFile(file) {
				// TBSDemo.openOffice(encodeURIComponent(file.filePath), '1', file.fileName,
				// 	function success(success) {
        //
				// 	},
				// 	function fail(fail) {
        //
				// 	});
        let download_url = `${this.$config.YDMH}transformDownload/download?type=${1}&url=${encodeURIComponent(file.filePath)}`;
        console.log('下载地址', download_url);
        if (window.device.platform == 'Android') {
          TBSDemo.openOffice(download_url, file.fileName, success, fail);
        } else if (window.device.platform == 'iOS') {
          OpenWebViewPlugin.openFile(download_url, file.fileName, success, fail);
        }
        function success(success) {
          console.log('成功打开文件', success);
        }
        function fail(fail) {
          that.$toast({
            message: '文件打开失败，错误原因' + fail.toString(),
            className: 'inexa'
          });
        }
			},
			tokenDetail(e) {
				console.log(e);
				event.preventDefault();
				let that = this;
				if (e.target.nodeName === 'A') {
					//A标签点击,href是地址
					let type = 1;
					if (this.pageType == 1) {
						type = 3;
					} else if (this.pageType == 5) {
						type = 1;
					} else if (this.pageType == 2) {
						type = 4;
					} else if (this.pageType == 4) {
						type = 6;
					}
					if (e.target.innerText != '') {
						// TBSDemo.openOffice(encodeURIComponent(e.target.href), type, e.target.innerText,
						// 	function success(success) {
            //
						// 	},
						// 	function fail(fail) {
						// 		that.$toast({
						// 			message: '文件打开失败，错误原因' + fail.toString(),
						// 			className: 'inexa'
						// 		});
						// 	});
            let download_url = `${this.$config.YDMH}transformDownload/download?type=${type}&url=${encodeURIComponent(e.target.href)}`;
            console.log('下载地址', download_url);
            if (window.device.platform == 'Android') {
              TBSDemo.openOffice(download_url, e.target.innerText, success, fail);
            } else if (window.device.platform == 'iOS') {
              OpenWebViewPlugin.openFile(download_url, e.target.innerText, success, fail);
            }
            function success(success) {
              console.log('成功打开文件', success);
            }
            function fail(fail) {
              that.$toast({
                message: '文件打开失败，错误原因' + fail.toString(),
                className: 'inexa'
              });
            }
					} else {
						this.$toast({
							message: '文件链接获取失败，请重新进入页面',
							className: 'inexa'
						});
					}
				}
				return false;
			},
			getName(content) {
				this.$getRequest(`${this.$config.YDMH}external/getUserNameAndOrgName`, {
					employeeCode: content.createBy,
				}).then(res => {
					if (res.object) {
						this.bbsubtitle = '起草人: ' + res.object.userName + '\u3000发布时间:' + content.sendTime;
					}
				}).catch((err) => {});
			},
		},
	}
</script>

<style lang="scss">
	.xw_box {
		overflow-x: none !important;
		background-color: #FFFFFF !important;
		padding: 10px 15px 10px 15px;

		p {
			font-size: 14px;
			line-height: 240%;

			span {
				font-size: 14px !important;
				width: 100% !important;
			}

			em {
				font-style: normal
			}

			a {
				color: #206EEA;
			}
		}

		.fz12 {
			font-style: inherit;
			font-size: 13px;
			margin: 5px 0px;
			line-height: 180%;
			font-weight: bold;
			text-align: center;
		}
	}

	.bb-title {
		font-size: 20px;
		margin: 10px 10px;
		font-weight: bold;
		text-align: center;
		line-height: 120%;
	}

	.bb-subtitle {
		font-size: 13px;
		margin: 8px 0px;
		font-weight: bold;
		text-align: center;
	}

	.MsoNormal {
		font-size: 14px;
		// padding: 10px 15px 10px 15px;
		padding: 5px 15px 5px 15px;

		p {
			font-size: 14px;
			line-height: 240% !important;

			span {
				font-size: 14px !important;
				width: 100% !important;
			}
		}
	}

	.zx-file-wrap {
		margin-bottom: 20px;
	}

	.file {
		padding: 5px 20px 5px 20px;
		font-size: 14px;
		color: #206EEA;
	}

	.fz24 {
		font-size: 20px;
		text-align: center;
		line-height: 25px;
	}

	.mt20 {
		margin-top: 10px;
		margin-bottom: 5px;
	}


	.xl_tit {
		font-size: 20px;
		margin: 10px 0px;
		font-weight: bold;
		text-align: center;
		line-height: 120%;
	}

	.xl_tit1 {
		font-size: 13px;
		margin: 8px 0px;
		font-weight: bold;
		text-align: center;
	}

	.xl_con {

		p {
			font-size: 14px;

			span {
				font-size: 14px !important;
				width: 100% !important;

			}
		}

		span {
			font-size: 14px !important;
		}
	}

	.attach {
		margin: 10px 0px;

		a {
			font-size: 15px !important;
			color: #0000FF;
		}
	}
</style>
