[MySQL模板.xml](https://www.yuque.com/attachments/yuque/0/2023/xml/26231376/1700553443131-7bb897ff-ed17-48c6-8b3f-314bbeef5800.xml?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2023%2Fxml%2F26231376%2F1700553443131-7bb897ff-ed17-48c6-8b3f-314bbeef5800.xml%22%2C%22name%22%3A%22MySQL%E6%A8%A1%E6%9D%BF.xml%22%2C%22size%22%3A8444%2C%22ext%22%3A%22xml%22%2C%22source%22%3A%22%22%2C%22status%22%3A%22done%22%2C%22download%22%3Atrue%2C%22taskId%22%3A%22u387ac587-d613-472a-90d2-dd5c8550177%22%2C%22taskType%22%3A%22upload%22%2C%22type%22%3A%22text%2Fxml%22%2C%22__spacing%22%3A%22both%22%2C%22mode%22%3A%22title%22%2C%22id%22%3A%22aR3Uj%22%2C%22margin%22%3A%7B%22top%22%3Atrue%2C%22bottom%22%3Atrue%7D%2C%22card%22%3A%22file%22%7D)

### 设置授权用户和密码

```bash
[root@zabbix-agent-none1 ~]# vim /etc/my.cnf
在末行插入以下内容：
[client]
default-character-set=utf8
host=localhost
user='zabbix'
password='Yuanwei@123'
```

### 进入数据库授权用户和密码

```bash
[root@zabbix-agent-none1 ~]# mysql -uroot -p
Enter password:    //密码为Yuanwei@123
mysql>  grant all privileges on *.* to zabbix@localhost identified by 'Yuanwei@123';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> flush privileges;  
Query OK, 0 rows affected (0.00 sec)

mysql> \q
Bye
```

### agent配置文件打开自定义监控

```bash
vim /etc/zabbix/zabbix_agentd.conf
```

### 去掉注释

```bash
Include=/etc/zabbix/zabbix_agentd.d/*.conf
```

### 编辑自定义监控脚本

```bash
vim /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
```

### 脚本内容

```bash
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
```

### 重启agent

```bash
systemctl restart zabbix-agent
```

### server端测试能否拉取到数据

```bash
[root@zabbix ~]# zabbix_get -s 10.108.141.170 -p 10050 -k "mysql.ping"
1
[root@zabbix ~]# zabbix_get -s 10.108.141.170 -p 10050 -k "mysql.version"
5.7.27
```

### web端添加模板

![](https://cdn.nlark.com/yuque/0/2023/png/26231376/1700115347682-483edb44-49ce-4f79-9bc2-b4d25084068a.png#averageHue=%23e7cb98&clientId=uf7ec0ba7-ea59-4&from=paste&id=uda510094&originHeight=902&originWidth=1920&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u0d4fdb4e-91a0-44ef-9cfb-641a27df5e4&title=)

### 绑定主机，查看最新数据

![](https://cdn.nlark.com/yuque/0/2023/png/26231376/1700115377216-2528850d-5266-4853-b837-b7f62076c786.png#averageHue=%23e8c799&clientId=uf7ec0ba7-ea59-4&from=paste&id=u91123285&originHeight=902&originWidth=1920&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=uee4068d4-77a6-45a5-a27c-fbe42e4ce4d&title=)

新增MySQL锁表数量监控项，只需在模板>监控项添加即可
![image.png](https://cdn.nlark.com/yuque/0/2023/png/26231376/1703036864611-1d914394-ccdc-44b7-8b6a-59c46a4cc8c2.png#averageHue=%23fefdfd&clientId=u340cac53-d19a-4&from=paste&height=704&id=ua0a3f5fb&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=106586&status=done&style=none&taskId=uc61e74c2-e7ad-4598-a85f-832763c5859&title=&width=1536)
![image.png](https://cdn.nlark.com/yuque/0/2023/png/26231376/1703037351479-65417b69-7c6b-488d-95e9-4416a1eb1b22.png#averageHue=%23fefdfd&clientId=uda6a065e-63a3-4&from=paste&height=704&id=ud7225cd3&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=103514&status=done&style=none&taskId=u769ba083-8040-4fa7-9d2c-fc353f53fa2&title=&width=1536)
