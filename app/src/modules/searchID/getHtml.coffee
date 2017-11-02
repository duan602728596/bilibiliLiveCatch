request = global.require('request')

# 获取数据
export getData = (id)->
  return new Promise((resolve, reject)=>
    request({
      'url': 'https://api.live.bilibili.com/room/v1/Room/room_init?id=' + id,
      'method': 'GET',
      'encoding': 'utf-8',
    }, (err, res, body)=>
      if err
        console.error(err)
        reject(err)
      else
        resolve([res, body])
    )
  )