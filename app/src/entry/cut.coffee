import Vue from 'vue/dist/vue'
import '../style/cut.sass'
import '../components/icon/style.sass'
import data from '../modules/cut/data.coffee'
import methods from '../modules/cut/methods.coffee'

# 初始化vue
app = new Vue({
  'el': '#vue-app',
  data,
  methods,
})