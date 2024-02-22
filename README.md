[Redis模板.xml](https://www.yuque.com/attachments/yuque/0/2023/xml/26231376/1700553422679-92e0ce2a-b205-4599-a5cd-f7377afc9408.xml?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2023%2Fxml%2F26231376%2F1700553422679-92e0ce2a-b205-4599-a5cd-f7377afc9408.xml%22%2C%22name%22%3A%22Redis%E6%A8%A1%E6%9D%BF.xml%22%2C%22size%22%3A20320%2C%22ext%22%3A%22xml%22%2C%22source%22%3A%22%22%2C%22status%22%3A%22done%22%2C%22download%22%3Atrue%2C%22taskId%22%3A%22ua9f98194-2c4a-41b8-8de6-8cb7b1b732a%22%2C%22taskType%22%3A%22upload%22%2C%22type%22%3A%22text%2Fxml%22%2C%22__spacing%22%3A%22both%22%2C%22mode%22%3A%22title%22%2C%22id%22%3A%22joZTZ%22%2C%22margin%22%3A%7B%22top%22%3Atrue%2C%22bottom%22%3Atrue%7D%2C%22card%22%3A%22file%22%7D)



### zabbix-agent配置文件中开启自定义监控，去掉注释

```bash
Include=/etc/zabbix/zabbix_agentd.d/*.conf
```

### zabbix-agent配置文件中添加redis ping命令

```bash
UserParameter=Redis.Status,(redis-cli -h 10.108.141.62 -p 6379 -a P@ss1234  ping)2>/dev/null | grep -c PONG
```

### 在/etc/zabbix/zabbix_agentd.d下创建

```bash
vim userparameter_redis.conf
```

- userparameter_redis.conf内容如下

```bash
UserParameter=redis[*],/etc/zabbix/script/redis/zabbix_redis.sh $1
```

### 创建脚本存放目录

```bash
mkdir -p /etc/zabbix/script/redis
```

```bash
vim zabbix_redis.sh
```

### 脚本内容

```bash
#!/bin/bash
REDISPATH="/bin/redis-cli"
HOST="127.0.0.1"
PORT="6379"
REDIS_INFO="$REDISPATH -h $HOST -p $PORT -a P@ss1234 info"  ##-a 后面跟的是redis密码
if [[ $# == 1 ]];then
case $1 in
cluster)
result=`$REDIS_INFO 2>/dev/null |/bin/grep cluster|awk -F":" '{print $NF}'`
echo $result 
;; 
uptime_in_seconds)
result=`$REDIS_INFO 2>/dev/null |/bin/grep uptime_in_seconds|awk -F":" '{print $NF}'`
echo $result 
;; 
connected_clients)
result=`$REDIS_INFO 2>/dev/null |/bin/grep connected_clients|awk -F":" '{print $NF}'`
echo $result 
;; 
client_longest_output_list)
result=`$REDIS_INFO 2>/dev/null |/bin/grep client_longest_output_list|awk -F":" '{print $NF}'`
echo $result 
;; 
client_biggest_input_buf)
result=`$REDIS_INFO 2>/dev/null |/bin/grep client_biggest_input_buf|awk -F":" '{print $NF}'`
echo $result 
;; 
blocked_clients)
result=`$REDIS_INFO 2>/dev/null |/bin/grep blocked_clients|awk -F":" '{print $NF}'`
echo $result 
;; 
#内存
used_memory)
result=`$REDIS_INFO 2>/dev/null |/bin/grep used_memory|awk -F":" '{print $NF}'|awk 'NR==1'`
echo $result 
;; 
used_memory_human)
result=`$REDIS_INFO  2>/dev/null |/bin/grep used_memory_human|awk -F":" '{print $NF}'|awk -F'K' '{print $1}'` 
echo $result 
;; 
used_memory_rss)
result=`$REDIS_INFO  2>/dev/null |/bin/grep used_memory_rss|awk -F":" '{print $NF}'`
echo $result 
;; 
used_memory_peak)
result=`$REDIS_INFO 2>/dev/null |/bin/grep used_memory_peak|awk -F":" '{print $NF}'|awk 'NR==1'`
echo $result 
;; 
used_memory_peak_human)
result=`$REDIS_INFO 2>/dev/null |/bin/grep used_memory_peak_human|awk -F":" '{print $NF}'|awk -F'K' '{print $1}'`
echo $result 
;; 
used_memory_lua)
result=`$REDIS_INFO 2>/dev/null |/bin/grep used_memory_lua|awk -F":" '{print $NF}'`
echo $result 
;; 
mem_fragmentation_ratio)
result=`$REDIS_INFO 2>/dev/null |/bin/grep mem_fragmentation_ratio|awk -F":" '{print $NF}'`
echo $result 
;; 
#rdb
rdb_changes_since_last_save)
result=`$REDIS_INFO 2>/dev/null |/bin/grep rdb_changes_since_last_save|awk -F":" '{print $NF}'`
echo $result 
;; 
rdb_bgsave_in_progress)
result=`$REDIS_INFO 2>/dev/null |/bin/grep rdb_bgsave_in_progress|awk -F":" '{print $NF}'`
echo $result 
;; 
rdb_last_save_time)
result=`$REDIS_INFO 2>/dev/null |/bin/grep rdb_last_save_time|awk -F":" '{print $NF}'`
echo $result 
;; 
rdb_last_bgsave_status)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "rdb_last_bgsave_status" | awk -F':' '{print $2}' | /bin/grep -c ok`
echo $result 
;; 
rdb_current_bgsave_time_sec)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "rdb_current_bgsave_time_sec" | awk -F':' '{print $2}'`
echo $result 
;; 
#rdbinfo
aof_enabled)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_enabled" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_rewrite_scheduled)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_rewrite_scheduled" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_last_rewrite_time_sec)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_last_rewrite_time_sec" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_current_rewrite_time_sec)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_current_rewrite_time_sec" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_last_bgrewrite_status)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_last_bgrewrite_status" | awk -F':' '{print $2}' | /bin/grep -c ok`
echo $result 
;; 
#aofinfo
aof_current_size)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_current_size" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_base_size)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_base_size" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_pending_rewrite)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_pending_rewrite" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_buffer_length)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_buffer_length" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_rewrite_buffer_length)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_rewrite_buffer_length" | awk -F':' '{print $2}'`
echo $result 
;; 
aof_pending_bio_fsync)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_pending_bio_fsync" | awk -F':' '{print $2}'`
echo $result 
;;
aof_delayed_fsync)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "aof_delayed_fsync" | awk -F':' '{print $2}'`
echo $result 
;; 
#stats
total_connections_received)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "total_connections_received" | awk -F':' '{print $2}'`
echo $result 
;; 
total_commands_processed)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "total_commands_processed" | awk -F':' '{print $2}'`
echo $result 
;; 
instantaneous_ops_per_sec)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "instantaneous_ops_per_sec" | awk -F':' '{print $2}'`
echo $result 
;; 
rejected_connections)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "rejected_connections" | awk -F':' '{print $2}'` 
echo $result 
;; 
expired_keys)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "expired_keys" | awk -F':' '{print $2}'`
echo $result 
;; 
evicted_keys)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "evicted_keys" | awk -F':' '{print $2}'` 
echo $result 
;; 
keyspace_hits)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "keyspace_hits" | awk -F':' '{print $2}'` 
echo $result 
;; 
keyspace_misses)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "keyspace_misses" | awk -F':' '{print $2}'`
echo $result 
;;
pubsub_channels)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "pubsub_channels" | awk -F':' '{print $2}'`
echo $result 
;;
pubsub_channels)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "pubsub_channels" | awk -F':' '{print $2}'`
echo $result 
;;
pubsub_patterns)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "pubsub_patterns" | awk -F':' '{print $2}'`
echo $result 
;;
latest_fork_usec)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "latest_fork_usec" | awk -F':' '{print $2}'`
echo $result 
;; 
connected_slaves)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "connected_slaves" | awk -F':' '{print $2}'`
echo $result 
;;
master_link_status)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "master_link_status"|awk -F':' '{print $2}'|/bin/grep -c up`
echo $result 
;;
master_last_io_seconds_ago)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "master_last_io_seconds_ago"|awk -F':' '{print $2}'`
echo $result 
;;
master_sync_in_progress)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "master_sync_in_progress"|awk -F':' '{print $2}'`
echo $result 
;;
slave_priority)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "slave_priority"|awk -F':' '{print $2}'`
echo $result 
;;
#cpu
used_cpu_sys)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "used_cpu_sys"|awk -F':' '{print $2}'`
echo $result 
;;
used_cpu_user)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "used_cpu_user"|awk -F':' '{print $2}'`
echo $result 
;;
used_cpu_sys_children)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "used_cpu_sys_children"|awk -F':' '{print $2}'`
echo $result 
;;
used_cpu_user_children)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "used_cpu_user_children"|awk -F':' '{print $2}'`
echo $result 
;;
*)
echo "argu error"
;;
esac
#db0:key
elif [[ $# == 2 ]];then
case $2 in
keys)
result=`$REDIS_INFO 2>/dev/null | /bin/grep -w "db0"| /bin/grep -w "$1" | /bin/grep -w "keys" | awk -F'=|,' '{print $2}'`
echo $result 
;;
expires)
result=`$REDIS_INFO  2>/dev/null | /bin/grep -w "db0"| /bin/grep -w "$1" | /bin/grep -w "expires" | awk -F'=|,' '{print $4}'`
echo $result 
;;
avg_ttl)
result=`$REDIS_INFO 2>/dev/null |/bin/grep -w "db0"| /bin/grep -w "$1" | /bin/grep -w "avg_ttl" | awk -F'=|,' '{print $6}'`
echo $result 
;;
*)
echo "argu error" ;;
esac
fi
```

### 脚本授权

```bash
chmod +x zabbix_redis.sh
```

### 重启agent

```bash
systemctl restart zabbix-agent
```

### 测试server端能否拉取到数据

```bash
zabbix_get -s 10.108.141.62 -k redis[used_memory]
```

### web端添加模板即可

 ![](https://cdn.nlark.com/yuque/0/2023/png/26231376/1700114094589-9042f931-2db8-4293-9aba-0a1fbe07008e.png#averageHue=%23e8ca9e&clientId=ub4893b61-bf8d-4&from=paste&id=u63924231&originHeight=902&originWidth=1920&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=uc33c4b5e-d53a-4acb-bfdf-00c9d30c3a4&title=)
![](https://cdn.nlark.com/yuque/0/2023/png/26231376/1700114105031-7a39b82b-4b8f-476c-b35e-fdbeedb22881.png#averageHue=%23fefdfc&clientId=ub4893b61-bf8d-4&from=paste&id=ubcc6bf14&originHeight=902&originWidth=1920&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=ued058b1c-688f-4d2e-96b8-cf2451e9b36&title=)
