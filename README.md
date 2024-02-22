[zbx_export_templates.yaml](https://www.yuque.com/attachments/yuque/0/2024/yaml/26231376/1704768264456-a7f49b0f-55d7-4013-a011-14d05c589c81.yaml?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2024%2Fyaml%2F26231376%2F1704768264456-a7f49b0f-55d7-4013-a011-14d05c589c81.yaml%22%2C%22name%22%3A%22zbx_export_templates.yaml%22%2C%22size%22%3A1948%2C%22ext%22%3A%22yaml%22%2C%22source%22%3A%22%22%2C%22status%22%3A%22done%22%2C%22download%22%3Atrue%2C%22taskId%22%3A%22u73769b0a-f0e5-4bc0-b375-1bf25c61a66%22%2C%22taskType%22%3A%22upload%22%2C%22type%22%3A%22%22%2C%22__spacing%22%3A%22both%22%2C%22mode%22%3A%22title%22%2C%22id%22%3A%22Gx2JX%22%2C%22margin%22%3A%7B%22top%22%3Atrue%2C%22bottom%22%3Atrue%7D%2C%22card%22%3A%22file%22%7D)
自动发现服务器/app/目录下的java进程端口

#### 修改zabbix_agentd.conf

```bash
vim /etc/zabbix/zabbix_agentd.conf
```

添加以下内容

```bash
UserParameter=port_discovery,python /etc/zabbix/script/port.py
```

#### 创建自定义脚本目录

```bash
mkdir -p /etc/zabbix/script

cd /etc/zabbix/script
```

#### 编辑自定义监控脚本

```bash
vim port.py
```

```bash
#!/usr/bin/python
#coding:utf-8
import os
import json
import re

def get_java_processes(user):
    """获取特定用户在/app/目录下运行的Java进程的PID和应用名称"""
    cmd = "ps -ef | grep java | grep {user} | grep /app/".format(user=user)
    processes = os.popen(cmd).read().strip().split("\n")
    
    java_processes = []
    for process in processes:
        if process:
            parts = process.split()
            pid = parts[1]
            # 调整正则表达式以匹配应用名称
            app_name_match = re.search(r"/app/([\w-]+)", process)
            if app_name_match:
                java_processes.append((pid, app_name_match.group(1)))
    return java_processes

def get_listening_ports(processes):
    """获取特定进程列表的Java进程监听的所有LISTEN状态的端口"""
    listening_ports = []
    for pid, app_name in processes:
        cmd = "netstat -tnlp | grep LISTEN | grep {pid}/java".format(pid=pid)
        ports = os.popen(cmd).read().strip().split("\n")
        for port in ports:
            if port:
                port_number = port.split()[3].split(':')[-1]
                listening_ports.append((app_name, port_number))
    return listening_ports

def discover(user="appuser"):
    """发现并打印特定用户运行的Java进程的监听端口信息"""
    d = {'data': []}
    java_processes = get_java_processes(user)
    ports = get_listening_ports(java_processes)

    for app_name, port in ports:
        info = {"{#NAME}": app_name, "{#PORT}": port}
        d["data"].append(info)

    print(json.dumps(d, indent=4, ensure_ascii=False))


if __name__ == "__main__":
    discover()

```

#### 重启zabbix-agent

```bash
systemctl restart zabbix-agent
```

#### Server端测试是否能拉取到数据

```bash
[root@zabbix ~]# zabbix_get -s 10.108.27.222 -p 10050 -k port_discovery
{
    "data": [
        {
            "{#PORT}": "9082", 
            "{#NAME}": "product-report"
        }, 
        {
            "{#PORT}": "9527", 
            "{#NAME}": "product-dataway"
        }, 
        {
            "{#PORT}": "9094", 
            "{#NAME}": "product-auth"
        }
    ]
}
```

#### web端上传模板链接到需要监控的主机即可

![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1704768301833-19c4ae71-44e1-45de-9887-217271ae87d2.png#averageHue=%23ecd5a8&clientId=u31ce4426-8278-4&from=paste&height=704&id=ud9fa8ae4&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=115361&status=done&style=none&taskId=u37da4147-12aa-4f1f-b167-8e4a28e9dde&title=&width=1536)

#### 错误总结：

```bash
[root@zabbix ~]# zabbix_get -s 10.108.142.6 -p 10050 -k port_discovery
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
{
    "data": []
}

```

原因：权限问题，zabbix_agentd是zabbix用户启动的，默认不能执行netstat -p 等命令，导致从服务器取到的自动发现脚本为空

#### 解决方法：

```bash
chmod +s /bin/netstat
```

#### 一键脚本：

```bash
#!/bin/bash

# 修改zabbix_agentd.conf配置文件
if echo "UserParameter=port_discovery,python /etc/zabbix/script/port.py" >> /etc/zabbix/zabbix_agentd.conf; then
    echo "Zabbix Agent配置文件更新成功！"
else
    echo "Zabbix Agent配置文件更新失败，请检查权限！"
    exit 1
fi

# 创建自定义脚本目录
if mkdir -p /etc/zabbix/script; then
    echo "自定义脚本目录创建成功！"
else
    echo "自定义脚本目录创建失败，请检查权限！"
    exit 1
fi

# 创建port.py脚本文件
cat <<EOT > /etc/zabbix/script/port.py
#!/usr/bin/python
#coding:utf-8
import os
import json
import re

def get_java_processes(user):
    """获取特定用户在/app/目录下运行的Java进程的PID和应用名称"""
    cmd = "ps -ef | grep java | grep {user} | grep /app/".format(user=user)
    processes = os.popen(cmd).read().strip().split("\n")
    
    java_processes = []
    for process in processes:
        if process:
            parts = process.split()
            pid = parts[1]
            # 调整正则表达式以匹配应用名称
            app_name_match = re.search(r"/app/([\w-]+)", process)
            if app_name_match:
                java_processes.append((pid, app_name_match.group(1)))
    return java_processes

def get_listening_ports(processes):
    """获取特定进程列表的Java进程监听的所有LISTEN状态的端口"""
    listening_ports = []
    for pid, app_name in processes:
        cmd = "netstat -tnlp | grep LISTEN | grep {pid}/java".format(pid=pid)
        ports = os.popen(cmd).read().strip().split("\n")
        for port in ports:
            if port:
                port_number = port.split()[3].split(':')[-1]
                listening_ports.append((app_name, port_number))
    return listening_ports

def discover(user="appuser"):
    """发现并打印特定用户运行的Java进程的监听端口信息"""
    d = {'data': []}
    java_processes = get_java_processes(user)
    ports = get_listening_ports(java_processes)

    for app_name, port in ports:
        info = {"{#NAME}": app_name, "{#PORT}": port}
        d["data"].append(info)

    print(json.dumps(d, indent=4, ensure_ascii=False))


if __name__ == "__main__":
    discover()

EOT

# 授权
if chmod +s /bin/netstat; then
    echo "授权成功！"
else
    echo "授权失败，请检查权限！"
    exit 1
fi

# 重启zabbix-agent服务
if systemctl restart zabbix-agent; then
    echo "Zabbix Agent服务重启成功！"
else
    echo "Zabbix Agent服务重启失败，请检查日志！"
    exit 1
fi
```
