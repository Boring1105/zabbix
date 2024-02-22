<<<<<<< HEAD
<a name="bzlzS"></a>
### 1、下载一键安装脚本
[zabbix-centos8-pgsql.zip](https://www.yuque.com/attachments/yuque/0/2024/zip/26231376/1708493991472-044e4ac7-90ac-4318-be13-9af8be5194b7.zip?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2024%2Fzip%2F26231376%2F1708493991472-044e4ac7-90ac-4318-be13-9af8be5194b7.zip%22%2C%22name%22%3A%22zabbix-centos8-pgsql.zip%22%2C%22size%22%3A615608437%2C%22ext%22%3A%22zip%22%2C%22source%22%3A%22%22%2C%22status%22%3A%22done%22%2C%22download%22%3Atrue%2C%22taskId%22%3A%22uacf34da8-71ef-4789-b8a9-99acd1589b2%22%2C%22taskType%22%3A%22upload%22%2C%22type%22%3A%22application%2Fzip%22%2C%22__spacing%22%3A%22both%22%2C%22id%22%3A%22ud0287420%22%2C%22margin%22%3A%7B%22top%22%3Atrue%2C%22bottom%22%3Atrue%7D%2C%22card%22%3A%22file%22%7D)
<a name="dIUf7"></a>
### 2、执行命令全自动安装zabbix-server
```bash
=======
1、下载一键安装脚本

2、执行命令全自动安装zabbix-server
>>>>>>> 1a3622ed8ac6d349def147582c782cce96a6fcd5
unzip zabbix-centos8-pgsql.zip

cd zzabbix-centos8-pgsql

sh autosetup.sh install
<<<<<<< HEAD
```
**打开网页输入服务器IP地址访问zabbix**<br />http://IP:8080 或 https://IP:8443<br />用户名: Admin<br />密码: zabbix<br />**打开网页输入服务器IP地址访问grafana**<br />https://IP:3000<br />用户名: admin<br />密码: admin

<a name="mkdYv"></a>
### 3、配置grafana
设置中文<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708494583066-7a81f2d8-61af-4312-ae17-5040714d225c.png#averageHue=%23171a20&clientId=u0bd75c89-a6f9-4&from=paste&height=704&id=u312b0b07&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=107714&status=done&style=none&taskId=u412b43ca-b3a6-4011-9a3e-d8d28df26a4&title=&width=1536)

启用zabbix插件<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708494658179-05c8da0e-bb63-491b-a822-4cf8528eb954.png#averageHue=%231a1d23&clientId=u0bd75c89-a6f9-4&from=paste&height=704&id=u875cd255&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=349695&status=done&style=none&taskId=u59d6cb8c-7895-491d-af9b-1c75602a144&title=&width=1536)<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708495924616-6de0773d-f7b5-4f02-bca9-969e57547002.png#averageHue=%231a1d22&clientId=u0bd75c89-a6f9-4&from=paste&height=704&id=ubfc1b95e&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=350162&status=done&style=none&taskId=u32c9022f-32ed-4583-9f97-aaea43a493f&title=&width=1536)

连接zabbix数据库插件<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708495966875-d205de0f-7886-4279-8ada-e1c9f4fe784b.png#averageHue=%23181a1f&clientId=u0bd75c89-a6f9-4&from=paste&height=704&id=ud65c5e60&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=79753&status=done&style=none&taskId=uca772811-5cda-42c7-b47b-46ff0b3f922&title=&width=1536)<br />新建zabbix数据库连接<br />http://119.45.47.252:8080/api_jsonrpc.php		URL为zabbix访问地址+api_jsonrpc.php<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708496713992-2e655a29-ed26-4a5c-8855-872f00bc0554.png#averageHue=%23181b1f&clientId=u0bd75c89-a6f9-4&from=paste&height=704&id=ucfb28fe4&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=123020&status=done&style=none&taskId=u3a8b5b62-ef8f-4ee5-be03-2b0ecd2c22d&title=&width=1536)<br />zabbix登录的用户名密码<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708496913403-fac29ccd-db0f-4304-9ffa-86dde18009e9.png#averageHue=%23181b1f&clientId=u0bd75c89-a6f9-4&from=paste&height=704&id=ucd549724&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=111842&status=done&style=none&taskId=u1fd633a5-2b8b-42e9-b3ea-18b0699ac0b&title=&width=1536)![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708496920783-b91d2467-db48-4739-bc6d-fcd3d9c10603.png#averageHue=%23181a1f&clientId=u0bd75c89-a6f9-4&from=paste&height=704&id=u80f23582&originHeight=880&originWidth=1920&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=108068&status=done&style=none&taskId=uc7500a69-3184-4b07-b4df-0b9a1f7cbeb&title=&width=1536)
<a name="MqPaS"></a>
### 4、zabbix-server不需要https方式访问，或不需要重定向，注释以下部分即可
![image.png](https://cdn.nlark.com/yuque/0/2024/png/26231376/1708494410235-b0539d9a-e41d-4289-bd2c-a00df0869fce.png#averageHue=%23020000&clientId=u0bd75c89-a6f9-4&from=paste&height=312&id=u54bfc446&originHeight=390&originWidth=937&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=37055&status=done&style=none&taskId=u5bb40cd2-d603-4919-9f89-6c4d0204eb4&title=&width=749.6)
=======
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
>>>>>>> 1a3622ed8ac6d349def147582c782cce96a6fcd5
