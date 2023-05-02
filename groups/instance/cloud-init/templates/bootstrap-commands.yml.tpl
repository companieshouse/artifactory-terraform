runcmd:
  - systemctl enable artifactory
  - wait
  - cp /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml.original
  - wait
  - systemctl restart artifactory
