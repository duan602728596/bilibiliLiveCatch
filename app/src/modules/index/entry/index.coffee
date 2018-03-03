import Vue from 'vue/dist/vue'
import IndexedDB from 'indexeddb-tools';
import '../components/style.sass'
import '../../../public/icon/style.sass'
import config from '../../../public/config.coffee'
import data from '../components/data.coffee'
import methods from '../components/methods.coffee'

# 初始化vue
app = new Vue({
  'el': '#vue-app',
  data,
  methods,
})

# 初始化数据库
{ name, version, objectStore } = config.indexeddb

initDbUp = (et, event)->
  list = objectStore.list
  if not @.hasObjectStore(list.name)
    @.createObjectStore(list.name, list.key, list.data)

initDbSuccess = (et, event)->
  _this = @
  store = @getObjectStore(objectStore.list.name)
  data2 = []
  store.cursor('name', (event)->
    { result } = event.target
    if result
      data2.push(result.value)
      result.continue()
    else
      app.idList = data2
      app.tableLoading = false
      _this.close()
  )

IndexedDB(name, version, {
  'success': initDbSuccess,
  'upgradeneeded': initDbUp,
})