import { getHtml, analysisScripts } from './getHtml.coffee'
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
  [response, body] = await getHtml(@inputUrl)
  if response.statusCode != 200
    @error = response.statusCode
    setTimeout(()=>
      @error = null
    , 2000)
    return false
  @id = analysisScripts(body)


methods = {
  onCopy,
  onGetRoomId,
}

export default methods