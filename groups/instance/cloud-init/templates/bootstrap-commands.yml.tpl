runcmd:
  - wait
  - cp /opt/jfrog/artifactory/var/etc/artifactory/test.txt /opt/jfrog/artifactory/var/etc/artifactory/test2.txt
  - wait
  - systemctl enable artifactory
  - wait
  - systemctl restart artifactory
  - wait