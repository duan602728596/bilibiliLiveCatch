###
  从本地数据库中获取数据，并渲染到页面上
###

DB_OPTIONS = window.OPTIONS.db

IndexedDB(DB_OPTIONS.name, DB_OPTIONS.version, {
  success: (et)->
    store = @getObjectStore(DB_OPTIONS.objectStore)
    html = ''
    store.cursor('roomName', (result)->
      if result
        x = JSON.stringify(result.value).replace(/"/g, '\'')
        html += """<tr>
                       <td>#{ result.value.roomName }</td>
                       <td>#{ result.value.roomId }</td>
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
                     </tr>"""
        result.continue()
      else
        $('#roomList').html(html)
        @db.close()
    )
})