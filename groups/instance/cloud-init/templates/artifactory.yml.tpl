#cloud-config
fqdn: ${instance_fqdn}
runcmd:
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
