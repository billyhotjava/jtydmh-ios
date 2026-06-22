<template>
	<div>
		<!--<mt-navbar v-model="selected" class="bb notice_tabs">-->
		<!--<mt-tab-item v-for="(item,index) in tabsList" :key="index" :id="index">{{item.propName}}</mt-tab-item>-->
		<!--</mt-navbar>-->

		<!--<van-tabs sticky offset-top="45px" v-model="selected" class="bb notice_tabs" title-active-color="#000" color="#206EEA" swipeable>-->
			<!--<van-tab v-for="(item,tabdex) in tabsList" :key="tabdex" :id="tabdex" :title="item.propName">-->
				<!--<div class="bgwhite notice_list bb" v-for="(item,index) in NoticeList" :key="index">-->
					<!--<div v-if="tabdex == 2">-->
						<!--<div @click="lookNotice(item)" class="wrap-content"-->
							<!--v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击进入${item.titile}的消息`, actionType:'home-tab-detail-click'}">-->
							<!--<div class="flex">-->
								<!--<div class="flex1">-->
									<!--<p class="abstract desc">{{item.titile}}</p>-->
									<!--<div>-->
										<!--<p class="date">{{item.createTime}}</p>-->
									<!--</div>-->
								<!--</div>-->
							<!--</div>-->
						<!--</div>-->
					<!--</div>-->
					<!--<div v-else>-->
						<!--<div v-if="index == 0 && item.img != null && item.img != ''">-->
							<!--<div @click="lookNotice(item)" class="wrap-content"-->
								<!--v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击进入${item.titile}的消息`, actionType:'home-tab-detail-click'}">-->
								<!--<div class="img-flex">-->
									<!--<p class="abstract desc">{{item.title}}</p>-->
									<!--<img :src="item.img" height="21" width="39" />-->
								<!--</div>-->
							<!--</div>-->
						<!--</div>-->
						<!--<div v-else>-->
							<!--<div @click="lookNotice(item)" class="wrap-content"-->
								<!--v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击进入${item.titile}的消息`, actionType:'home-tab-detail-click'}">-->
								<!--<div class="flex">-->
									<!--<div class="flex1">-->
										<!--<p class="abstract desc">{{item.title}}</p>-->
										<!--<div>-->
											<!--<div v-if="tabdex == 3" class="zx-from-nav">{{getNoticeType(item.type)}}</div>-->
											<!--<p class="date">{{item.date}}</p>-->
										<!--</div>-->
									<!--</div>-->
								<!--</div>-->
							<!--</div>-->
						<!--</div>-->
					<!--</div>-->
				<!--</div>-->
			<!--</van-tab>-->
		<!--</van-tabs>-->

		<van-tabs sticky offset-top="45px" v-model="selected" title-active-color="#000" color="#206EEA">
      <div v-if="showCustomLoading" class="custom-loading">正在刷新，请稍候...</div>
			<van-tab v-for="(item,tabdex) in tabsList" :key="tabdex" :id="tabdex" :title="item.propName">
				<div v-for="(item,index) in NoticeList" :key="index" style="margin-top: 15px">
					<div v-if="tabdex == 2">
						<div class="list" @click="lookNotice(item)" v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击进入${item.titile}的消息`, actionType:'home-tab-detail-click'}">
							<div class="list-title">{{item.titile}}</div>
							<div class="list-date">{{item.createTime}}</div>
						</div>
					</div>
					<div v-else>
						<div v-if="index == 0 && item.img != null && item.img != ''">
                            <div class="list" @click="lookNotice(item)" v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击进入${item.titile}的消息`, actionType:'home-tab-detail-click'}">
                                <div class="list-title">{{item.title}}</div>
                                <img :src="item.img" height="21" width="39" />
                            </div>
						</div>
						<div v-else>
                            <div class="list" @click="lookNotice(item)" v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击进入${item.titile}的消息`, actionType:'home-tab-detail-click'}">
                                <div class="list-title">{{item.title}}</div>
                                <div>
                                    <div v-if="tabdex == 3" class="zx-from-nav">{{getNoticeType(item.type)}}</div>
                                    <div class="list-date">{{item.date}}</div>
                                </div>
                            </div>

							<!--<div @click="lookNotice(item)" class="wrap-content" v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击进入${item.titile}的消息`, actionType:'home-tab-detail-click'}">-->
								<!--<div class="flex">-->
									<!--<div class="flex1">-->
										<!--<p class="abstract desc">{{item.title}}</p>-->
										<!--<div>-->
											<!--<div v-if="tabdex == 3" class="zx-from-nav">{{getNoticeType(item.type)}}</div>-->
											<!--<p class="date">{{item.date}}</p>-->
										<!--</div>-->
									<!--</div>-->
								<!--</div>-->
							<!--</div>-->
						</div>
					</div>
				</div>
			</van-tab>
		</van-tabs>

		<div class="tab-content">
			<!--<p v-if="NoticeList.length == 0"-->
			<!--class="text-align-center mt1rem nodata">-->
			<!--暂无数据-->
			<!--</p>-->

		</div>
	</div>
</template>

<script>
	export default {
		name: "NavBar",
		props: {
			// selected:Number,
			tabsList: Array,
			NoticeList: Array,
      showCustomLoading: Boolean,
		},
		data() {
			return {
				selected: 0,
			}
		},
		methods: {
			getNoticeType(type) {
				if (type == 'gs') {
					return '国神公告';
				} else if (type == 'bb') {
					return '本部公告';
				} else if (type == 'jt') {
					return '集团公告';
				} else {
					return '';
				}
			},
			lookNotice(item) {
				if (this.tabsList[this.selected].selectProp == 5) {
					this.$router.push({
						path: '/infomationDetail',
						query: {
							url: item.id,
							type: this.tabsList[this.selected].selectProp,
							file: item.fileList
						}
					});
				} else if (this.tabsList[this.selected].selectProp == 6) {
					if (item.type == 'bb') {
						this.$router.push({
							path: '/infomationDetail',
							query: {
								url: item.href,
								type: 5,
								file: item.fileList
							}
						});
					} else {
						this.$router.push({
							path: '/infomationDetail',
							query: {
								url: item.href,
								type: item.type == 'gs' ? 2 : 1
							}
						});
					}
				} else {
					this.$router.push({
						path: '/infomationDetail',
						query: {
							url: item.url,
							type: this.tabsList[this.selected].selectProp
						}
					});
				}
			},
		},
		watch: {
			selected() {
				this.$emit('isSelected', this.selected)
			},

		},

	}
</script>

<style lang="scss">
	.mint-navbar .mint-tab-item.is-selected {
		/*background: #02A7F0;*/
		/*color: #fff;*/
		color: black;
		font-size: 25px;
		font-weight: bold;
	}

	.mint-navbar .mint-tab-item {
		/*background: #fff;*/
		/*color: #02A7F0;*/
		/*font-size: 20px;*/
		/*border-right: 1.5px solid #02A7F0;*/
		/*padding: 9px;*/
		/* height: 30px;
        position: relative;
        transform: translateY(-50%);
        top: 50%*/
	}

	/* 设置切换前样式 */
	.mint-navbar .mint-tab-item {
		background: #fff;
		/*color: #02A7F0;*/
		color: #7E7E7E;
		font-size: 25px;
	}

	/*.van-tabs__nav--line .van-tab .van-tab__text span{*/
	/*color:#000 !important;*/
	/*}*/
.custom-loading {
  text-align: center;
  color: #cfd3d7;
  font-size: 14px;
  height: 30px;
  line-height: 30px;
}
	.mt1rem {
		margin-top: 1rem;
		margin-left: 10px;
		margin-right: 10px;
	}
    .list{
        width: 100%;
        border-bottom: 1px solid #D7D7D7;
        padding-bottom: 8px;
        float: left;
        margin-bottom: 10px;
    }
    .list-title{
        width: 82%;
        font-size: 14px;
        font-weight: bold;
        float: left;
        margin-left: 10px;
        margin-right: 10px;
        white-space:nowrap;
        text-overflow:ellipsis;
        overflow:hidden;
    }
    .list-date{
        font-size: 13px;
        color: #666;margin-top: 10px;
        float: right;
        margin-right: 10px
    }
	.flex {
		width: 90vw;
		padding: 10px;
	}

	.desc {
		color: #000;
		font-size: 0.8rem;
		font-weight: bold;
		margin-top: 5px;
	}

	.dept {
		color: #666;
		font-size: 0.4rem;
		flex: 1;
	}

	.date {
		color: #666;
		font-size: 13px;
		margin-left: 10px;
		float: right;
		margin-top: 5px;
		margin-bottom: 5px;
		flex: 1;
		text-align: right;
	}

	.zx-from-nav {
		color: #206EEA;
		font-size: 13px;
		float: left;
		margin-top: 5px;
		margin-bottom: 5px;
		flex: 1;
		text-align: right;
	}

	.notice_list {

		.wrap-content {
			overflow: hidden;
			width: 100%;
			display: block;
			box-sizing: border-box;

			.img-flex {
				width: 90vw;
				padding: 10px;
				display: flex;
				align-items: center;
			}

			.abstract {
				flex: 1;
				line-height: 1.2rem;
				font-size: 14px;
				color: #000;
				margin-bottom: 3px;
				overflow: hidden;
				text-overflow: ellipsis;
				display: -webkit-box;
				line-clamp: 2;
				-webkit-line-clamp: 2;
				-webkit-box-orient: vertical;
				// 文本强制不换行
				white-space: nowrap;
				// 溢出显示省略号
				text-overflow: ellipsis;
			}
		}

		.list_title_date p {}

	}
</style>
