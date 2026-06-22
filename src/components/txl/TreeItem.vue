<template>
	<div>
		<div>
			<div @click="toggleClick(data)" class="line"
				:style="[{'paddingLeft':`${data[treeProps.level] * 10}px`},{'font-size': data[treeProps.level] == rootLevel ? '18px' : '14px'}, {'font-weight': data[treeProps.level] == rootLevel ? 'bold' : 'lighter'}]">
				<div v-if="hasChild || (data.orgName && data.orgName.length)">
					<div v-if="isOpen" class="org">
						<p style="color: #216DEA;">{{ data[treeProps.label] }}</p>
						<img src="../../assets/images/txl/jiantou_kai.png" />
					</div>

					<div v-else class="org">
						<p style="color: #000000;">{{ data[treeProps.label] }}</p>
						<img src="../../assets/images/txl/jiantou_he.png" />
					</div>

					<!--<img v-if="isOpen" src="../../assets/images/txl/jiantou_kai.png" class="img-dept"/>-->
					<!--<img v-else src="../../assets/images/txl/jiantou_he.png" class="img-dept"/>-->
					<!--<div>{{ data[treeProps.label] }}</div>-->
				</div>
				<div v-else="!hasChild" style="paddingLeft:70px; display: flex; align-items: center">
					<img src="../../assets/images/txl/user.png" style="width: 24px; height: 24px" />
					<span
						style="flex-grow: 1; margin-left: 10px; font-size: 14px; font-weight: lighter;">{{ data[treeProps.personName] }}</span>
					<div style="margin-right: 40px" @click="callPhone(data[treeProps.mobile])"
						v-if="data[treeProps.mobile] != null && data[treeProps.mobile] != '' && data.orgCode != 'CEGSA001D01'">
						<span style="font-size: 13px; font-weight: lighter;">{{ data[treeProps.mobile] }}</span>
						<img src="../../assets/images/txl/phone.png"
							style="width: 14px; height: 14px; margin-left: 10px" />
					</div>

					<!--<img src="../../assets/images/set/user.png" class="img-user"/>-->
					<!--<div>-->
					<!--<span>{{ data[treeProps.personName] }}</span>-->
					<!--<span style="margin-left: 10px">{{ data[treeProps.mobile] }}</span>-->
					<!--</div>-->
					<!--<img src="../../assets/images/txl/phone.png" class="img-phone" @click="callPhone(data[treeProps.mobile] )"/>-->
				</div>
			</div>
			<div v-show="isOpen" v-if="hasChild">
				<tree-item v-for="(item, index) in data[treeProps.children]" :data="item" :key="index"
					:treeProps="treeProps"></tree-item>
			</div>
		</div>
	</div>
</template>

<script>
	import pinyin from 'js-pinyin'
	// var pinyin = require("pinyin");
	export default {
		name: 'TreeItem', //递归组件必须有name
		props: {
			data: {
				type: [Object, Array], //多个可能的类型
				required: true
			},
			// label、children 默认值
			treeProps: {
				type: Object,
				default: () => ({
					children: 'children',
					label: 'orgName',
					level: 'orgLevel',
					personName: 'fullName',
					mobile: 'telephoneNumber'
				})
			},
			rootLevel: {
				type: Number,
			},
		},
		data() {
			return {
				isOpen: false,
				user: {},
				childList: [],
				lettersArr: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
					'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'NO'
				],
				// lettersArr:['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','#'],
			}
		},
		computed: {
			// 判断当前级别是否还有children
			hasChild() {
				return this.data[this.treeProps.children] && this.data[this.treeProps.children].length;
			}

		},
		methods: {
			// 点击子菜单也要判断是否有children，有就展开
			toggleClick(data) {
				console.log('！！！！！！！！！！！', data);
				var that = this;
				if (this.hasChild) {
					this.isOpen = !this.isOpen; //判断age是否存在于obj里面
				} else {
					// 最后一层
					let orgName = data.hasOwnProperty('orgName');
					let orgType = data.hasOwnProperty('orgType');
					if (orgName && orgType) {
						// console.log('部门最后一层');
						this.user.orgCode = data.orgCode;
						this.user.pageNo = '1';
						this.user.pageSize = '100000';
						this.user.userCode = '';
						this.$postRequest(`${this.$config.YDMH}external/findUser`, {
							...this.user
						}).then(res => {
							// data.children = res.list;
							this.isOpen = !this.isOpen;
							let wordArrs = res.list;
							let sort = wordArrs.sort(function(str1, str2) {
								// let fstr1 = pinyin.getCamelChars(str1.fullName).substring(0, 1)
								// 	.toUpperCase();
								// let fstr2 = pinyin.getCamelChars(str2.fullName).substring(0, 1)
								// 	.toUpperCase();
								let x = str1.sortNo;
								let y = str2.sortNo;
								return ((x < y) ? -1 : (x > y) ? 1 : 0);
							});
							data.children = sort;
							// data.children = res.list;
							// let newArrs = [];
							// let _this = this;
							// for(let i = 0;i<wordArrs.length;i++){
							//     //获取每条数据里的名称
							//     let wordName = wordArrs[i].fullName;
							//     //获取所有名称的首字母，并且大写
							//     let fristName = pinyin.getCamelChars(wordName).substring(0, 1).toUpperCase();
							//     //进行判断，给原始json数据添加新的键值对
							//     if(this.lettersArr.includes(fristName)==true){
							//         wordArrs[i].first = fristName;
							//     }else{
							//         // wordArrs[i].first = "#";
							//         wordArrs[i].first = "NO"
							//     }
							//     //放入新的数组中
							//     newArrs.push(wordArrs[i])
							// }
							// let wordJson = {};
							// for(let i = 0;i < _this.lettersArr.length;i++){
							//     wordJson[_this.lettersArr[i]] = newArrs.filter(function(value){
							//         return value.first === _this.lettersArr[i]
							//     })
							// }
							// var arrlist = [];
							// arrlist = arrlist.concat(wordJson.A).concat(wordJson.B).concat(wordJson.C) .concat(wordJson.D).concat(wordJson.E).concat(wordJson.F).concat(wordJson.G)
							//     .concat(wordJson.H).concat(wordJson.I).concat(wordJson.J).concat(wordJson.K).concat(wordJson.L).concat(wordJson.M).concat(wordJson.N).concat(wordJson.O)
							//     .concat(wordJson.P).concat(wordJson.Q).concat(wordJson.R).concat(wordJson.S).concat(wordJson.T).concat(wordJson.U).concat(wordJson.V).concat(wordJson.W)
							//     .concat(wordJson.X).concat(wordJson.Y).concat(wordJson.Z).concat(wordJson.NO);
							// data.children = arrlist;
						}).catch(err => {
							console.log(err);
						});
					} else {
						// console.log('人');
					}
				}
			},
			callPhone(telephoneNumber) {
				console.log('telephoneNumber============', telephoneNumber);
				window.plugins.CallNumber.callNumber(() => {
					console.log('成功拨打电话');
				}, () => {
					console.log('拨打电话失败');
				}, telephoneNumber, true);
			},

			sortChinese(arr) {
				arr.sort(function(item1, item2) {
					return item1.localeCompare(item2, 'zh-CN'); // localeCompare为string内置函数
				})
			},
		}
	}
</script>

<style lang="scss">
	* {
		margin: 0;
		padding: 0;
		border: 0;
		list-style: none;
		text-decoration: none;
		color: inherit;
		font-weight: normal;
		font-family: "微软雅黑";
		box-sizing: border-box;
		font-style: normal;
	}

	.line {
		padding: 10px 0px;
		//margin-top: 10px;
		margin-left: 20px;
		margin-right: 20px;
		border-bottom: 1px solid #f3f1f1;
	}

	.org {
		display: flex;
		align-items: center;
	}

	.org img {
		width: 14px;
		height: 14px;
		margin-left: 10px;
	}
</style>
