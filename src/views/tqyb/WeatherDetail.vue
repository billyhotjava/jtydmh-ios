<template>
	<div class="tab-page has-header">
		<div class="tab-header">
			<mt-header :title="weatherInfo.location.name + '天气预报'" class="nav-header">
				<a href="javascript:;" slot="left" @click="$router.back(-1)">
					<mt-button icon="back" />
				</a>
			</mt-header>
		</div>
		<div class="content-container tab-content" style="background: #EFF8FF">
			<div class="top-content-container">
				<div :class='[index == 0 ? "left-title1-container" : "left-title2-container"]'
					v-for="(item, index) in leftTitles" :key="index">
					<div class="vertical-line"></div>
					<div class="left-title-div">
						{{item}}
					</div>
				</div>
				<div :class='[leftTitles.length == 1 ? "weather-icon1-container" : "weather-icon2-container"]'>
					<weathericon :weatherCode="parseInt(weatherNow.code)" class="weather-img"></weathericon>
					<div class="weather-text-div">
						{{this.weatherNow.text}}
					</div>
				</div>
				<div class="weather-detail-container">
					<div class="left-weather-detail-container">
						<div class="weather-detail-line-container">
							<div class="weather-detail-title-div">
								实时温度
							</div>
							<div class="weather-detail-value-container">
								<div
									:class='["weather-detail-text-div", weatherNow.temperature >= 38 ? "weather-detail-text-active" : ""]'>
									{{this.weatherNow.temperature}}
								</div>
								<div class="right-weather-unit-div">
									℃
								</div>
							</div>
						</div>
						<div class="weather-detail-line-container weather-detail-line-margin">
							<div class="weather-detail-title-div">
								风向
							</div>
							<div class="weather-detail-value-container">
								<div class="weather-detail-text-div">
									{{this.weatherNow.wind_direction}}
								</div>
								<div class="right-weather-unit-div">
									&#32;
								</div>
							</div>
						</div>
						<div class="weather-detail-line-container">
							<div class="weather-detail-title-div">
								风速
							</div>
							<div class="weather-detail-value-container">
								<div class="weather-detail-text-div">
									{{this.weatherNow.wind_speed}}
								</div>
								<div class="right-weather-unit-div">
									km
								</div>
							</div>
						</div>
					</div>

					<div class="right-weather-detail-container">
						<div class="weather-detail-line-container">
							<div class="weather-detail-title-div">
								体感温度
							</div>
							<div class="weather-detail-value-container">
								<div class="weather-detail-text-div">
									{{this.weatherNow.feels_like}}
								</div>
								<div class="right-weather-unit-div">
									℃
								</div>
							</div>
						</div>
						<div class="weather-detail-line-container weather-detail-line-margin">
							<div class="weather-detail-title-div">
								风力
							</div>
							<div class="weather-detail-value-container">
								<div
									:class='["weather-detail-text-div", weatherNow.wind_scale >= 5 ? "weather-detail-text-active" : ""]'>
									{{this.weatherNow.wind_scale}}
								</div>
								<div class="right-weather-unit-div">
									级
								</div>
							</div>
						</div>
						<div class="weather-detail-line-container">
							<div class="weather-detail-title-div">
								气压
							</div>
							<div class="weather-detail-value-container">
								<div class="weather-detail-text-div">
									{{this.weatherNow.pressure}}
								</div>
								<div class="right-weather-unit-div">
									mbar
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--  未来4天天气  -->
			<div class="bottom-container">
				<div class="bottom-title-container">
					<div class="vertical-blue-line"></div>
					<div class="bottom-title-div">
						未来4天天气
					</div>
				</div>
				<div class="content-bg">
					<div v-for="(item, index) in weatherDaily" :key="index"
						:class='["eachday-weather-container", index != 3 ? "eachday-weather-container-vertical-line" : ""]'>
						<div class="eachday-weather-text-div">
							{{weekList[index]}}
						</div>
						<div class="eachday-weather-text-div">
							{{convertDateFormat(item.date)}}
						</div>
						<div class="eachday-weather-img-container">
							<weathericon :weatherCode="item.code_day" class="eachday-weather-img"></weathericon>
						</div>
						<div class="eachday-weather-text-div">
							{{item.low}}—{{item.high}}℃
						</div>
						<div class="eachday-weather-text-div" v-if="item.wind_direction.indexOf('风') != -1">
							{{item.wind_direction}} {{item.wind_scale}}级
						</div>
						<div class="eachday-weather-text-div" v-else>
							{{item.wind_direction}}风 {{item.wind_scale}}级
						</div>
						<div class="eachday-weather-text-div">
							湿度 {{item.humidity}}
						</div>
						<div class="eachday-weather-text-div">
							降水量 {{item.rainfall}}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	import weathericon from '@/components/tqyb/WeatherIcon';

	export default {
		name: "WeatherDetail",
		components: {
			weathericon
		},
		data() {
			return {
				weatherInfo: '',
				leftTitles: [],
				weekList: [],
        weatherLocation: {},
        weatherNow: {},
        weatherDaily: {},
			}
		},
		created() {
			this.weatherInfo = this.$route.params.item;
			this.leftTitles = this.$route.params.item.factoryMineName.split(',');
			this.getTodayWeek();
			this.getWeatherDetail();
		},
		methods: {
			getWeatherDetail() {
				this.$getRequest(`${this.$config.YDMH}weather/obtainWeatherDetail`, {
					cityCode: this.weatherInfo.cityCode
				}).then(res => {
					res.object.daily.shift();
					this.weatherLocation = res.object.location;
					this.weatherNow = res.object.now;
					this.weatherDaily = res.object.daily;
					// console.log('天气情况', JSON.stringify(res.object));
				}).catch(err => {
					console.log('获取天气详情失败 ', err);
					this.$toast({
						message: err,
						className: 'inexa'
					});
				});
			},
			getTodayWeek() {
				let tempDate = new Date();
				let weeks = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
				let week = tempDate.getDay();
				for (var i = 0; i < 4; i++) {
					week += 1;
					if (week > 6) {
						week = 0;
					}
					this.weekList.push(weeks[week]);
				}
			},
			convertDateFormat(inDate) {
				let date = inDate.replace(/\s*/g, '');
				let list = date.split('-');
				if (list.length < 3) {
					list = date.split('/');
					if (list.length == 3 && list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
						return list[1] + '月' + list[2] + '日';
					} else {
						return inDate;
					}
				} else {
					if (list.length == 3 && list[0].length > 0 && list[1].length > 0 && list[2].length > 0) {
						return list[1] + '月' + list[2] + '日';
					} else {
						return inDate;
					}
				}
			},
		}
	}
</script>

<style scoped>
	.top-content-container {
		background: #0076FF;
		width: 100%;
		display: flex;
		flex-direction: column;
	}

	.left-title1-container {
		padding: 24px 16px 5px 16px;
		display: flex;
		flex-direction: row;
	}

	.left-title2-container {
		padding: 5px 16px 5px 16px;
		display: flex;
		flex-direction: row;
	}

	.vertical-line {
		background: white;
		width: 4px;
		height: 14px;
		border-radius: 2px;
		margin-top: 1px;
	}

	.left-title-div {
		color: white;
		margin-left: 10px;
		font-weight: bold;
		font-size: 16px;
	}

	.weather-icon1-container {
		text-align: center;
		margin-top: -10px;
		margin-bottom: 20px;
	}

	.weather-icon2-container {
		text-align: center;
		margin-top: -30px;
		margin-bottom: 20px;
	}

	.weather-img {
		width: 22%;
		object-fit: contain;
	}

	.weather-text-div {
		color: white;
		margin: 14px 0px;
		font-size: 20px;
		font-weight: bold;
	}

	.weather-detail-container {
		display: flex;
		margin: 0px 28px 20px 26px;
		justify-content: space-between;
	}

	.left-weather-detail-container {
		display: flex;
		flex-direction: column;
		/*flex: 1;*/
		width: 36%;
	}

	.weather-detail-line-container {
		display: flex;
		flex-direction: row;
		justify-content: space-between;
	}

	.right-weather-detail-container {
		display: flex;
		flex-direction: column;
		/*flex: 1;*/
		width: 36%;
		margin-right: 26px;
	}

	.weather-detail-title-div {
		color: #AAD1FF;
		font-weight: bold;
		font-size: 15px;
		width: 64px;
		text-align: right;
	}

	.weather-detail-value-container {
		display: flex;
		width: 50px;
	}

	.weather-detail-line-margin {
		margin: 14px 0px;
	}

	.weather-detail-text-div {
		color: white;
		font-weight: bold;
		font-size: 14px;
		line-height: 16px;
	}

	.weather-detail-text-active {
		color: red;
	}

	.right-weather-unit-div {
		font-size: xx-small;
		color: #AAD1FF;
		line-height: 18px;
		margin-left: 4px;
	}

	.bottom-container {
		margin: 24px 14px 20px 14px;
	}

	.bottom-title-container {
		display: flex;
		margin-bottom: 11px;
	}

	.vertical-blue-line {
		background: #216DEA;
		width: 4px;
		height: 14px;
		border-radius: 2px;
		margin-top: 1px;
	}

	.bottom-title-div {
		color: #5D5D5D;
		font-size: 15px;
		font-weight: bold;
		margin-left: 8px;
	}

	.content-bg {
		background: white;
		padding: 17px 17px 8px 17px;
		border-radius: 8px;
		display: flex;
	}

	.eachday-weather-container {
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
		width: 33%;
	}

	.eachday-weather-container-vertical-line {
		border-right: 1px solid #CFD3D7;
	}

	.eachday-weather-text-div {
		text-align: center;
		width: 100%;
		font-weight: bold;
		font-size: 10px;
		color: #383838;
		margin-bottom: 10px;
	}

	.eachday-weather-img-container {
		text-align: center;
		margin: 10px 0px;
		height: 60px;
	}

	.eachday-weather-img {
		width: 55%;
		object-fit: contain;
	}
</style>
