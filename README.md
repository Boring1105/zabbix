
模板下载地址：
https://cowtransfer.com/s/10f3915ccd3f45 点击链接查看 [ MySQL模板.xml ] ，或访问奶牛快传 cowtransfer.com 输入传输口令 pir0iu 查看；
设置授权用户和密码
[root@zabbix-agent-none1 ~]# vim /etc/my.cnf
在末行插入以下内容：
[client]
default-character-set=utf8
host=localhost
user='zabbix'
password='Yuanwei@123'
进入数据库授权用户和密码
[root@zabbix-agent-none1 ~]# mysql -uroot -p
Enter password:    //密码为Yuanwei@123
mysql>  grant all privileges on *.* to zabbix@localhost identified by 'Yuanwei@123';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> flush privileges;  
Query OK, 0 rows affected (0.00 sec)

mysql> \q
Bye
agent配置文件打开自定义监控
vim /etc/zabbix/zabbix_agentd.conf
去掉注释
Include=/etc/zabbix/zabbix_agentd.d/*.conf
编辑自定义监控脚本
vim /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
脚本内容
#监控MySQL版本
UserParameter=mysql.version,mysql -V | cut -f6 -d" " | sed 's/,//'
##监控MySQL进程数
UserParameter=mysql.process,ps -ef|grep "mysql"|grep -v "grep"|wc -l
##监控MySQL运行状态
UserParameter=mysql.ping,/usr/bin/mysqladmin ping|grep alive|wc -l
##监控MySQL运行时间
UserParameter=mysql.uptime,/usr/bin/mysqladmin extended-status|grep Uptime|head -1|cut -f3 -d"|"
##监控MySQL的连接数
UserParameter=mysql.Threads.connected,/usr/bin/mysqladmin extended-status|grep Threads_connected|head -1|cut -f3 -d"|"
##监控MySQL活动状态的连接数
UserParameter=mysql.Threads.running,/usr/bin/mysqladmin extended-status|grep Threads_running|head -1|cut -f3 -d"|"
##监控MySQL客户端异常中断的数值
UserParameter=mysql.aborted.clients,/usr/bin/mysqladmin extended-status|grep Aborted_clients|head -1|cut -f3 -d"|"
##监控MySQL主从状态
UserParameter=mysql.Slave.status,/usr/bin/mysqladmin extended-status|grep Slave_runnin | grep -o ON |wc -l
##监控MySQL每秒钟获得的查询量
UserParameter=mysql.questions,/usr/bin/mysqladmin extended-status | grep Questions | head -1 | cut -f3 -d"|" 
##监控MySQL从数据文件里取数据的次数
UserParameter=mysql.read.rnd,/usr/bin/mysqladmin extended-status|grep Handler_read_rnd_next|head -1 | cut -f3 -d"|"  
##监控MySQL往数据文件里写数据的次数
UserParameter=mysql.write.rnd,/usr/bin/mysqladmin extended-status|grep Handler_write|head -1|cut -f3 -d"|" 
##监控MySQL内部COMMIT命令的个数
UserParameter=mysql.commit,/usr/bin/mysqladmin extended-status|grep Handler_commit| head -1 | cut -f3 -d"|" 
##监控MySQL请求从一张表中删除行的次数。
UserParameter=mysql.delete,/usr/bin/mysqladmin extended-status|grep Handler_delete| head -1 | cut -f3 -d"|" 
##监控MySQL表缓存没有命中的数量
UserParameter=mysql.Opened.tables,/usr/bin/mysqladmin extended-status|grep Opened_tables| head -1 | cut -f3 -d"|" 
##监控MySQL没有使用索引查询数量
UserParameter=mysql.slowqueries,/usr/bin/mysqladmin extended-status|grep Slow_queries|cut -f3 -d"|"
##监控MySQL执行全表搜索查询的数量
UserParameter=mysql.select.scan,/usr/bin/mysqladmin extended-status|grep Select_scan|cut -f3 -d"|"
##监控MySQL锁表数量
UserParameter=mysql.lock.table,/usr/bin/mysql -e "SHOW OPEN TABLES WHERE In_use > 0" | wc -l
重启agent
systemctl restart zabbix-agent
server端测试能否拉取到数据
[root@zabbix ~]# zabbix_get -s 10.108.141.170 -p 10050 -k "mysql.ping"
1
[root@zabbix ~]# zabbix_get -s 10.108.141.170 -p 10050 -k "mysql.version"
5.7.27
web端添加模板

绑定主机，查看最新数据


新增MySQL锁表数量监控项，只需在模板>监控项添加即可


