<template>
	<div class="tab-page has-header background-white">
		<div class="tab-header">
			<mt-header :title="title">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>

			<div class="search_bar">
				<!-- <div class="search-div"> -->
					<form action="/" @submit.prevent class="search-div">
						<input placeholder="搜索内容" v-model="inputValue" class="search-ipnut" id="search"
							@input="getTitle()" @keyup.13="enterPress" ref="searchInput" type="search" />
						<img src="../../assets/images/globle/search.png" class="search-img" @click="personSearch()" />
					</form>
				<!-- </div> -->
			</div>

			<!--<div class="search_bar">-->
			<!--<div class="search-div background-white">-->
			<!--<img src="../../assets/images/globle/search.png" width="15" height="15" class="search-img" />-->
			<!--<input placeholder="搜索内容" class="search-ipnut" @input="personSearch($event)" />-->
			<!--</div>-->
			<!--</div>-->
		</div>

		<div class="tab-content background-white" style="margin-top: 60px;" id="phonetree" v-if="isSearch == false">
			<trees :data="treeList" :treeProps="treeProps"></trees>
		</div>

		<div class="tab-content background-white" style="margin-top: 50px;" v-else-if="isSearch == true">
			<div class="cell-div" v-for="user in userList" @click="callPhone(user)">
				<div class="cell-child-div">
					<img src="../../assets/images/txl/user.png" style="width: 24px; height: 24px" />
					<span style="flex-grow: 1; margin-left: 10px; font-size: 14px;font-weight: lighter;">{{user.fullName}}
						（{{user.orgName}}）</span>
				</div>
				
				<div style="margin-left: auto;margin-right: 25px;text-align: right;margin-top: 5px;"
					v-if="user[treeProps.mobile] != null && user[treeProps.mobile] != '' && user.orgCode != 'CEGSA001D01'">
					<span
						style="font-size: 15px;font-weight: 400; margin-right: 6px;">{{ user.telephoneNumber}}</span>
					<img src="../../assets/images/txl/phone.png"
						style="width: 14px; height: 14px; margin-left: 5px;" />
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import trees from "../../components/txl/index";
	export default {
		name: 'PersonAddress',
		components: {
			trees,
		},
		data() {
			return {
				treeList: [],
				treeProps: {
					children: 'children',
					label: 'orgName',
					level: 'orgLevel',
					personName: 'fullName',
					mobile: 'telephoneNumber'
				},
				userList: [],
				isSearch: false,
				inputValue: '',
				title: '通讯录',
			}
		},
		mounted() {

		},
		created() {
			setTimeout(() => {
				this.searchData();
			}, 200);
		},
		methods: {
			enterPress(categoryId) {
				this.$refs.searchInput.blur();
				this.personSearch();
			},
			searchData() {
				this.$getRequest(`${this.$config.YDMH}addressBook/obtainAddressBookOrgTree`, {
					orgCode: JSON.parse(localStorage.getItem('user')).orgCode.substring(0, 8),
				}).then(res => {
					this.treeList = res.list;
				}).catch(() => {

				});
			},
			getTitle() {
				if (this.inputValue == '' || 
				this.inputValue == null || 
				this.isChinese(this.inputValue) == false || 
				(this.isChinese(this.inputValue) == true 
				&& this.inputValue.length < 2)) {
					this.isSearch = false;
					this.title = '通讯录';
					this.userList = [];
				} else {
					this.isSearch = true;
					this.title = '通讯录搜索';
				}
			},
			isChinese(str) {
				console.log('isChinese');
				var reg = /^[\u4E00-\u9FA5]+$/;
				if (!reg.test(str)) {
					return false;
				} else {
					return true;
				}
			},
			personSearch() {
				console.log('personSearch');
				this.userList = [];
				var search = this.inputValue;
				if (this.isChinese(search) == false) {
					this.$toast({
						message: '只能输入汉字',
						className: 'inexa'
					});
				} else if (this.isChinese(search) == true && search.length < 2) {
					this.$toast({
						message: '最少输入两个文字',
						className: 'inexa'
					});
				} else {
					this.$getRequest(`${this.$config.YDMH}addressBook/findUser`, {
						orgCode: JSON.parse(localStorage.getItem('user')).orgCode.substring(0, 8),
						userName: search,
					}).then(res => {
						this.getOrgCode(res.list);
					}).catch(err => {

					});
				}
			},
			async getOrgCode(list) {
				for (var i = 0; i < list.length; i++) {
					var user = list[i];
					await this.$getRequest(`${this.$config.YDMH}external/getAllOrgListByEmployeeCode`, {
						userCode: user.employeeCode
					}).then(res => {
						console.log(res.list.length ==2);
						if (res.list.length ==1) {
							user.orgName = res.list[0].orgName;
						}else if (res.list.length ==2) {
							user.orgName = res.list[1].orgName + '/' + res.list[0].orgName;
						}
						console.log(user);
						this.userList.push(user);
					}).catch(err => {

					});
				}
			},
			callPhone(user) {
				if (user.telephoneNumber != null && user.telephoneNumber != '' && user.orgCode != 'CEGSA001D01') {
					console.log('telephoneNumber============', user.telephoneNumber);
					window.plugins.CallNumber.callNumber(() => {
						console.log('成功拨打电话');
					}, () => {
						console.log('拨打电话失败');
					}, user.telephoneNumber, true);
				} else {
					console.log("无手机号码");
				}
			},
		},
	}
</script>

<style lang="scss">
	.search_page {

		.search_bar {
			padding: 8px 10px;
			background-color: #f5f5f5;
			position: relative;

			.mintui-search {
				position: absolute;
				left: 18px;
				top: 1rem;
				color: #333;
				z-index: 999;
			}

			.searchbar-inner {
				background-color: #f3f1f1;

				.mint-cell {
					min-height: 1.8rem;
					height: 1.8rem;
					background-color: #f3f1f1;
					border-radius: 3px;
				}

				.mint-cell-wrapper,
				.mint-cell-value {
					height: 1.8rem;
					line-height: 1.8rem;
				}

				input {
					background-color: #f3f1f1;
					color: #666;
					height: 1.8rem;
					/*line-height: 1.8rem;*/
					line-height: 1rem;
					font-size: 0.85rem;
					padding-left: 20px;
				}

				::-webkit-input-placeholder {
					/* Chrome/Opera/Safari */
					font-size: 0.85rem;
				}

				:-ms-input-placeholder {
					/* IE 10+ */
					font-size: 0.85rem;
				}
			}

			.mint-button {
				height: 1.8rem;
				line-height: 1.8rem;
				font-size: 1rem;
				background-color: #f5f5f5;
				border: none;
				box-shadow: none;
				color: #3b87f6;
			}

			.mint-button:active,
			.mint-button::after {
				background-color: #f5f5f5;
				box-shadow: none;
			}
		}
	}

	.collapse-item {
		.collapse-item_header {
			display: block;
			padding-right: 1rem;
			height: 2.8rem;
			line-height: 2.8rem;
			color: #333;
			font-size: 1rem;

			i {
				display: inline-block;
				color: #9c9c9c;
			}

			span {
				margin-left: 6px;
			}
		}

		.collapse-item_header.current {
			background-color: #ecf8ff;
		}

		.collapse-item_header:active {
			background-color: #afe3f5;
		}

		.collapse-item_content {}
	}

	.member {
		padding: 0 0.8rem;
		display: block;

		.member_inner {
			padding: 0.8rem 0 0.6rem 0;
		}

		.head {
			width: 2.6rem;
			height: 2.6rem;
		}

		img {
			width: 2.6rem;
			height: 2.6rem;
			border-radius: 50%;
		}

		h3 {
			font-size: 1rem;
			line-height: 1.6rem;
			height: 1.6rem;
			color: #222;
			font-weight: normal;
		}

		p {
			font-size: 0.8rem;
			line-height: 1rem;
			height: 1rem;
		}
	}

	.search-div {
		width: 90%;
		background: #EEEEEE;
		border-radius: 30px;
		display: flex;
		align-items: center;
		padding: 10px;
		margin-top: 8px;
		position: absolute;
		left: 50%;
		transform: translateX(-50%);
	}

	.search-ipnut {
		flex-grow: 1;
		font-size: 13px;
		margin-left: 10px;
		background: #EEEEEE;
	}

	.search-img {
		width: 17px;
		height: 17px;
		margin-right: 12px;
		margin-left: 10px
	}

	.img-user {
		width: 40px;
		height: 40px;
		float: left;
		margin-right: 10px;
		position: relative;
		top: 50%;
		transform: translateY(-25%);
	}

	.cell-div {
		margin: 0px 0px;
		padding: 10px 0px 10px 20px;
		border-bottom: 1px solid #cccccc;
	}
	.cell-child-div{
		align-items: center;
		display: flex;
	}
</style>
