###
  本地数据库
###

((factory)->
  # 函数工厂
  factory(window)
  return
)((_window)->
  ###
    获取IDBKeyRange
    根据字符串返回游标查询的范围，例如：
    '5'      等于
    '>  5'   大于
    '>= 5'   大于等于
    '<  5'   小于
    '<= 5'   小于等于
    '[5, 8]' 闭区间
    '(5, 8)' 开区间
    @param {String} range: 传递字符串
    @return
  ###
  getRange = (range)->
    result = null

    if typeof range == 'number'
      result = range
    else if typeof range == 'string'
      # 对字符串进行判断
      # 大于
      if /^\s*>\s*(-?\d+(\.\d+)?)\s*$/i.test(range)
        result = IDBKeyRange.lowerBound(Number(range.match(/(-?\d+(\.\d+)?)/g)[0]), true)
      # 大于等于
      else if /^\s*>\s*=\s*(-?\d+(\.\d+)?)\s*$/i.test(range)
        result = IDBKeyRange.lowerBound(Number(range.match(/(-?\d+(\.\d+)?)/g)[0]))
      # 小于
      else if /^\s*<\s*(-?\d+(\.\d+)?)\s*$/i.test(range)
        result = IDBKeyRange.upperBound(Number(range.match(/(-?\d+(\.\d+)?)/g)[0]), true)
      # 小于等于
      else if /^\s*<\s*=\s*(-?\d+(\.\d+)?)\s*$/i.test(range)
        result = IDBKeyRange.upperBound(Number(range.match(/(-?\d+(\.\d+)?)/g)[0]))
      # 判断区间
      else if /^\s*[\[\(]\s*(-?\d+(\.\d+)?)\s*\,\s*(-?\d+(\.\d+)?)\s*[\]\)]\s*$/i.test(range)
        [v0, v1] = range.match(/(-?\d+(\.\d+)?)/g)
        [isOpen0, isOpen1] = [false, false]
        # 判断左右开区间和闭区间
        if /^.*\(.*$/.test(range)
          isOpen0 = true
        if /^.*\).*$/.test(range)
          isOpen1 = true
        result = IDBKeyRange.bound(Number(v0), Number(v1), isOpen0, isOpen1)
      else
        result = range

    return result


  ###
    IndexedDB
    @param {String} name          : 创建或者连接的数据库名
    @param {Number} version       : 数据库版本号
    @param {Object} callbackObject: 配置回调函数
    callbackObject用来配置创建或者连接数据库的回调函数
    success：创建或者连接的数据库成功后的回调函数
    error：创建或者连接的数据库失败后的回调函数
    upgradeneeded：数据库版本号更新后的回调函数
  ###
  IndexedDB = (name, version, callbackObject = {})->
    IndexedDB.prototype.indexeddb = IndexedDB.indexeddb
    IndexedDB.prototype.Init.prototype = IndexedDB.prototype
    # 返回实例
    return new IndexedDB.prototype.Init(name, version, callbackObject)


  # 是否有事件执行
  IndexedDB._funIng = false

  # 兼容不同浏览器
  IndexedDB.indexeddb = _window.indexedDB || _window.webkitIndexedDB


  ###
    删除数据库
    @param {String} databaseName: 数据库名
  ###
  IndexedDB.deleteDatabase = (databaseName)->
    IndexedDB.indexeddb.deleteDatabase(databaseName)
    console.log("删除数据库：#{ databaseName }。")


  ### IndexedDB.prototype.Init ###

  ###
    初始化
    @param {String} name          : 创建或者连接的数据库名
    @param {Number} version       : 数据库版本号
    @param {Object} callbackObject: 配置回调函数
  ###
  IndexedDB.prototype.Init = (name, version, callbackObject)->
    # 数据库的名字、版本，回调函数、表
    @name = name
    @version = version
    @callbackObject = callbackObject
    @db = null

    # 创建或者打开数据库
    @request = @indexeddb.open(name, version)

    # 打开数据库成功
    @_requestSuccess = (event)->
      console.log('打开数据库成功！')
      if @callbackObject.success
        @db = event.target.result
        @callbackObject.success.call(@, event.target)
      return

    # 打开数据库失败
    @_requestError = (event)->
      console.log('打开数据库失败！');
      if @callbackObject.error
        console.log(event.target.error.message)
        @callbackObject.error.call(@, event.target.error)
      return

    # 更新数据库版本
    @_requestUpgradeneeded = (event)->
      console.log('数据库版本更新！');
      if @callbackObject.upgradeneeded
        @db = event.target.result
        @callbackObject.upgradeneeded.call(@, event.target)
      return

    ###
      xx秒后关闭数据库
      @param {Number} time: 延迟关闭的时间
    ###
    @close = (time = 100)->
      close = ()=>
        if IndexedDB._funIng == true
          @db.close();
          console.log('数据库关闭。');
        else
          setTimeout(close, time)
        return
      setTimeout(close, time)
      return

    ###
      判断是否有ObjectStore
      @param {String} objectStoreName: ObjectStore名字
      @return {Boolean}
    ###
    @hasObjectStore = (objectStoreName)->
      return @db.objectStoreNames.contains(objectStoreName)

    ###
      创建ObjectStore
      @param {String} objectStoreName: ObjectStore名字
      @param {String} keyPath        : ObjectStore关键字
      @param {Array} indexArray      : 添加索引和键值，name -> 索引， age -> 键值
    ###
    @createObjectStore = (objectStoreName, keyPath, indexArray)->
      if !@hasObjectStore(objectStoreName)
        store = @db.createObjectStore(objectStoreName, {
          keyPath: keyPath
        })

        if indexArray
          for item, index in indexArray
            store.createIndex(
              item.name,   # 索引
              item.index,  # 键值
              {            # 索引是否唯一
                unique: if item.unique then item.unique else false,
              })
        console.log("创建了新的ObjectStore：#{ objectStoreName }。")
      else
        console.log("ObjectStore：#{ objectStoreName }已存在。")
      return @

    ###
      删除ObjectStore
      @param {String} objectStoreName: ObjectStore名字
    ###
    @deleteObjectStore = (objectStoreName)->
      if !@hasObjectStore(objectStoreName)
         @db.deleteObjectStore(objectStoreName)
         console.log("删除了新的ObjectStore：#{ objectStoreName }。")
       else
         console.log("ObjectStore：#{ objectStoreName }不存在。")
      return @

    ###
      获取操作ObjectStore
      @param {String} objectStoreName: ObjectStore名字
      @param {Boolean} writeAble     : 只读还是读写
    ###
    @getObjectStore = (objectStoreName, writeAble = true)->
      return new ObjectStore(@db, objectStoreName, writeAble)

    # 绑定函数
    @request.addEventListener('success', @_requestSuccess.bind(@), false)
    @request.addEventListener('error', @_requestError.bind(@), false)
    @request.addEventListener('upgradeneeded', @_requestUpgradeneeded.bind(@), false)

    return @


  ### objectsSore ###

  # 初始化
  ObjectStore = (db, objectStoreName, writeAble)->
    @db = db;

    wa = if writeAble == true then 'readwrite' else 'readonly'
    transaction = @db.transaction(objectStoreName, wa);

    @store = transaction.objectStore(objectStoreName)
    return @

  ###
    添加数据
    @param {Object | Array} obj: 数组添加多个数据，object添加单个数据
  ###
  ObjectStore.prototype.add = (obj)->
    IndexedDB._funIng = true;
    obj = if obj instanceof Array then obj else [obj]
    j = obj.length
    for item, i in obj
      @store.add(item);
      if i == j
        console.log('数据添加成功');
        IndexedDB._funIng = false
    return @

  ###
    更新数据
    @param {Object | Array} obj: 数组添加多个数据，object添加单个数据
  ###
  ObjectStore.prototype.put = (obj)->
    IndexedDB._funIng = true
    obj = if obj instanceof Array then obj else [obj]
    j = obj.length
    for item, i in obj
      @store.put(item);
      if i == j
        console.log('数据更新成功')
        IndexedDB._funIng = false
    return @

  ###
    删除数据
    @param {String | Number | Array} value: 数组添加多个数据，object添加单个数据
  ###
  ObjectStore.prototype.delete = (value)->
    IndexedDB._funIng = true
    value = if value instanceof Array then value else [value]
    j = value.length
    for item, i in value
      @store.delete(item);
      if i == j
        console.log('数据删除成功')
        IndexedDB._funIng = false
    return @

  # 清除数据
  ObjectStore.prototype.clear = (value)->
    @store.clear()
    console.log('数据清除成功')
    return @

  ###
    获取数据
    @param {String | Number} value: 键值
    @param {Function} callback    : 获取成功的回调函数
  ###
  ObjectStore.prototype.get = (value, callback)->
    g = this.store.get(value)

    success = (event)->
      if callback
        callback.call(@, event.target.result, event.target)

    g.addEventListener('success', success.bind(@), false)
    return @

  ###
    游标
    @param {String} indexName               : 索引名
    @param {String | Number | Boolean} range: 查询范围：有等于，大于等于，小于，小于等于，区间
    @param {Function} callback              : 查询成功的回调函数
    result.value
    result.continue()
  ###
  ObjectStore.prototype.cursor = (indexName)->
    callback = if typeof arguments[1] == 'function' then arguments[1] else arguments[2]

    index = this.store.index(indexName);
    range = if arguments[2] then getRange(arguments[1]) else null;
    cursor = if range == null then index.openCursor() else index.openCursor(range);

    success = (event)->
      if callback
        callback.call(@, event.target.result, event.target)

    cursor.addEventListener('success', success.bind(@), false);
    return @

  _window.IndexedDB = IndexedDB;
  return
)
