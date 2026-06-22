<template>
	<div class="tab-page has-header background-white">
		<div class="tab-header">
			<mt-header :title="navigationTitle" class="sjb-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
				<mt-button slot="right" class="preview-button" @click="showPreview">
					预览
				</mt-button>
			</mt-header>
		</div>
		<div class="content-container tab-content">
			<div class="field-container">
				<van-field v-model="title" label="标题" />
			</div>

			<div class="content-date">
				<van-field v-model="inputCurrentDate" center label="日期" placeholder="日期格式为:年-月-日"
					:value="inputCurrentDate" @input="changeInput" readonly>
					<!--					<template #button>-->
					<!--						<van-button type="default" class="get-currentdate-button" @click="getCurrentDate">一键获取-->
					<!--						</van-button>-->
					<!--					</template>-->
				</van-field>
				<van-field v-model="lunarDate" label="农历" placeholder="填写日期自动获取" readonly />
			</div>
			<div class="content-text">内容编辑</div>
			<div class="edit-wrap">
				<quill-editor v-model="content" ref="myQuillEditor" :options="editorOption" @blur="onEditorBlur()"
					@focus="onEditorFocus()" @ready="onEditorReady()">
				</quill-editor>
			</div>
			<van-field v-model="tail" label="落款" />
			<div class="publish-container" v-if="isEdit == false">
				<van-button type="default" class="bottom-button" @click="saveAsDraftEvent">保存为草稿</van-button>
				<van-button type="default" class="bottom-button" @click="publishEvent">发布</van-button>
			</div>
			<div class="publish-container" v-else>
				<van-button type="default" class="bottom-button" @click="rePublishEvent">发布</van-button>
			</div>
		</div>
	</div>
</template>

<script>
	import {
		calendar
	} from '@/lunarCalendar.js';

	export default {
		name: "PhonePageEdit",
		comments: {

		},
		props: {

		},
		data() {
			return {
				isEdit: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).isEdit,
				navigationTitle: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).isEdit == false ? '新建手机报' : '编辑手机报',
				inputCurrentDate: '',
				content: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).content,
				editorOption: {},
				lunarDate: '',
				title: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).title ? JSON.parse(localStorage.getItem(
					'tempPhoneNewsKey')).title : '国神公司手机快报',
				tail: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).inscribe ? JSON.parse(localStorage.getItem(
					'tempPhoneNewsKey')).inscribe : '集团办公室'
			}
		},
		mounted() {
			if (JSON.parse(localStorage.getItem('tempPhoneNewsKey')).releaseDate) {
				this.inputCurrentDate = JSON.parse(localStorage.getItem('tempPhoneNewsKey')).releaseDate;
				this.lunarDate = JSON.parse(localStorage.getItem('tempPhoneNewsKey')).chineseLunarCalendar;
			} else {
				let currentDate = new Date();
				this.inputCurrentDate = this.formatDate(currentDate);
				this.getLunarDate(this.inputCurrentDate);
			}
		},
		methods: {
			formatDate(date) {
				return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
			},
			changeInput(date) {
				this.inputCurrentDate = date;
				this.getLunarDate(this.inputCurrentDate);
			},
			// getCurrentDate() {
			// 	this.getLunarDate(this.inputCurrentDate);
			// },
			getLunarDate(inDate) {
				let list = this.checkInputCurrentDateValid(inDate);
				if (list && list.length != 0) {
					let lunarInfo = calendar.solar2lunar(list[0], list[1], list[2]);
					// this.lunarDate = lunarInfo.gzYear + '(' + lunarInfo.Animal + ')年' + ' ' + lunarInfo.IMonthCn +
					// 	lunarInfo.IDayCn + ' ' + lunarInfo.ncWeek;
					this.lunarDate = lunarInfo.gzYear + lunarInfo.Animal + '年' + ' ' + lunarInfo.IMonthCn +
						lunarInfo.IDayCn;
				}
				//
				// let date = inDate.replace(/\s*/g,'');
				// let list = date.split('-');
				// if (list.length < 3) {
				//   list = date.split('/');
				//   if (list.length >= 3 && list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
				//     let lunarInfo = calendar.solar2lunar(list[0], list[1], list[2]);
				//     this.lunarDate = lunarInfo.gzYear + '(' + lunarInfo.Animal + ')年' + ' ' + lunarInfo.IMonthCn + lunarInfo.IDayCn + ' ' + lunarInfo.ncWeek;
				//   } else {
				//     this.lunarDate = '';
				//     console.log('in 日期格式错误', list);
				//   }
				// } else {
				//   if (list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
				//     let lunarInfo = calendar.solar2lunar(list[0], list[1], list[2]);
				//     this.lunarDate = lunarInfo.gzYear + '(' + lunarInfo.Animal + ')年' + ' ' + lunarInfo.IMonthCn + lunarInfo.IDayCn + ' ' + lunarInfo.ncWeek;
				//   } else {
				//     this.lunarDate = '';
				//     console.log('in 日期格式错误', list);
				//   }
				// }
			},
			saveDataToLocal() {
				var phoneNewInfo = JSON.parse(localStorage.getItem('tempPhoneNewsKey'));
				phoneNewInfo.title = this.title;
				phoneNewInfo.content = this.content;
				phoneNewInfo.releaseDate = this.inputCurrentDate;
				phoneNewInfo.chineseLunarCalendar = this.lunarDate;
				phoneNewInfo.inscribe = this.tail;
				localStorage.setItem('tempPhoneNewsKey', JSON.stringify(phoneNewInfo));
			},
			showPreview() {
				this.saveDataToLocal();
				let phoneNewInfo = JSON.parse(localStorage.getItem('tempPhoneNewsKey'));
				this.$router.push({
					name: 'phonepagepreview',
					params: {
						item: phoneNewInfo,
						isLoadLocalData: true
					}
				});
			},
			saveOrRelease(isRelease, callback) {
				this.saveDataToLocal();
				this.$postRequest(`${this.$config.YDMH}mobileNews/save`, {
					// chineseLunarCalendar: this.lunarDate,
					content: this.content,
					// createTime: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).createTime,
					// updateTime: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).updateTime,
					// releaseDate: this.inputCurrentDate,
					id: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).id,
					inscribe: this.tail,
					state: isRelease == true ? 1 : 0,
					title: this.title
				}).then(res => {
					console.log('保存或发布手机报成功 ', res);
					callback();
				}).catch(err => {
					console.log('获取手机报失败 ', err);
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			onEditorBlur() {
				console.log('blur', this.content);
			},
			onEditorFocus() {
				console.log('focus', this.content);
			},
			onEditorReady() {
				console.log('ready', this.content);
			},
			checkInputCurrentDateValid(inDate) {
				let date = inDate.replace(/\s*/g, '');
				let list = date.split('-');
				if (list.length < 3) {
					list = date.split('/');
					if (list.length == 3 && list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
						return list;
					} else {
						this.lunarDate = '';
						return [];
					}
				} else {
					if (list.length == 3 && list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
						return list;
					} else {
						this.lunarDate = '';
						return [];
					}
				}
			},
			saveAsDraftEvent() {
				let that = this;
				this.saveOrRelease(false, function() {
					that.$toast({
						message: '成功保存为草稿',
						className: 'inexa'
					});
					that.$router.back(-1);
				});
			},
			publishEvent() {
				let that = this;
				let list = this.checkInputCurrentDateValid(this.inputCurrentDate);
				console.log('发布... ', list);
				if (list && list.length != 0) {
					console.log('发布 ', this.content);
					this.saveOrRelease(true, function() {
						that.$toast({
							message: '发布成功',
							className: 'inexa'
						});
						that.$router.back(-1);
					});
				} else {
					this.$toast({
						message: '请填写正确的日期格式',
						className: 'inexa'
					});
				}
			},
			rePublishEvent() {
				console.log('再发布 ', this.content);
				this.saveDataToLocal();
				this.$postRequest(`${this.$config.YDMH}mobileNews/update`, {
					// chineseLunarCalendar: this.lunarDate,
					content: this.content,
					// createTime: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).createTime,
					// updateTime: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).updateTime,
					// releaseDate: this.inputCurrentDate,
					id: JSON.parse(localStorage.getItem('tempPhoneNewsKey')).id,
					inscribe: this.tail,
					state: 1,
					title: this.title
				}).then(res => {
					console.log('再发布手机报成功 ', res);
					this.$toast({
						message: '发布成功',
						className: 'inexa'
					});
					this.$router.back(-1);
				}).catch(err => {
					console.log('再发布手机报失败 ', err);
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			}
		}
	}
</script>

<style scoped>
	.content-container {
		/*margin-top: 15px;*/
	}

	.content-title {
		font-size: x-large;
		text-align: center;
	}

	.field-container {
		margin-top: 15px;
	}

	.content-date {
		/*font-size: medium;*/
		/*text-align: center;*/
		/* display: flex; */
	}

	.preview-button {
		vertical-align: middle;
		margin-right: 10px;
	}

	.input-date {
		width: 50%;
		height: 28px;
		font-size: 13px;
		border: 1px solid #D2D2D2;
		border-radius: 14px;
		text-align: center;
	}

	.get-currentdate-button {
		height: 28px;
		text-align: center;
		color: white;
		border: none;
		background: #3b87f6;
		border-radius: 14px;
		border: none;
	}

	.bottom-container {
		display: flex;
		flex-direction: column;
		align-items: flex-end;
		margin: 20px 30px;
	}

	.content-date {
		margin: 0px 0px;
		font-size: 14px;
		color: #999999;
		text-align: center;
	}

	.final-sign {
		margin: 20px 0px;
	}

	.van-cell {
		background: #f5f5f5;
	}

	.publish-container {
		margin-top: 40px;
		padding-bottom: 30px;
		width: 100%;
		display: flex;
		justify-content: space-around;
	}

	.bottom-button {
		width: 35%;
		height: 36px;
		color: white;
		background: #206EEA;
		border-radius: 18px;
	}

	.content-text {
		color: #646566;
		margin-left: 16px;
		margin-right: 16px;
		padding: 13px 0px 5px 0px;
		font-size: 14px;
		border-top: 1px solid #ebedf0;
	}

	.edit-wrap {
		margin: 10px 16px;
	}

	>>>.ql-editor {
		min-height: 100px;
	}
</style>
