我用的 VPS 是 [Digital Ocean](https://www.digitalocean.com/?refcode=ab77d6daff97) 的 SFO1, 这个据说对大陆的访问作了优化，我在学校的时候用校园网(双线20M)看 Youtube 下行速率可达500-600kb/s，基本满足了日常生活的使用。不过我家的电信6M宽带极其不给力，下行速率只有50kb/s左右：

{<1>}![](/content/images/2015/02/QQ20150201-1.png)
之前在[v2ex](http://www.v2ex.com/?r=huanglexus)看到有人说[锐速](http://www.serverspeeder.com/)这款单边 TCP 加速服务效果很好，于是就去试了一下，效果果然很明显(请无视上传速率，我这电信上行带宽估计只有512K- -):

{<2>}![](/content/images/2015/02/QQ20150201-2.png)

下面就分享一下[Digital Ocean](https://www.digitalocean.com/?refcode=ab77d6daff97) Ubuntu 14.04环境下如何安装和配置锐速：

注册帐号后，在[这里](http://my.serverspeeder.com/w.do?m=lsl)已经有很详细的步骤了。

有一点要注意，目前对于 Ubuntu 14.04 ,锐速只支持内核`3.13.0-24-generic`，所以，如果你用的内核不是这个的话，先到 DO 的控制面板修改你的 VPS 的kernel 版本，像这样：

{<3>}![](/content/images/2015/02/QQ20150201-3.png)
安装成功后，用你最喜欢的编辑器打开锐速的配置文件：
```
➜  ~  sudo nano /serverspeeder/etc/config
```
**修改`rsc="1"`**后，重启服务：
```
➜  ~  sudo bash /serverspeeder/bin/serverSpeeder.sh reload
```
享受单边 TCP 加速带来的快感吧！

>参考资料：  
1. [Zeta-TCP](http://en.wikipedia.org/wiki/Zeta-TCP)
2. [锐速 Q&A](http://my.serverspeeder.com/downloadlsQA_cn.jsp)