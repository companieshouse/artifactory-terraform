runcmd:
  - systemctl enable artifactory
  - wait
  - cp /opt/jfrog/artifactory/var/etc/system.yaml /opt/jfrog/artifactory/var/etc/artifactory/system.yaml.old
  - systemctl restart artifactory
