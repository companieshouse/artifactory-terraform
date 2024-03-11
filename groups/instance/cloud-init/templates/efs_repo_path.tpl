write_files:
  - path: /var/opt/jfrog/artifactory/etc/artifactory/binarystore.xml
    permissions: '0644'
    content: |
      <config version="v1">
          <chain template="file-system"/>
          <provider id="file-system" type="file-system">
              <baseDataDir>/var/opt/jfrog/artifactory/data/artifactory</baseDataDir>
              <fileStoreDir>/var/lib/artifactory/filestore</fileStoreDir>
              <tempDir>/var/lib/artifactory/tmp</tempDir>
          </provider>
      </config>
