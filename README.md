1、下载一键安装脚本

2、执行命令全自动安装zabbix-server
unzip zabbix-centos8-pgsql.zip

cd zzabbix-centos8-pgsql

sh autosetup.sh install
打开网页输入服务器IP地址访问zabbix
http://IP:8080 或 https://IP:8443
用户名: Admin
密码: zabbix
打开网页输入服务器IP地址访问grafana
https://IP:3000
用户名: admin
密码: admin

3、配置grafana
设置中文


启用zabbix插件



连接zabbix数据库插件

新建zabbix数据库连接
http://119.45.47.252:8080/api_jsonrpc.php		URL为zabbix访问地址+api_jsonrpc.php

zabbix登录的用户名密码

4、zabbix-server不需要https方式访问，或不需要重定向，注释以下部分即可
