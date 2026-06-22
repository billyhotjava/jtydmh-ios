<template>
<div class="ly-tab">
  <ly-tabbar
    v-model="selectedId"
    v-bind="options">
<!--    <ly-tab-item-->
<!--      v-for="(item, index) in items"-->
<!--      :key="index" v-bind:items="items">-->
    <ly-tab-item
        v-for="(item, index) in items"
        :key="index">
      <span
        v-if="options.fixBottom && item.icon"
        slot="icon">
        <i :class="item.icon"></i>
      </span>
      <span>{{ item[labelKey] }}</span>
    </ly-tab-item>
  </ly-tabbar>
</div>
</template>

<script>
import LyTabbar from './tabbar'
import LyTabItem from './tab-item'

export default {
  name: 'LyTab',
  components: {
    LyTabbar,
    LyTabItem
  },
  props: {
    value: {
      type: Number,
      default: 0
    },
    items: {
      type: Array,
      default () {
        return []
      }
    },
    options: {
      type: Object,
      default () {
        return {}
      }
    }
  },
  data () {
    return {
      selectedId: this.value
    }
  },
  computed: {
    labelKey () {
      return this.options.labelKey || 'label'
    }
  },
  watch: {
    value (value) {
      this.selectedId = value
    },
    selectedId (value) {
      // console.log("@@@@@@@@@@ items", JSON.stringify(this.items));
      // console.log("@@@@@@@@@@ selected", this.selectedId);
      // console.log("@@@@@@@@@@ value", this.value);
      // this.$emit('input', value);
      // this.$emit('change', this.items[value], value);
      this.$emit('input', this.selectedId);
      this.$emit('change', this.items[this.selectedId], this.selectedId);
    }
  }
}
</script>

<style>

</style>
