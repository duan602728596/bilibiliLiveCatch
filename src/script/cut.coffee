###
  剪切视频
###
PATH = require('path')
CHILD_PROCESS = require('child_process')
CUT_LIST = new Map()

$CUT = $('#cut')
$CUT_FILE = $('#cut-file')
$CUT_FILE_TEXT = $('#cut-file-text')
$CUT_SAVE = $('#cut-save')
$CUT_SAVE_TEXT = $('#cut-save-text')

$START_TIME_H = $('#startTime-h')
$START_TIME_M = $('#startTime-m')
$START_TIME_S = $('#startTime-s')
$END_TIME_H = $('#endTime-h')
$END_TIME_M = $('#endTime-m')
$END_TIME_S = $('#endTime-s')

$CUT_LIST_TABLE = $('#cut-list-table')

### 打开或者关闭界面 ###
openOrCloseCutList = (event)->
  $CUT.css('display', $(this).data('fun'))
  return

$('#cut-open').on('click', openOrCloseCutList)
$('#cut-close').on('click', openOrCloseCutList)

### 选择文件 ###
file_change = (event)->
  file = $CUT_FILE.val().replace(/\\/g, '/')
  $CUT_FILE_TEXT.html('<br>' + file)
  fileObj = PATH.parse(file)
  $CUT_SAVE.prop('nwsaveas', "#{ fileObj.name }_#{ date() }#{ fileObj.ext }")
  return

save_change = (event)->
  file = $CUT_SAVE.val()
  file2 = file.replace(/\\/g, '/')
  fileObj = PATH.parse(file)
  $CUT_SAVE.prop('nwworkingdir', fileObj.dir)
  $CUT_SAVE_TEXT.html('<br>' + file2)
  return

$CUT_FILE.on('change', file_change)
$CUT_SAVE.on('change', save_change)
$CUT_SAVE.prop('nwworkingdir', "#{ __dirname }/output".replace(/\//g, '\\'))

### 添加到剪辑列表 ###
# 补位
zeroString = (num)->
  return if num >= 10 then "#{ num }" else "0#{ num }"

# 计算时间差
computingTime = (startTime, endTime)->
  startS = startTime[0] * 3600 + startTime[1] * 60 + startTime[2]
  endS = endTime[0] * 3600 + endTime[1] * 60 + endTime[2]
  cha = endS - startS
  h = Number("#{ cha / 3600 }".match(/\d+/g)[0])
  hp = cha % 3600
  m = Number("#{ hp / 60 }".match(/\d+/g)[0])
  s = hp % 60
  return [h, m, s]

# 添加到列表
add2List = (event)->
  id = randomString(50)
  file = $CUT_FILE.val().replace(/\\/g, '/')
  save = $CUT_SAVE.val().replace(/\\/g, '/')
  st = [Number($START_TIME_H.val()), Number($START_TIME_M.val()), Number($START_TIME_S.val())]
  et = [Number($END_TIME_H.val()), Number($END_TIME_M.val()), Number($END_TIME_S.val())]
  cha = computingTime(st, et)
  ssString = "#{ zeroString(st[0]) }:#{ zeroString(st[1]) }:#{ zeroString(st[2]) }"
  toString = "#{ zeroString(et[0]) }:#{ zeroString(et[1]) }:#{ zeroString(et[2]) }"
  tString = "#{ zeroString(cha[0]) }:#{ zeroString(cha[1]) }:#{ zeroString(cha[2]) }"
  CUT_LIST.set(id, {
    file: file,
    saveFile: save,
    ss: ssString,
    to: toString
    t: tString,
    end: false,
    child: null,
  })
  # 渲染ui
  $tr = $CUT_LIST_TABLE.find('tr')
  $ele = """<tr id="_CUT_LIST_#{ id }_">
              <td>#{ file }</td>
              <td>#{ ssString }</td>
              <td>#{ toString }</td>
              <td>#{ save }</td>
              <td>
                <button class="btn btn-primary btn-sm fun-cut" type="button" data-fun="translate" data-id="#{ id }">
                  <span class="glyphicon glyphicon-refresh fun-cut-children"></span>
                  <span class="fun-cut-children">开始剪切</span>
                </button>
                <button class="btn btn-danger btn-sm fun-cut" type="button" data-fun="delete"  data-id="#{ id }">
                  <span class="glyphicon glyphicon-remove fun-cut-children"></span>
                  <span class="fun-cut-children">删除队列</span>
                </button>
              </td>
            </tr>"""
  if $tr.length == 0 then $CUT_LIST_TABLE.append($ele) else $tr.eq(0).before($ele)
  # 清除添加数据
  $CUT_FILE.val('')
  $CUT_FILE_TEXT.html('')
  $CUT_SAVE.val('')
  $CUT_SAVE_TEXT.html('')
  $START_TIME_H.val('')
  $START_TIME_M.val('')
  $START_TIME_S.val('')
  $END_TIME_H.val('')
  $END_TIME_M.val('')
  $END_TIME_S.val('')
  return

$('#addToList').on('click', add2List)

### 事件冒泡监听 ###

# 判断进程关闭，渲染ui
panduan = ()->
  CUT_LIST.forEach((value, key)->
    if (value.child.exitCode != null or value.child.killed) and value.end == false
      $tr = $("#_CUT_LIST_#{ key }_")
      $button = $tr.find('button')
      $button.eq(1).prop('disabled', false).before('<b class="cut-text">任务结束</b>')
      $button.eq(0).remove()
      value.end = true
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

# 转换
translateCut = (id, $element)->
  obj = CUT_LIST.get(id)
  obj.child = CHILD_PROCESS.spawn(__dirname + '/ffmpeg.exe', [
    '-ss',
    obj.ss,
    '-t',
    obj.t,
    '-accurate_seek',
    '-i',
    obj.file,
    '-acodec',
    'copy',
    '-vcodec',
    'copy',
    '-y',
    obj.saveFile,
  ])

  obj.child.stdout.on('data', stdout)
  obj.child.stderr.on('data', stderr)
  obj.child.on('exit', exit)
  obj.child.on('error', error)
  # 修改ui
  $span = $element.data('fun', 'stop').find('span')
  $span.eq(0).removeClass('glyphicon-refresh').addClass('glyphicon-stop')
  $span.eq(1).html('停止剪切')
  $element.next('button').prop('disabled', true)
  return

# 停止
stopCut = (id)->
  obj = CUT_LIST.get(id)
  obj.child.kill()
  return

# 删除
deleteList = (id)->
  CUT_LIST.delete(id)
  $("#_CUT_LIST_#{ id }_").remove()
  return

cutListOnClick = (event)->
  $e = $(event.target)
  $element = null

  if $e.hasClass('fun-cut')
    $element = $e
  else if $e.hasClass('fun-cut-children')
    $element = $e.parent()

  if $element
    fun = $element.data('fun')
    id = $element.data('id')
    switch fun
      when 'delete'
        if !$element.prop('disabled') then deleteList(id)
      when 'translate' then translateCut(id, $element)
      when 'stop' then stopCut(id, $element)
  return


$CUT_LIST_TABLE.on('click', cutListOnClick)
