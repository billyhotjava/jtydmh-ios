<template>
	<div :style="{height:height*lineNum + 'px'}" class="rollScreen_container" id="rollScreen_container">
		<ul class="rollScreen_list" :style={transform:transform} :class="{rollScreen_list_unanim:num===0}">
			<li class="rollScreen_once" v-for="(item,index) in swiperList" :key=index :style="{height:height+'px'}"
				@click="showDetail(item)">
				<span class="span text-size-12 home-swiper-color">{{item.title}}</span>
			</li>
			<li class="rollScreen_once" v-for="(item,index) in swiperList" :key=index+swiperList.length
				:style="{height:height+'px'}" @click="showDetail(item)">
				<span class="span text-size-12 home-swiper-color">{{item.title}}</span>
			</li>
		</ul>
	</div>
</template>

<script>
	export default {
		name: "SwiperVertical",
		props: {
			swiperList: Array,

			height: {
				// default: 20,
				type: Number
			},
			lineNum: {
				// default: 1,
				type: Number
			}
		},

		data: function() {
			return {
				num: 0,
				swiperList: []
			}
		},
		computed: {
			transform: function() {
				return 'translateY(-' + this.num * this.height + 'px)'
			}
		},
		created: function() {
			let _this = this;
			setInterval(function() {
				if (_this.num !== _this.swiperList.length) {
					_this.num++
				} else {
					_this.num = 0
				}
			}, 3000)
		},
		methods: {
			showDetail(item) {
				console.log(item);
				this.bus.$emit('triggerMessageScroll',item);
			},
		}
	}
</script>

<style scoped lang="scss">
	.rollScreen_container {
		display: inline-block;
		position: relative;
		overflow: hidden;
	}

	.rollScreen_list {
		transition: 1s linear;
	}

	.rollScreen_list_unanim {
		transition: none
	}

	.span {
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 1;
		overflow: hidden;
		position: relative;
		top: 50%;
		transform: translateY(-50%);
	}
</style>
