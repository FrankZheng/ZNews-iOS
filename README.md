ZNews-iOS （最新闻 iOS客户端）
=========
关于
---------
一个新闻客户端，实现了新闻列表和新闻内容的浏览。
后台从谷歌新闻抓取RSS，解析，并提取正文内容，保存到后台数据库中。


技术架构
---------
后台搭建在heroku上，目前有三个应用
* xnewsreader    一个web服务，对客户端提供json格式的内容。
* xnewscrawler   一个后台worker，定时去谷歌新闻抓取RSS，解析并保存到数据库中
* xnewsextractor 一个后台worker，定时去数据库中解析源新闻网页，提取正文并保存到数据库中。
* 数据库使用mongodb，使用的mongolab提供的云服务

预览
----------
![github](https://raw.githubusercontent.com/FrankZheng/ZNews-iOS/master/screenshots/1.png "github")
![github](https://raw.githubusercontent.com/FrankZheng/ZNews-iOS/master/screenshots/2.png "github")




