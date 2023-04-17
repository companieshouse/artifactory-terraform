runcmd:
  - systemctl enable artifactory
  - systemctl restart artifactory
  - export ARTIFACTORY_ACCESS_TOKEN="${access_token}"

