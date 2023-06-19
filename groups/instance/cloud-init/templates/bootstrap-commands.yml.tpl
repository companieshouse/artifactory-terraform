runcmd:
  - cat <<EOF > /opt/jfrog/artifactory/var/etc/artifactory/test.txt
    ${artifactory_license}
    EOF
  - wait  
  - systemctl enable artifactory
  - systemctl restart artifactory