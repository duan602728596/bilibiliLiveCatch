import Vue from 'vue/dist/vue'
import '../components/style.sass'
import '../../../public/icon/style.sass'
import data from '../components/data.coffee'
import methods from '../components/methods.coffee'

# 初始化vue
app = new Vue({
  'el': '#vue-app',
  data,
  methods,
})