write_files:
  - path: /var/opt/jfrog/artifactory/etc/artifactory/binarystore.xml
    permissions: '0644'
    content: |
      <config version="v1">
          <chain template="file-system"/>
          <provider id="file-system" type="file-system">
              <baseDataDir>/var/lib/artifactory/data</baseDataDir>
              <fileStoreDir>filestore</fileStoreDir>
              <tempDir>tmp</tempDir>
          </provider>
      </config>
