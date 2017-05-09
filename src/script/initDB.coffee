###
  初始化本地数据库，用于存储相关数据
###

DB_OPTIONS = window.OPTIONS.db

IndexedDB(DB_OPTIONS.name, DB_OPTIONS.version, {
  upgradeneeded: ()->
    # 初始化数据库配置
    if !@hasObjectStore(DB_OPTIONS.objectStore)
      @createObjectStore(DB_OPTIONS.objectStore, 'roomId', [
        {
          name: 'roomName',
          index: 'roomName',
        }
      ])
    @db.close()
    return
})