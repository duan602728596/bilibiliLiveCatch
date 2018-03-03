request = global.require('request')

# 获取地址方法
export getUrl = (roomID)->
  return new Promise((resolve, reject)=>
    request({
      'url': "http://api.live.bilibili.com/api/playurl?cid=#{ roomID }&otype=json&quality=0&platform=web",
      'method': 'GET',
      'headers': {
        'Host': 'live.bilibili.com',
        'X-Requested-With': 'ShockwaveFlash/25.0.0.148',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36',
      },
      'encoding': 'utf-8',
    }, (err, res, body)=>
      if err
        reject(err)
      else
        resolve(body)
    )
  )