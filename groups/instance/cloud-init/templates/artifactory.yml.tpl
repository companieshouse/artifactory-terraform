#cloud-config
fqdn: ${instance_fqdn}
runcmd:
  - wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-8.0.31.zip
  - yum install unzip -y
  - yum install mariadb -y
  - unzip mysql-connector-j-8.0.31.zip
  - cp mysql-connector-j-8.0.31/mysql-connector-j-8.0.31.jar /opt/jfrog/artifactory/var/bootstrap/artifactory/tomcat/lib
  - mysql --version
  - service artifactory enable
  - service artifactory start
write-files:
  - path: /opt/jfrog/artifactory/var/etc
    content: |
      shared:
        database:
          type: mysql
          driver: com.mysql.jdbc.Driver
          url: jdbc:mysql://${db_fqdn}/${db_name}?characterEncoding=UTF-8&elideSetAutoCommits=true&useSSL=false
          username: ${db_username}
          password: ${db_password}
