#cloud-config
fqdn: ${instance_fqdn}
runcmd:
  - wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-8.0.31.zip
  - yum install unzip -y
  - yum install mariadb -y
  - unzip mysql-connector-j-8.0.31.zip
  - cp mysql-connector-j-8.0.31/mysql-connector-j-8.0.31.jar ~/artifactory/var/bootstrap/artifactory/tomcat/lib
  - mysql --version
  - mysql -h ${db_fqdn} -P ${db_port} -u ${db_username} -p ${db_password} -e "CREATE DATABASE artdb CHARACTER SET utf8 COLLATE utf8_bin;"
  - mysql -h ${db_fqdn} -P ${db_port} -u ${db_username} -p ${db_password} -e "CREATE USER '${db_username}'@'%' IDENTIFIED BY '${db_password}';"
  - mysql -h ${db_fqdn} -P ${db_port} -u ${db_username} -p ${db_password} -e "GRANT ALL on artdb.* TO '${db_username}'@'%';"
  - mysql -h ${db_fqdn} -P ${db_port} -u ${db_username} -p ${db_password} -e "FLUSH PRIVILEGES;"
  - mysql -h ${db_fqdn} -P ${db_port} -u ${db_username} -p ${db_password} -e "SHOW DATABASES;"
  - service artifactory enable
  - service artifactory start
write-files:
  - path: ~/artifactory/var/etc
    content: |
      shared:
        database:
          type: mysql
          driver: com.mysql.jdbc.Driver
          url: jdbc:mysql://${db_fqdn}/artdb?characterEncoding=UTF-8&elideSetAutoCommits=true&useSSL=false
          username: ${db_username}
          password: ${db_password}
