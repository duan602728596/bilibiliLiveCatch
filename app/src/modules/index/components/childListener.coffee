# child进程的监听函数
import { isReset } from '../../../public/function.coffee'

cb = (item)->
  index = isReset(@idList, 'id', item.id, 0, @idList.length - 1)
  delete item.title
  delete item.child
  @idList.splice(index, 1, item)

export stdout = (item, data)->
  # console.log(data.toString())

export stderr = (item, data)->
  # console.log(data.toString())

export exit = (item, code, data)->
  console.log(code + ' ' + data)
  cb.call(@, item)

export error = (item, err)->
  console.error(err)
  cb.call(@, item)