runcmd:
  - systemctl enable artifactory
  - wait
  - cp /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml.old
  - wait
  - mv /opt/jfrog/artifactory/var/etc/system.yaml.new /opt/jfrog/artifactory/var/etc/system.yaml.txt
  - wait
  - systemctl restart artifactory
