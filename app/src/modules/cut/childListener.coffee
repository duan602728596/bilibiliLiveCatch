# child进程的监听函数
import { isReset } from '../../components/function.coffee'

cb = (item)->
  index = isReset(@cutList, 'id', item.id, 0, @cutList.length - 1)
  delete item.child
  item.isEnd = true
  @cutList.splice(index, 1, item)

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