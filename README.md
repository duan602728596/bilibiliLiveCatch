# B站直播流抓取工具
B站直播流抓取功能，以及视频的快速剪切功能。
 
## ROOMID获取方法
<del>ROOMID查看方式：进入B站直播间 -> 右键 -> 查看源代码 -> 第24行</del>
B站直播已改版，ROOMID获取方式如下。
https://api.live.bilibili.com/room/v1/Room/room_init?id={{ ID }}，GET请求。

## 许可证
本软件遵循**Apache License 2.0**许可证。

## 技术栈
pug + sass + coffeescript + vue + bootstrap + webpack + nwjs。

## 目录结构
* nwjs: nwjs SDK
  * app: 源代码
  * dependent: 依赖的文件存储目录
    * ffmpeg: ffmpeg
  * output: 视频输出目录

## 源代码托管地址
[https://github.com/duan602728596/bilibiliLiveCatch](https://github.com/duan602728596/bilibiliLiveCatch)