import Vue from 'vue/dist/vue'
import '../style/searchID.sass'
import '../components/icon/style.sass'
import data from '../modules/searchID/data.coffee'
import methods from '../modules/searchID/methods.coffee'


# 初始化vue
app = new Vue({
  'el': '#vue-app',
  data,
  methods,
})