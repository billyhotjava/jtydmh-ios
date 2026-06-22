<template>
  <mt-popup v-model="showCheckPasswordDialog" class="dialog-popup" :closeOnClickModal="closeOnClickModal">
    <div class="page-container">
      <div class="img-container">
        <img class="close-img" src="../../assets/images/zx/delete.png" @click="closeEvent" />
      </div>
      <div class="title-container">验证密码</div>
      <div class="content-container">
        <van-field class="input-filed" label-width="3em" type="password" v-model="inputValue" label="密码" placeholder="请输入国神密码" clearable/>
        <div class="button-container">
          <button class="check-password-button zx-dialog-save" @click="checkPasswordEvent">验证</button>
        </div>
      </div>
    </div>
  </mt-popup>
</template>

<script>
export default {
  name: "checkpassword",
  props: {
    showCheckPasswordDialog: Boolean,
  },
  data() {
    return {
      inputValue: '',
      closeOnClickModal: false,
    }
  },
  methods: {
    checkPasswordEvent() {
      console.log(this.inputValue);
      let localPassword = localStorage.getItem('password');
      if (this.inputValue == '' || this.inputValue.length == 0) {
        this.$toast({
          message: '请输入国神密码',
          position: 'bottom'
        });
      } else {
        if (this.inputValue == localPassword) {
          this.$emit('checkPasswordHandler', true);
        } else {
          this.$emit('checkPasswordHandler', false);
        }
      }
    },
    closeEvent() {
      this.$emit('closeDialog');
    }
  }
}
</script>

<style scoped lang="scss">

.dialog-popup {
  width: 70%;
  padding: 20px;
  border-radius: 5px;
  position: fixed;
  /*当页面不滚动时添加的滚动样式设置*/
  overflow-y: scroll;
}
.page-container {
  display: flex;
  flex-direction: column;
}
.title-container {
  font-size: 17px;
  flex: auto;
  text-align: center;
}
.img-container {
  display: flex;
  justify-content: flex-end;
}
.close-img {
  width: 15px;
  height: 15px;
  align-items: flex-end;
}
.content-container {
  margin: 10px 0px 0px 0px;
  display: flex;
  flex-direction: column;
}
.input-filed {
  margin-top: 20px;
}
.button-container {
  margin-top: 30px;
  width: 100%;
  display: flex;
  justify-content: center;
}
.check-password-button {
  width: 90%;
  height: 36px;
  color: white;
  /*background: #206EEA;*/
  border-radius: 18px;
  border: 0;

}
</style>