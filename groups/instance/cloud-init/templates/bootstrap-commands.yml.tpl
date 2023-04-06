runcmd:
  - systemctl enable artifactory
  - systemctl start artifactory
  - export ARTIFACTORY_ACCESS_TOKEN="${access_token}"

