runcmd:
  - systemctl enable artifactory
  - systemctl restart artifactory
  - wait
  - mv /opt/jfrog/artifactory/var/etc/artifactory.config.import.xml /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml
  - systemctl restart artifactory
