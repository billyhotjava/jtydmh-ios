<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header :title="title" class="bb">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
		</div>
		<div class="tab-content container">
			<iframe class="zx-iframe" name="zx-iframe" id="zx-iframe" :src="zxUrl"></iframe>
		</div>
	</div>
</template>

<script>
	export default {
		name: 'html',
		data() {
			return {
				zxUrl:''
			}
		},
		mounted() {
			this.zxUrl = this.$route.query.url;
			this.pageType = this.$route.query.type;
			if (this.pageType == 1) {
				this.title = '集团公告';
			}else if (this.pageType == 2) {
				this.title = '公司公告';
			}else if (this.pageType == 3) {
				this.title = '早会纪要';
			}else if (this.pageType == 3) {
				this.title = '例会纪要';
			}else{
				this.title = '本部公告';
			};
		},
		methods: {

		},
	}
</script>

<style>
	.zx-iframe {
	  width: 100%;
	  height: 100%;
	  border-width: 0.0;
	}
	.container{
	　　height:100px;
	　　overflow: auto;
	　　-webkit-overflow-scrolling: touch; 
	}
</style>
