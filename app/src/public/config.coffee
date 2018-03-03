# 配置文件
path = global.require('path')
process = global.require('process');

execPath = path.dirname(process.execPath).replace(/\\/g, '/')

config = {
  'indexeddb': {
    'name': 'bilibiliLiveCatch',
    'version': 1,
    'objectStore': {
      'list': {
        'name': 'list',
        'key': 'id',
        'data': [
          {
            'name': 'name',
            'index': 'name',
          },
        ],
      },
    },
  },
  'ffmpeg': execPath + '/dependent/ffmpeg/ffmpeg.exe',
  'output': execPath + '/output',
}

export default config