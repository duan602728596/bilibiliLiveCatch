import { isReset, time, zero, randomStr } from '../../components/function.coffee'
import { stdout, stderr, exit, error } from './childListener.coffee'
import config from '../../components/config.coffee'
import computingTime from './computingTime.coffee'
child_process = global.require('child_process')
path = global.require('path')

# 弹出层显示隐藏控制
dialogDisplay = (value)->
  @cutShow = value
  if value == false
    document.getElementById('dialog').reset()

# 选择文件
onVideoChange = (event)->
  file = event.target.files[0]
  @video = file ? file : null
  if file
    p = path.parse(file.path)
    @saveas = '[cut]' + p.name + '-' + time('YYMMDDhhmmss') + p.ext

onFileChange = (event)->
  file = event.target.files[0]
  @file = file ? file : null

# 添加
onAddCut = ()->
  x = {
    'id': randomStr(),
    'video': if @video then @video.path else '',
    'file': if @file then @file.path else '',
    'startHour': zero(@startHour),
    'startMinute': zero(@startMinute),
    'startSecond': zero(@startSecond),
    'endHour': zero(@endHour),
    'endMinute': zero(@endMinute),
    'endSecond': zero(@endSecond),
    'isEnd': false,
  }
  @cutList.push(x)
  @startHour = ''
  @startMinute = ''
  @startSecond = ''
  @endHour = ''
  @endMinute = ''
  @endSecond = ''
  document.getElementById('dialog').reset()

# 删除
onDelete = (item)->
  @item = item

# 确认删除
onOkDelete = ()->
  index = isReset(@cutList, 'id', @item.id, 0, @cutList.length - 1)
  @cutList.splice(index, 1)
  @item = null

# 取消删除
onCancelDelete = ()->
  @item = null

# 剪切
onStartCut = (item)->
  index = isReset(@cutList, 'id', item.id, 0, @cutList.length - 1)
  [h, m, s] = computingTime(
    [
      Number(item.startHour),
      Number(item.startMinute),
      Number(item.startSecond),
    ],
    [
      Number(item.endHour),
      Number(item.endMinute),
      Number(item.endSecond),
    ],
  )
  child = child_process.spawn(config.ffmpeg, [
    '-ss',
    "#{ item.startHour }:#{ item.startMinute }:#{ item.startSecond }",
    '-t',
    "#{ zero(h) }:#{ zero(m) }:#{ zero(s) }",
    '-accurate_seek',
    '-i',
    item.video,
    '-acodec',
    'copy',
    '-vcodec',
    'copy',
    item.file,
  ])
  Object.assign(item, {
    child,
  })
  child.stdout.on('data', stdout.bind(@, item))
  child.stderr.on('data', stderr.bind(@, item))
  child.on('exit', exit.bind(@, item))
  child.on('error', error.bind(@, item))
  @cutList.splice(index, 1, item)


methods = {
  dialogDisplay,
  onAddCut,
  onVideoChange,
  onFileChange,
  onDelete,
  onOkDelete,
  onCancelDelete,
  onStartCut,
}

export default methods