request = global.require('request')

# 获取html
export getHtml = (url)->
  return new Promise((resolve, reject)=>
    request({
      'url': url,
      'method': 'GET',
      'headers': {
        'Host': 'live.bilibili.com',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36',
      },
      'encoding': 'utf-8',
    }, (err, res, body)=>
      if err
        reject(err)
      else
        resolve([res, body])
    )
  )

# 解析
export analysisScripts = (html)->
  str = html.match(/var ROOMID = .*;/)
  id = str[0].match(/[0-9]+/)
  return id[0]