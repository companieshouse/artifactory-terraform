runcmd:
  - systemctl enable artifactory
  - wait
  - cp /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml.old
  - wait
  - cp /opt/jfrog/artifactory/var/etc/artifactory/tmp.txt /opt/jfrog/artifactory/var/etc/tmp.txt
  - wait
  - systemctl restart artifactory
