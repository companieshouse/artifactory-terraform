write_files:
  - path: /opt/jfrog/artifactory/var/etc/system.yaml
    content: |
      shared:
        database:
          type: postgresql
          driver: org.postgresql.Driver
          url: jdbc:postgresql://${db_fqdn}/artifactory
          username: ${db_username}
          password: ${db_password}
