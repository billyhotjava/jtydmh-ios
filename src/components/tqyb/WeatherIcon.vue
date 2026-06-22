<template>
  <img v-if="weatherCode == 0" src="../../assets/images/weather/0@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 1" src="../../assets/images/weather/1@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 2" src="../../assets/images/weather/2@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 3" src="../../assets/images/weather/3@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 4" src="../../assets/images/weather/4@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 5" src="../../assets/images/weather/5@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 6" src="../../assets/images/weather/6@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 7" src="../../assets/images/weather/7@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 8" src="../../assets/images/weather/8@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 9" src="../../assets/images/weather/9@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 10" src="../../assets/images/weather/10@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 11" src="../../assets/images/weather/11@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 12" src="../../assets/images/weather/12@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 13" src="../../assets/images/weather/13@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 14" src="../../assets/images/weather/14@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 15" src="../../assets/images/weather/15@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 16" src="../../assets/images/weather/16@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 17" src="../../assets/images/weather/17@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 18" src="../../assets/images/weather/18@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 19" src="../../assets/images/weather/19@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 20" src="../../assets/images/weather/20@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 21" src="../../assets/images/weather/21@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 22" src="../../assets/images/weather/22@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 23" src="../../assets/images/weather/23@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 24" src="../../assets/images/weather/24@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 25" src="../../assets/images/weather/25@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 26" src="../../assets/images/weather/26@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 27" src="../../assets/images/weather/27@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 28" src="../../assets/images/weather/28@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 29" src="../../assets/images/weather/29@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 30" src="../../assets/images/weather/30@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 31" src="../../assets/images/weather/31@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 32" src="../../assets/images/weather/32@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 33" src="../../assets/images/weather/33@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 34" src="../../assets/images/weather/34@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 35" src="../../assets/images/weather/35@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 36" src="../../assets/images/weather/36@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 37" src="../../assets/images/weather/37@2x.png" class="weather-icon-img"/>
  <img v-else-if="weatherCode == 38" src="../../assets/images/weather/38@2x.png" class="weather-icon-img"/>
  <img v-else src="../../assets/images/weather/99@2x.png" class="weather-icon-img"/>
</template>

<script>
export default {
  name: "WeatherIcon",
  props: {
    weatherCode: 0,
  }
}
</script>

<style scoped>

</style>