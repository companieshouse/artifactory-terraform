runcmd:
  %{~ for block_device in lvm_block_devices ~}
  - pvresize ${block_device.lvm_physical_volume_device_node}
  - lvresize -l +100%FREE ${block_device.lvm_logical_volume_device_node}
  - ${block_device.filesystem_resize_command}
  %{~ endfor ~}
  - ${artifactory_base_path}/var/etc/artifactory/createXmlConfig.sh
  - ${artifactory_base_path}/var/etc/security/createMasterKeyYaml.sh
  - ${artifactory_base_path}/var/etc/createSystemYaml.sh
  - ${artifactory_base_path}/var/etc/artifactory/createLic.sh
  - ${artifactory_base_path}/var/etc/access/createBootstrap.sh
  - systemctl enable artifactory
  - echo "${efs_filesystem_id}:/ /var/lib/artifactory efs _netdev,tls,accesspoint=${efs_access_point_id} 0 0" >> /etc/fstab
  - mount -a
  - systemctl restart artifactory
  - rm ${artifactory_base_path}/var/etc/access/createBootstrap.sh
  - rm ${artifactory_base_path}/var/etc/artifactory/createLic.sh
  - rm ${artifactory_base_path}/var/etc/createSystemYaml.sh
  - rm ${artifactory_base_path}/var/etc/security/createMasterKeyYaml.sh
  - rm ${artifactory_base_path}/var/etc/artifactory/createXmlConfig.sh
  - systemctl restart artifactory
