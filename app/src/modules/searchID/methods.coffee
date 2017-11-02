import { getData } from './getHtml.coffee'
url = global.require('url')

# 复制
onCopy = ()->
  range = document.createRange();
  range.selectNode(document.getElementById('id'));
  selection = window.getSelection();
  if selection.rangeCount > 0
    selection.removeAllRanges()
  selection.addRange(range);
  document.execCommand('copy');

# 获取ROOMID
onGetRoomId = ()->
  u = url.parse(@inputUrl)
  if u.host != 'live.bilibili.com'
    @warnUrl = true
    setTimeout(()=>
      @warnUrl = false
    , 2000)
    return false
  id = @inputUrl.split(/\//g)
  id2 = id[id.length - 1]
  [res, body] = await getData(id2)
  body2 = JSON.parse(body)
  if res.statusCode == 200 and body2.code == 0
    @id = body2.data.room_id
  else
    @error = body2.msg
    setTimeout(()=>
      @error = null
    , 2000)
    return false


methods = {
  onCopy,
  onGetRoomId,
}

export default methods