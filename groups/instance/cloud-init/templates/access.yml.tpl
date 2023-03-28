write_files:
  - path: /opt/jfrog/artifactory/var/etc/system.yaml
    append: true
    content: |
      access:
        ## Skip creating default admin user on startup
        startUpSkipDefaultAdmin: true
