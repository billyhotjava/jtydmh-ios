<!--左右菜单联动-->
<template>
	<div class="cascad-menu" ref="cascadMenu">
		<scroll class="left-menu" :data="menus" ref="leftMenu">
			<div class="left-menu-container">
				<div>
					<div class="left-item" ref="leftItem" :class="{'current': currentIndex == index}"
						@click="selectLeft(index, $event)" v-for="(menu, index) in menus" :key="index"
						v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击应用分类${menu.classifyName}的按钮`, actionType:'application-category-tabbar-click'}">
						<p class="text">{{menu.classifyName}}</p>
					</div>
				</div>
			</div>
		</scroll>
		<scroll class="right-menu" :data="menus" ref="rightMenu" @scroll="scrollHeight" :listenScroll="true"
			:probeType="3">
			<div class="right-menu-container">
				<div>
					<div class="right-item" ref="rightItem" v-for="(menu, index) in menus" :key="index">
						<div class="title">
							<div class="title-left">{{menu.classifyName}}</div>
							<div v-if="menu.classifyName == '常用'" class="title-right" @click="editApp()"
								v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击常用应用编辑的按钮', actionType:'application-edit-click'}">
								编辑</div>
						</div>

						<div style="display: flex; flex-wrap: wrap; margin-top: 12px;">
							<div v-for="(item, j) in menu.applicationList" :key="j" style="width: 33.33%"
								@click="appClick(item)"
								v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击${item.name}的按钮`, actionType:'application-item-click'}">
								<div class="data-wrapper">
									<img :src="getImgUrl(item)" alt="图标">
									<div class="data">{{item.name}}</div>
								</div>
							</div>
						</div>
						<div style="background: white;height: 50vh" v-if="index == menus.length - 1" />
					</div>
				</div>
			</div>
		</scroll>
	</div>
</template>

<script>
	import Scroll from './scroll'
	import application_placeholder_image from '@/assets/images/application/placeholder_image.png'
	export default {
		components: {
			Scroll
		},
		props: {
			menus: {
				required: true,
				type: Array,
				default: () => []
			}
		},
		created() {
			// this.menuData = this.menus;
		},
		data() {
			return {
				// menuData:[],
				rightTops: [],
				scrollY: 0,
				leftScrollY: 0,
			}
		},
		computed: {
			currentIndex() {
				// 当用户在滚动时，需要计算当前滚动距离在哪个(右边li块)区间内，并拿到它的 `index`
				const {
					scrollY,
					rightTops
				} = this;
				let index = rightTops.findIndex((height, index) => {
					return scrollY >= rightTops[index] && scrollY < rightTops[index + 1]
				});
				if (scrollY > rightTops[index] + 50) {
					index++;
				}
				return index;

			},
		},
		mounted() {
			// this.$nextTick(() => {
			// 	this._calculateHeight()
			// });
		},
		methods: {
			selectLeft(index, event) {
				// 添加`$event`是为了区分原生点击事件还是 better-scroll派发的事件
				if (!event._constructed) {
					return
				}
				let rightItem = this.$refs.rightItem;
				let el = rightItem[index];
				this.$refs.rightMenu.scrollToElement(el, 300)
			},
			scrollHeight(pos) {
				this.scrollY = Math.abs(Math.round(pos.y));
			},
			_calculateHeight() {
				// 计算右边列表每一块的高度
				this.rightTops = [];
				let lis = this.$refs.rightItem;
				let height = 0;
				this.rightTops.push(height);
				Array.from(lis).forEach((li, index) => {
					height += li.clientHeight;
					this.rightTops.push(height);
				});
			},
			editApp() {
				this.$router.push({
					name: 'appedit'
				});
			},
			getImgUrl(item) {
				let img = this.$check.check(item.name);
				if (img != null) {
					console.log();
					return img;
				}else{
					return item.imageUrl;
				}
			},
			appClick(item) {
				if (item.category == 1) {
					if (item.appPath != null && item.appPath != '') {
						this.$router.push(item.appPath);
					}
				} else if (item.category == 2) {
					if (item.authType == 1) {
						let user = JSON.parse(localStorage.getItem('user'));
						let url = item.appUrl + '?token=' + user.token;
						//todo 跳转应用页面
					} else if (item.authType == 2) {

					} else {
						//todo 跳转应用页面

					}
				} else {
					//todo 跳转app应用页面
					if (item.isUnifiedAuthentication == 1) {
						//带token跳转
					} else {

					}
				}
			}
		}
	}
</script>

<style lang="stylus" scoped>
	.cascad-menu {
		width 100%;
		height 100%;
		display: flex;
		position: absolute;
		/*top: 100px;
  bottom: 100px;*/
		/*border: 1px solid red;*/
		overflow: hidden;

		.left-menu {
			flex: 0 0 80px;
			width: 80px;
			height 100%;
			background: #f3f5f7;

			.left-item {
				height: 54px;
				width: 100%;

				&.current {
					width: 200%;
					background: #fff;
					border-left 2px solid #206EEA
				}

				.text {
					width: 100%;
					line-height: 54px;
					padding-left: 15px;
				}
			}
		}

		.right-menu {
			flex: 1;
			height: 100%;

			.right-item {
				height: 100%;
				/*border: 1px solid #ccc;*/
				display: flex;
				flex-direction: column;

				.title {
					/*border-bottom: 1px solid #ccc;*/
					height: 20px;
					padding: 10px;

					.title-left {
						display: inline;
						font-size: 16px;
						font-weight: bold
					}

					.title-right {
						float: right;
						margin-right: 15px;
						color: #6B6B6B;
						font-size: 12px
					}
				}

				.data-wrapper {
					margin: 10px 10px 2px 10px;

					img {
						width: 45px;
						height: 45px;
						position: relative;
						left: 50%;
						transform: translateX(-50%);
					}

					.data {
						margin-top: 8px;
						line-height: 20px;
						height: 40px;
						text-align center;
					}
				}
			}
		}
	}
</style>
