request = global.require('request')
json_xml = global.require('json_xml')

# 获取地址方法
export getXML = (roomID)->
  return new Promise((resolve, reject)=>
    request({
      'url': "http://live.bilibili.com/api/playurl?player=1&cid=#{ roomID }&quality=0",
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

# 解析XML
export analysisXML = (str)->
  video = json_xml.xml2json(str)
  ###
  包含
    * url
    * b1url
    * b2url
    * b3url
  ###
  return video.video.durl