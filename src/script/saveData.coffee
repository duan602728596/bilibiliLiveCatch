###
  将直播间信息存储到数据库内
###

$ROOM_LIST = $('#roomList')
$INPUT_ROOM_NAME = $('#inputRoomName') # 房间名称输入框
$INPUT_ROOM_ID = $('#inputRoomId')     # 房间id输入框
$SAVE_ROOM_DATA = $('#saveRoomData')   # 保存按钮
$TISHI = $('#tiShi')                   # 提示信息
DB_OPTIONS = window.OPTIONS.db

saveData = (event)->
  name = $INPUT_ROOM_NAME.val()
  id = $INPUT_ROOM_ID.val()

  if name == ''
    $TISHI.html('请输入房间名称')
  else if id == ''
    $TISHI.html('请输入房间ID')
  else
    $TISHI.html('')
    room = {
      roomName: name,
      roomId: Number(id),
    }
    # 添加到数据库
    IndexedDB(DB_OPTIONS.name, DB_OPTIONS.version, {
      success: (rt)->
        obj = @getObjectStore(DB_OPTIONS.objectStore, true);
        obj.get(room.roomId, (result)->
          if !result
            obj.add(room)
            @db.close()

            # 渲染ui
            x = JSON.stringify(room).replace(/"/g, '\'')
            $("""<tr>
                   <td>#{ name }</td>
                   <td>#{ id }</td>
                   <td>
                     <button class="btn btn-primary btn-sm" type="button" data-fun="record" data-room="#{ x }">
                       <span class="glyphicon glyphicon-play"></span>
                       <span>录制</span>
                     </button>
                     <button class="btn btn-danger btn-sm" type="button" data-fun="delete" data-room="#{ x }">
                       <span class="glyphicon glyphicon-remove"></span>
                       <span>删除</span>
                     </button>
                   </td>
                 </tr>""").appendTo($ROOM_LIST)
            $INPUT_ROOM_NAME.val('')
            $INPUT_ROOM_ID.val('')
          else
            $TISHI.html('已存在')
        )
        return
    })



$SAVE_ROOM_DATA.on('click', saveData)
