import IndexedDB from 'indexeddb-tools';
import config from '../../components/config.coffee'
import { isReset, time } from '../../components/function.coffee'
import { getXML, analysisXML } from './recordVideo.coffee'
import { stdout, stderr, exit, error } from './childListener.coffee'
gui = global.require('nw.gui')
childProcess = global.require('child_process');

SPACE_REG = /^\s*$/
{ name, version, objectStore } = config.indexeddb

# 弹出层显示隐藏控制
dialogDisplay = (value)->
  @addShow = value
  if value == false
    @name = ''
    @id = ''

# 添加一条数据
addAData = ()->
  _this = @
  # 表单验证
  if SPACE_REG.test(@name)
    @warnName = true
    setTimeout(()=>
      @warnName = false
    , 2000)
    return false
  if SPACE_REG.test(@id)
    @warnID = true
    setTimeout(()=>
      @warnID = false
    , 2000)
    return false
  # 查重
  index = isReset(@idList, 'id', @warnID, 0, @idList.length - 1)
  if index != null
    @warnIsReset = true
    setTimeout(()=>
      @warnIsReset = false
    , 2000)
    return false
  # 将数据添加到数据库中
  IndexedDB(name, version, {
    'success': (et, event)->
      store = @getObjectStore(objectStore.list.name)
      d = {
        'name': _this.name,
        'id': _this.id,
      }
      store.add(d)
      _this.idList.push(d)
      _this.name = ''
      _this.id = ''
      @close()
  })

# 删除
onDelete = (item)->
  @item = item

# 确认删除
onOkDelete = ()->
  _this = @
  { id } = @item
  index = isReset(@idList, 'id', id, 0, @idList.length - 1)
  IndexedDB(name, version, {
    'success': (et, event)->
      store = @getObjectStore(objectStore.list.name)
      store.delete(id)
      _this.idList.splice(index, 1)
      _this.item = null
      @close()
  })

# 取消删除
onCancelDelete = ()->
  @item = null

# 打开新窗口
onOpenSearchIDWindow = ()->
  gui.Window.open('./build/searchID.html', {
    'position': 'center',
    'width': 500,
    'height': 300,
    'focus': true,
    'title': 'ROOMID搜索',
  })

# 录制
onRecording = (item)->
  { name, id } = item
  index = isReset(@idList, 'id', id, 0, @idList.length - 1)
  result = await getXML(id)
  urlList = analysisXML(result)
  title = "#{ id }_#{ time('YYMMDDhhmmss') }"
  child = childProcess.spawn(config.ffmpeg, ['-i', urlList.url, '-c', 'copy', config.output + '/' + title + '.flv'])
  x = {
    id,
    name,
    title,
    child,
  }
  child.stdout.on('data', stdout.bind(@, x))
  child.stderr.on('data', stderr.bind(@, x))
  child.on('exit', exit.bind(@, x))
  child.on('error', error.bind(@, x))
  @idList.splice(index, 1, x)

# 停止录制
onStopRecording = (item)->
  index = isReset(@idList, 'id', item.id, 0, @idList.length - 1)
  item.child.kill()
  delete item.child
  delete item.title
  @idList.splice(index, 1, item)


methods = {
  dialogDisplay,
  addAData,
  onDelete,
  onOpenSearchIDWindow,
  onRecording,
  onStopRecording,
  onOkDelete,
  onCancelDelete,
}

export default methods