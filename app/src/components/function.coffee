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
    .replace(/M{2}/, month)
    .replace(/D{2}/, day)
    .replace(/h{2}/, hour)
    .replace(/m{2}/, minute)
    .replace(/s{2}/, second)