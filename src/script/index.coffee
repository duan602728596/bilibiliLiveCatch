PATH = require('path');
PROCESS= require('process');
CHILD_PROCESS = require('child_process');
NODEGRASS = require('nodegrass')
CHEERIO = require('cheerio')
__dirname = PATH.dirname(PROCESS.execPath).replace(/\\/g, '/');
$ROOM_LIST = $('#roomList')
DB_OPTIONS = window.OPTIONS.db
MAP = new Map()

# 获取当前年月日时分秒
date = ()->
  date1 = new Date()
  return "#{ date1.getFullYear() }-#{ date1.getMonth() + 1 }-#{ date1.getDate() }-#{ date1.getHours() }-#{ date1.getMinutes() }-#{ date1.getSeconds() }"

# 判断进程关闭，渲染ui
panduan = ()->
  MAP.forEach((value, key)->
    if value.child.exitCode or value.child.killed
      $span = value.element.data('fun', 'record').find('span')
      $span.eq(0).removeClass('glyphicon-stop').addClass('glyphicon-play')
      $span.eq(1).html('录制')
      value.element.next('button').prop('disabled', false)
      MAP.delete(key)
    return
  )
  return

# 监听子进程
stdout = (data)->
  console.log('stdout：\n' + data)
  return

stderr = (data)->
  # console.log('stderr：\n' + data)
  return

exit = (code, data)->
  panduan()
  console.log('exit：\n' + code + '\n' + data)
  return

error = (err)->
  panduan()
  console.log('error：\n' + err)
  return

# 录像事件
_rv_1 = (room)->
  return new Promise((resolve, reject)->
    NODEGRASS.get("http://live.bilibili.com/api/playurl?player=1&cid=#{ room.roomId }&quality=0", (data, status, headers)->
      resolve([data, status, headers])
    {
      'Host': 'live.bilibili.com',
      'X-Requested-With': 'ShockwaveFlash/25.0.0.148',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36',
    })
  )

_rv_2 = (promise)->
  return promise.then((result)->
    [data, status, headers] = result
    xml = CHEERIO.load(data)
    Promise.resolve(xml('url')[0].children[0].data.match(/http(s)?:[^\[\]]+/g)[0])
  )

_rv_3 = (promise, room, $element)->
  return promise.then((url)->
    title = "bilibili_#{ room.roomName }_#{ room.roomId }_#{ date() }"
    child = CHILD_PROCESS.spawn(__dirname + '/ffmpeg.exe', ['-i', url, '-c', 'copy', "#{ __dirname }/output/#{ title }.flv"])
    child.stdout.on('data', stdout)
    child.stderr.on('data', stderr)
    child.on('exit', exit)
    child.on('error', error)

    MAP.set(room.roomId, {
      child: child,
      element: $element,
      room: room,
      url: url,
    })
    # 修改ui
    $span = $element.data('fun', 'stop').find('span')
    $span.eq(0).removeClass('glyphicon-play').addClass('glyphicon-stop')
    $span.eq(1).html('停止')
    $element.next('button').prop('disabled', true)
    return
  )

# 录像
recordVideo = (room, $element)->
  start = (room)->
    yield _rv_1(room)
    yield _rv_2(_1.value)
    yield _rv_3(_2.value, room, $element)
    return

  _0 = start(room)
  _1 = _0.next()
  _2 = _0.next()
  _3 = _0.next()
  return

# 停止录像
stopRecord = (room, $element)->
  o = MAP.get(room.roomId)
  o.child.kill()
  return

# 从数据库删除一个字段
deleteRoom = (room, $element)->
  IndexedDB(DB_OPTIONS.name, DB_OPTIONS.version, {
    success: (et)->
      # 删除数据
      store = @getObjectStore(DB_OPTIONS.objectStore)
      store.delete(room.roomId)
      @db.close()
      # 改变ui
      $element.parents('tr').remove()
      return
  })

# 事件冒泡监听
roomListOnClick = (event)->
  e = event.target
  element = null

  if e.tagName == 'BUTTON'
    element = e
  else if e.tagName == 'SPAN'
    element = e.parentNode

  if element
    $element = $(element)
    fun = $(element).data('fun')
    room = JSON.parse($(element).data('room').replace(/'/g, '"'))
    switch fun
      when 'delete'
        if !$element.prop('disabled') then deleteRoom(room, $element)
      when 'record' then recordVideo(room, $element)
      when 'stop' then stopRecord(room, $element)

  return


$ROOM_LIST.on('click', roomListOnClick)