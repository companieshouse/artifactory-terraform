write_files:
  - path: /opt/jfrog/artifactory/var/etc/artifactory/test.txt
    owner: artifactory:artifactory
    permissions: '0644'
    content: |
      test
      ${artifactory_access_token}