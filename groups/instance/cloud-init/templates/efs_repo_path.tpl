write_files:
  - path: ${artifactory_base_path}/var/etc/artifactory/binarystore.xml
    owner: ${artifactory_user}:${artifactory_group}
    permissions: 0640
    content: |
      <config version="v1">
          <chain template="file-system"/>
          <provider id="file-system" type="file-system">
              <baseDataDir>/var/lib/artifactory/data</baseDataDir>
              <fileStoreDir>filestore</fileStoreDir>
              <tempDir>tmp</tempDir>
          </provider>
      </config>
