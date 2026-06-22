<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header title="天气预报" class="nav-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
			<div>
				<van-dropdown-menu active-color="#206EEA" class="dropdown-item">
					<van-dropdown-item v-model="leftValue" :options="leftDropDownList" @change="selectLeftChange()"
						v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击筛选天气预报区域的按钮', actionType:'weather-forecast-tab1-click'}" />
					<van-dropdown-item v-model="rightValue" :options="rightDropDownList" @change="selectRightChange()"
						v-track="{triggerType:'click', currentUrl: $route.path, behavior:'点击筛选天气情况的按钮', actionType:'weather-forecast-tab2-click'}" />
				</van-dropdown-menu>
			</div>
		</div>
		<div class="content-container tab-content" v-if="weatherList != undefined && weatherList.length != 0"
			style="background: #F1F7FE">
			<div :class='["content-bg", item.type == 1 ? "content-bg-active" : ""]' v-for="(item, index) in weatherList"
				:key="index" @click="gotoWeatherDetail(item)"
				v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击查看${item.location.name}的具体天气情况的按钮`, actionType:'weather-forecast-info-click'}">
				<div class="content-title-container">
					<div :class='["title-div", item.type == 1 ? "title-active" : ""]'>
						{{item.location.name}}
					</div>
					<div :class='["subtitle-des-div", item.type == 1 ? "title-active" : ""]'>
						({{item.factoryMineName}})
					</div>
					<img src="../../assets/images/arrow-white.png" class="right-img-active" v-if="item.type == 1" />
					<img src="../../assets/images/arrow.png" class="right-img" v-else />
				</div>
				<div class="content-line"></div>
				<div class="bottom-info-container">
					<weathericon :weatherCode="item.now.code" class="weather-img"></weathericon>
					<div :class='["weather-text-div", item.type == 1 ? "title-active" : ""]'>
						{{item.now.text}}
					</div>
					<div class="right-container">
						<div class="right-line-container">
							<div :class='["left-title-div", item.type == 1 ? "title-active" : ""]'>
								实时温度
							</div>
							<div :class='["right-value-div", item.now.temperature >= 38 ? "right-value-active" : "title-active"]'
								v-if="item.type == 1">
								{{item.now.temperature}}
							</div>
							<div :class='["right-value-div", item.now.temperature >= 38 ? "right-value-active" : ""]'
								v-else>
								{{item.now.temperature}}
							</div>
							<div :class='["right-value-unit-div", item.type == 1 ? "title-active" : ""]'>
								℃
							</div>
						</div>
						<div class="right-line-container">
							<div :class='["left-title-div", item.type == 1 ? "title-active" : ""]'>
								风力
							</div>
							<div :class='["right-value-div", item.now.wind_scale >= 5 ? "right-value-active" : "title-active"]'
								v-if="item.type == 1">
								{{item.now.wind_scale}}
							</div>
							<div :class='["right-value-div", item.now.wind_scale >= 5 ? "right-value-active" : ""]'
								v-else>
								{{item.now.wind_scale}}
							</div>
							<div :class='["right-value-unit-div", item.type == 1 ? "title-active" : ""]'>
								级
							</div>
						</div>
						<div class="right-line-container">
							<div :class='["left-title-div", item.type == 1 ? "title-active" : ""]'>
								能见度
							</div>
							<div :class='["right-value-div", item.type == 1 ? "title-active" : ""]'>
								{{item.now.visibility}}
							</div>
							<div :class='["right-value-unit-div", item.type == 1 ? "title-active" : ""]'>
								km
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="no_data_container" v-else>
			<p style="text-align: center"> <img src="../../assets/images/weather/noweatherdata.png" align="middle" />
			</p>
			<div class="no_data_text">
				暂无内容
			</div>
		</div>
	</div>
</template>

<script>
	import weathericon from '@/components/tqyb/WeatherIcon';

	export default {
		name: "WeatherForecast",
		components: {
			weathericon
		},
		data() {
			return {
				allCityList: [],
				leftValue: 0,
				leftDropDownList: [],
				rightValue: 0,
				rightDropDownList: [{
						text: '全部类型',
						value: 0
					},
					{
						text: '普通天气',
						value: 1
					},
					{
						text: '灾害性天气',
						value: 2
					},
				],
				weatherList: [],
				selectedCityCode: '',
				selectedWeatherCondition: '',
			}
		},
		created() {

		},
		mounted() {
			this.getCityList();
			this.getWeatherInfo();
		},
		methods: {
			selectLeftChange() {
				if (this.leftValue == 0) {
					this.selectedCityCode = '';
				} else {
					this.selectedCityCode = String(this.allCityList[this.leftValue - 1].cityCode);
				}
				this.getWeatherInfo();
			},
			selectRightChange() {
				if (this.rightValue == 0) {
					this.selectedWeatherCondition = '';
				} else {
					this.selectedWeatherCondition = String(this.rightValue - 1);
				}
				this.getWeatherInfo();
			},
			getCityList() {
				this.leftDropDownList = [{
					text: '全部区域',
					value: 0
				}];
				this.$getRequest(`${this.$config.YDMH}weather/obtainCityList`)
					.then(res => {
						this.allCityList = res.list;
						res.list.forEach((item, index) => {
							var cityItem = {
								text: item.cityName,
								value: index + 1
							}
							this.leftDropDownList.push(cityItem);
						});
					}).catch(err => {
						console.log('获取城市列表失败 ', err);
						this.$toast({
							message: err,
							className: 'inexa'
						});
					});
			},
			getWeatherInfo() {
				this.$getRequest(`${this.$config.YDMH}weather/find`, {
					cityCode: this.selectedCityCode,
					type: this.selectedWeatherCondition
				}).then(res => {
					// res.list.forEach((item, index) => {
					//   item.now.code = '../../assets/images/weather/' + item.now.code + '@2x.png';
					// });
					this.weatherList = res.list;
				}).catch(err => {
					console.log('获取天气列表失败 ', err);
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			gotoWeatherDetail(item) {
				this.$router.push({
					name: 'weatherdetail',
					params: {
						item: item
					}
				});
			}
		},
	}
</script>

<style scoped>
	.nav-header {}

	.dropdown-item {
		height: 43.0px;
	}

	>>>.van-dropdown-menu__bar {
		height: 43.0px;
	}

	>>>.van-dropdown-menu__title {
		color: #333333;
		font-weight: bold;
	}

	.content-bg {
		background: white;
		margin: 17px 14px;
		border-radius: 8px;
	}

	.content-bg-active {
		background: #277AF5;
	}

	.title-div {
		color: #5D5D5D;
		padding: 10px 8px 10px 14px;
		font-size: 15px;
	}

	.content-line {
		border-bottom: 1px solid #E0E3E7;
		margin: 0px 14px;
	}

	.bottom-info-container {
		display: flex;
		flex-direction: row;
		padding: 16px 10px 18px 14px;
	}

	.weather-img {
		width: 16%;
		object-fit: contain;
	}

	.weather-text-div {
		margin: 0px 4px;
		color: #333333;
		font-size: 16px;
		font-weight: bold;
		text-align: center;
		margin: auto;
		margin-left: 20px;
	}

	.right-container {
		display: flex;
		flex-direction: column;
		margin-left: auto;
		margin-right: 15px;
		width: 32%;
	}

	.right-line-container {
		display: flex;
		flex-direction: row;
		margin: 4px 0px;
	}

	.left-title-div {
		color: #717171;
		font-weight: bold;
		font-size: 13px;
		width: 52px;
		text-align: right;
	}

	.right-value-div {
		margin-left: auto;
		font-size: 13px;
		color: black;
	}

	.right-value-active {
		color: red;
	}

	.right-value-unit-div {
		font-size: xx-small;
		color: #7D7D7D;
		margin-top: 2px;
		margin-left: 2px;
	}

	.content-title-container {
		display: flex;
		flex-direction: row;
	}

	.subtitle-des-div {
		color: #216DEA;
		font-size: 12px;
		text-align: center;
		line-height: 38px;
	}

	.right-img {
		width: 8px;
		height: 14px;
		margin-left: auto;
		margin-right: 12px;
		margin-top: 13px;
	}

	.right-img-active {
		width: 14px;
		height: 14px;
		margin-left: auto;
		margin-right: 12px;
		margin-top: 13px;
	}

	.no_data_container {
		height: 100%;
		display: -webkit-flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	.title-active {
		color: white;
	}
</style>
