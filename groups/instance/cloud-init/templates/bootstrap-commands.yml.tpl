runcmd:
  - systemctl enable artifactory
  - wait
  - systemctl restart artifactory