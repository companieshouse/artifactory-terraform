#cloud-config
fqdn: ${instance_fqdn}
runcmd:
  - yum install mysql-connector-java
  - yum install mariadb
  - mysql --version
  - mysql -h ${var.service}db.${data.aws_route53_zone.selected.name} -P ${db_port) -u ${db_username} -p ${db_password} -e "SHOW DATABASES"
  - service artifactory enable
  - service artifactory start
