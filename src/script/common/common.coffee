###
  公共函数
###
PATH = require('path');
PROCESS= require('process');
window.__dirname = PATH.dirname(PROCESS.execPath).replace(/\\/g, '/');

# 获取当前年月日时分秒
window.date = ()->
  date1 = new Date()
  return "#{ date1.getFullYear() }-#{ date1.getMonth() + 1 }-#{ date1.getDate() }-#{ date1.getHours() }-#{ date1.getMinutes() }-#{ date1.getSeconds() }"

# 随机字符串
str = ('qwertyuiopasdfghjklzxcvbnm' +
       'QWERTYUIOPASDFGHJKLZXCVBNM' +
       '1234567890').split('')
strLen = str.length
window.randomString = (len = 20)->
  s = ''
  for x in [0...len]
    s += str[Math.floor(Math.random() * strLen)]
  return s

# 配置文件
window.OPTIONS = {
  db: {
    name: 'bilibiliLiveCatch',
    version: 1,
    objectStore: 'roomList',
  },
}
