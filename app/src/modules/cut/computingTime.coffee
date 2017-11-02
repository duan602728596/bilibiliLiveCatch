###
  计算时间差
  @param { Array } startTime: 开始时间
  @param { Array } endTime  : 结束时间
  @return { Array }
###
computingTime = (startTime, endTime)->
  startS = startTime[0] * 3600 + startTime[1] * 60 + startTime[2]
  endS = endTime[0] * 3600 + endTime[1] * 60 + endTime[2]
  cha = endS - startS
  h = Number("#{ cha / 3600 }".match(/\d+/g)[0])
  hp = cha % 3600
  m = Number("#{ hp / 60 }".match(/\d+/g)[0])
  s = hp % 60
  return [h, m, s]

export default computingTime
