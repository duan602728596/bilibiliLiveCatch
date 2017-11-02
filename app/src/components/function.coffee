# 公共方法

# 查重
export isReset = (rawArray, key, value, from, to)->
  if rawArray.length == 0
    return null

  if from == to
    if rawArray[from][key] == value
      return from
    else
      return null

  middle = Math.floor((to - from) / 2) + from

  left = isReset(rawArray, key, value, from, middle)
  if left != null
    return left

  right = isReset(rawArray, key, value, middle + 1, to)
  if right != null
    return right

  return null

# 补零
export zero = (arg)->
  num = if typeof arg == 'number' then arg else Number(arg)
  return if num > 10 then "#{ num }" else "0#{ num }"

# 时间
export time = (template, timeStr)->
  date = if timeStr then new Date(timeStr) else new Date()
  year = date.getFullYear()
  month = date.getMonth() + 1
  day = date.getDate()
  hour = date.getHours()
  minute = date.getMinutes()
  second = date.getSeconds()
  return template.replace(/Y{2}/, year)
    .replace(/M{2}/, zero(month))
    .replace(/D{2}/, zero(day))
    .replace(/h{2}/, zero(hour))
    .replace(/m{2}/, zero(minute))
    .replace(/s{2}/, zero(second))

# 获取随机数
STR = '1234567890QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm'
STR_LEN = STR.length
export randomStr = (len = 10)->
  str = ''
  for index in [0..len]
    str += STR[Math.floor(Math.random() * STR_LEN)]
  return str