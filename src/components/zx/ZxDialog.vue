<template>
	<mt-popup v-model="show" class="dialog-popup" :closeOnClickModal="closeOnClickModal">
		<div class="title-flex">
      <div class="img-container">
        <img class="close-img" src="../../assets/images/zx/delete.png" @click="cancel()" />
      </div>
			<div class="middle">分类位置编辑</div>
			<div class="right"></div>
		</div>

		<div class="notice-middle">拖拽改变分类顺序</div>

		<vuedraggable v-model="zxList" class="div-wrap">
			<div v-for="(item, j) in zxList" :key="j" class="colum-item">
				<div class="name text-size-14 zx-dilaog-name">{{item.label}}</div>
			</div>
		</vuedraggable>

		<button class="bt zx-dialog-save text-color-white text-size-14" @click="save()">保存</button>


	</mt-popup>
</template>

<script>
	import vuedraggable from 'vuedraggable';
	export default {
		name: "ZxDialog",
		props: {
			show: Boolean,
			zxList: Array,
		},
		components: {
			vuedraggable
		},
		data() {
			return {
				closeOnClickModal: false,
			}
		},
		updated() {
			console.log('zxList======', JSON.stringify(this.zxList));
			localStorage.setItem('zxList', JSON.stringify(this.zxList));
		},

		methods: {
			save() {
				/*
				 * TODO 点击保存后调用资讯信息接口，保存新修改的NavrBar的数据
				 */
				this.$emit('handleCancel');
			},
			cancel() {
				this.$emit('handleCancel');
			},
		},
	}
</script>

<style scoped lang="scss">
	.title-flex {
		display: flex;
    flex-direction: column;
		text-align: center;
		height: 30px;
		align-items: center;

		.middle {
			font-size: 17px;
			flex: auto;
		}

		.right {
			height: 15px;
			width: 15px;
		}

	}
  .img-container {
    width: 100%;
    display: flex;
    justify-content: flex-end;
  }
  .close-img {
    width: 15px;
    height: 15px;
    align-items: flex-end;
  }
	.dialog-popup {
		width: 70%;
		padding: 20px;
		border-radius: 5px;
		position: fixed;
		/*当页面不滚动时添加的滚动样式设置*/
		overflow-y: scroll;
	}

	.bt {
		width: 90%;
		height: 36px;
		margin: 15px 15px 5px 15px;
		padding: 6px 10px;
		border-radius: 18px;
		border: 0;
	}

	/*设置自动换行*/
	.div-wrap {
		display: flex;
		flex-wrap: wrap;
		padding: 10px;
		margin-top: 10px
	}

	.colum-item {
		/*设置每一个小组建的宽度占比*/
		width: 50%;
	}

	.name {
		padding: 10px;
		margin: 5px;
		text-align: center;
	}

	.notice-middle {
		margin: 30px 10px 0px 15px;
		font-size: 16px;
		color: #676767;
	}
</style>
