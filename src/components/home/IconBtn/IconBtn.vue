<template>
	<div class="btns row bgwhite" :iconBtnList="iconBtnList" v-show="iconBtnList.length>0">
		<a href="javascript:;" class="card-btn col col-6" v-for="(item,index) in iconBtnList" :key="index"
			@click="iconBtn(item)"
			v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击常用应用的${item.name}按钮`, actionType:'application-item-click'}">

			<div>
				<img v-if="item.url != undefined && item.url.length != 0" style="width: 45px; height: 45px"
					:src="getImgUrl(item)" alt="图标">
				<img v-else :src='application_placeholder_image' alt="图标" style="width: 45px; height: 45px">
			</div>
			<h3 style="font-weight: bold">{{item.name}}</h3>
		</a>
	</div>
</template>

<script>
	import application_placeholder_image from '@/assets/images/application/placeholder_image.png'

	export default {
		name: "IconBtn",
		props: {
			iconBtnList: Array,
		},
		data() {
			return {
				application_placeholder_image: application_placeholder_image
			}
		},
		methods: {
			iconBtn(item) {
				this.$router.push(item.path);
			},
			getImgUrl(item) {
				let img = this.$check.check(item.name);
				if (img != null) {
					console.log();
					return img;
				}else{
					return item.url;
				}
			}
		}
	}
</script>

<style scoped>
	.card-btn {
		text-align: center;
		margin-top: 10px;
		margin-bottom: 10px;
		/* margin-bottom: 0.5rem; */
	}
</style>
