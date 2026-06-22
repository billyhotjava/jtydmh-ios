<template>
  <a
      class="ly-tab-item"
      :style="$parent.value === id ? activeStyle : {}"
      @click="onItemClicked" v-track="{triggerType:'click', currentUrl: $route.path, behavior:`点击资讯中心下标为${id}的按钮`, actionType:'zx-item-click'}">
    <div class="ly-tab-item-icon" v-if="$parent.fixBottom"><slot name="icon"></slot></div>
    <div class="ly-tab-item-label"><slot></slot></div>
  </a>
</template>

<script>
export default {
  name: 'LyTabItem',
  computed: {
    activeStyle () {
      return {
        color: this.$parent.activeColor
      }
    }
  },
  props: {

  },
  data () {
    return {
      id: (this.$parent.$children.length || 1) - 1
    }
  },
  methods: {
    onItemClicked () {
      // console.log("tab-item", JSON.stringify(this.items));
      // console.log("tab-item id", this.id);
      // console.log("tab-item item", this.items[this.id].label);
      this.$parent.$emit('input', this.id)
    }
  }
}
</script>

<style>
.ly-tab-item {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-decoration: none;
  text-align: center;
}

.ly-tab-item-icon {
  margin: 0 auto 5px;
}

</style>
