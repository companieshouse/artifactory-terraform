write_files:

  - path: /opt/jfrog/artifactory/var/etc/security/createMasterKeyYaml.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND_MASTERKEY=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${db_masterkey_param_name})    
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/security/master.key
      $${AWSCLI_COMMAND_MASTERKEY}
      EOF

  - path: /opt/jfrog/artifactory/var/etc/createSystemYaml.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND_USERNAME=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${db_username_param_name})
      AWSCLI_COMMAND_PASSWORD=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${db_password_param_name})      
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/system.yaml
      ## @formatter:off
      ## ARTIFACTORY SYSTEM CONFIGURATION FILE 
      configVersion: 1
      shared:
          security:
              masterKeyFile: "/opt/jfrog/artifactory/var/etc/security/master.key"
          node:
          database:
              type: postgresql
              driver: org.postgresql.Driver
              url: "jdbc:postgresql://${db_fqdn}/${service}"
              username: $${AWSCLI_COMMAND_USERNAME}
              password: $${AWSCLI_COMMAND_PASSWORD}
          script:
              serviceStartTimeout: 120
      EOF

  - path: /opt/jfrog/artifactory/var/etc/artifactory/createXmlConfig.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND_LDAPMANAGERDN=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${ldap_setting_managerdn_param_name})
      AWSCLI_COMMAND_LDAPMANAGERPW=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${ldap_setting_manager_password_param_name})
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <config xmlns="http://artifactory.jfrog.org/xsd/3.1.32" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.jfrog.org/xsd/artifactory-v3_1_32.xsd">
          <offlineMode>false</offlineMode>
          <archiveIndexEnabled>true</archiveIndexEnabled>
          <helpLinksEnabled>true</helpLinksEnabled>
          <fileUploadMaxSizeMb>100</fileUploadMaxSizeMb>
          <revision>2</revision>
          <dateFormat>dd-MM-yy HH:mm:ss z</dateFormat>
          <addons>
              <showAddonsInfo>true</showAddonsInfo>
              <showAddonsInfoCookie>1681908647859</showAddonsInfoCookie>
          </addons>
          <security>
              <anonAccessEnabled>false</anonAccessEnabled>
              <hideUnauthorizedResources>false</hideUnauthorizedResources>
              <passwordSettings>
                  <encryptionPolicy>supported</encryptionPolicy>
                  <expirationPolicy>
                      <enabled>false</enabled>
                      <passwordMaxAge>60</passwordMaxAge>
                      <notifyByEmail>true</notifyByEmail>
                  </expirationPolicy>
                  <resetPolicy>
                      <enabled>true</enabled>
                      <maxAttemptsPerAddress>3</maxAttemptsPerAddress>
                      <timeToBlockInMinutes>60</timeToBlockInMinutes>
                  </resetPolicy>
              </passwordSettings>
              <ldapSettings>
                  <ldapSetting>
                      <key>${ldap_setting_key}</key>
                      <enabled>true</enabled>
                      <ldapUrl>${ldap_setting_ldap_url}</ldapUrl>
                      <userDnPattern></userDnPattern>
                      <search>
                          <searchFilter>${ldap_setting_search_filter}</searchFilter>
                          <searchBase>${ldap_setting_search_base}</searchBase>
                          <searchSubTree>${ldap_setting_search_subtree}</searchSubTree>
                          <managerDn>$${ldap_setting_managerdn_param_name}</managerDn>
                          <managerPassword>$${ldap_setting_manager_password_param_name}</managerPassword>
                      </search>
                          <autoCreateUser>true</autoCreateUser>
                          <emailAttribute>${ldap_setting_email_attribute}</emailAttribute>
                          <ldapPoisoningProtection>true</ldapPoisoningProtection>
                          <allowUserToAccessProfile>${ldap_setting_allow_user_to_access_profile}</allowUserToAccessProfile>
                          <pagingSupportEnabled>true</pagingSupportEnabled>
                  </ldapSetting>
              </ldapSettings>
              <ldapGroupSettings>
                  <ldapGroupSetting>
                      <name>${ldap_setting_key}</name>
                      <groupBaseDn>${ldap_group_settings_group_basedn}</groupBaseDn>
                      <groupNameAttribute>${ldap_group_settings_group_name_attribute}</groupNameAttribute>
                      <groupMemberAttribute>${ldap_group_settings_group_member_attribute}</groupMemberAttribute>
                      <subTree>${ldap_group_settings_subtree}</subTree>
                      <filter>${ldap_group_settings_filter}</filter>
                      <descriptionAttribute>${ldap_group_settings_description_attribute}</descriptionAttribute>
                      <strategy>${ldap_group_settings_strategy}</strategy>
                      <enabledLdap>${ldap_setting_key}</enabledLdap>
                      <forceAttributeSearch>false</forceAttributeSearch>
                  </ldapGroupSetting>
              </ldapGroupSettings>
              <userLockPolicy>
                  <enabled>false</enabled>
                  <loginAttempts>5</loginAttempts>
              </userLockPolicy>
              <accessClientSettings>
                  <adminToken>${artifactory_access_token}</adminToken>
                  <userTokenMaxExpiresInMinutes>60</userTokenMaxExpiresInMinutes>
              </accessClientSettings>
              <buildGlobalBasicReadAllowed>false</buildGlobalBasicReadAllowed>
              <buildGlobalBasicReadForAnonymous>false</buildGlobalBasicReadForAnonymous>
              <basicAuthEnabled>true</basicAuthEnabled>
          </security>
          <backups>
              <backup>
                  <key>backup-daily</key>
                  <enabled>true</enabled>
                  <cronExp>0 0 2 ? * MON-FRI</cronExp>
                  <retentionPeriodHours>0</retentionPeriodHours>
                  <createArchive>false</createArchive>
                  <excludedRepositories/>
                  <sendMailOnError>true</sendMailOnError>
                  <excludeNewRepositories>false</excludeNewRepositories>
                  <precalculate>false</precalculate>
                  <exportMissionControl>false</exportMissionControl>
              </backup>
              <backup>
                  <key>backup-weekly</key>
                  <enabled>false</enabled>
                  <cronExp>0 0 2 ? * SAT</cronExp>
                  <retentionPeriodHours>336</retentionPeriodHours>
                  <createArchive>false</createArchive>
                  <excludedRepositories/>
                  <sendMailOnError>true</sendMailOnError>
                  <excludeNewRepositories>false</excludeNewRepositories>
                  <precalculate>false</precalculate>
                  <exportMissionControl>false</exportMissionControl>
              </backup>
          </backups>
          <indexer>
              <enabled>false</enabled>
              <cronExp>0 23 5 * * ?</cronExp>
          </indexer>
          <localRepositories>
              <localRepository>
                  <key>artifactory-build-info</key>
                  <type>buildinfo</type>
                  <description>Build Info repository</description>
                  <includesPattern>**/*</includesPattern>
                  <repoLayoutRef>simple-default</repoLayoutRef>
                  <dockerApiVersion>V2</dockerApiVersion>
                  <forceNugetAuthentication>false</forceNugetAuthentication>
                  <forceConanAuthentication>false</forceConanAuthentication>
                  <ddebSupported>false</ddebSupported>
                  <signedUrlTtl>90</signedUrlTtl>
                  <blackedOut>false</blackedOut>
                  <handleReleases>true</handleReleases>
                  <handleSnapshots>true</handleSnapshots>
                  <maxUniqueSnapshots>0</maxUniqueSnapshots>
                  <maxUniqueTags>0</maxUniqueTags>
                  <blockPushingSchema1>true</blockPushingSchema1>
                  <suppressPomConsistencyChecks>true</suppressPomConsistencyChecks>
                  <propertySets>
                      <propertySetRef>artifactory</propertySetRef>
                  </propertySets>
                  <archiveBrowsingEnabled>false</archiveBrowsingEnabled>
                  <priorityResolution>false</priorityResolution>
                  <snapshotVersionBehavior>unique</snapshotVersionBehavior>
                  <localRepoChecksumPolicyType>client-checksums</localRepoChecksumPolicyType>
                  <calculateYumMetadata>false</calculateYumMetadata>
                  <yumRootDepth>0</yumRootDepth>
                  <debianTrivialLayout>false</debianTrivialLayout>
                  <enableFileListsIndexing>false</enableFileListsIndexing>
                  <dockerTagRetention>1</dockerTagRetention>
                  <enableComposerV1Indexing>false</enableComposerV1Indexing>
                  <terraformType>MODULE</terraformType>
              </localRepository>
          </localRepositories>
          <remoteRepositories/>
          <virtualRepositories/>
          <federatedRepositories/>
          <releaseBundlesRepositories/>
          <proxies/>
          <reverseProxies/>
          <propertySets>
              <propertySet>
                  <name>artifactory</name>
                  <visible>false</visible>
                  <properties>
                      <property>
                          <name>licenses</name>
                          <closedPredefinedValues>true</closedPredefinedValues>
                          <multipleChoice>true</multipleChoice>
                          <predefinedValues>
                              <predefinedValue>
                                  <value>AFL-3.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>AGPL-V3</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>APL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Apache-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Apache-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Apache-1.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>APSL-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Artistic-License-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Attribution</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>BSL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CA-TOSL-1.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CDDL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CDDL-1.0.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CDDL-1.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Codehaus</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CCAG-2.5</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CPAL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CUAOFFICE-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Day</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Day-Addendum</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Bouncy-Castle</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>EUDATAGRID</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Enovi</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>CPL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>LGPL-2.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>LGPL-3.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Historical</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>HSQLDB</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>IBMPL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>IPAFont-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>ISC</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Lucent-1.02</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>MirOS</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>MS-PL</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>MS-RL</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>JA-SIG</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>BSD</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>MIT</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>JSON</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Motosoto-0.9.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Eclipse-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>ECL2</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Eiffel-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>JTidy</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>JTA-Specification-1.0.1B</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Entessa-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>EUPL-1.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Fair</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Frameworx-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>GPL-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>GPL-2.0+CE</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>GPL-3.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Mozilla-1.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Multics</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>NASA-1.3</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>NTP</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>NAUMEN</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Nethack</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Nokia-1.0a</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>NOSL-3.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>OCLC-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Openfont-1.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Opengroup</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>OpenSymphony</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>OSL-3.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>PHP-3.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>PostgreSQL</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Public Domain</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Public Domain - SUN</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>PythonPL</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>PythonSoftFoundation</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>QTPL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Real-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>RPL-1.5</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>RicohPL</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>SimPL-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Sleepycat</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>SUNPublic-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Sybase-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>TMate</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>UoI-NCSA</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>IU-Extreme-1.1.1</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>VovidaPL-1.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>W3C</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>wxWindows</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Xnet</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>ZPL-2.0</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>ZLIB</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>TPL</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                              <predefinedValue>
                                  <value>Not Searched</value>
                                  <defaultValue>false</defaultValue>
                              </predefinedValue>
                          </predefinedValues>
                      </property>
                  </properties>
              </propertySet>
          </propertySets>
          <systemProperties/>
          <repoLayouts>
              <repoLayout>
                  <name>maven-2-default</name>
                  <artifactPathPattern>[orgPath]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>true</distinctiveDescriptorPathPattern>
                  <descriptorPathPattern>[orgPath]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).pom</descriptorPathPattern>
                  <folderIntegrationRevisionRegExp>SNAPSHOT</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>SNAPSHOT|(?:(?:[0-9]{8}.[0-9]{6})-(?:[0-9]+))</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>ivy-default</name>
                  <artifactPathPattern>[org]/[module]/[baseRev](-[folderItegRev])/[type]s/[module](-[classifier])-[baseRev](-[fileItegRev]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>true</distinctiveDescriptorPathPattern>
                  <descriptorPathPattern>[org]/[module]/[baseRev](-[folderItegRev])/[type]s/ivy-[baseRev](-[fileItegRev]).xml</descriptorPathPattern>
                  <folderIntegrationRevisionRegExp>\d{14}</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>\d{14}</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>maven-1-default</name>
                  <artifactPathPattern>[org]/[type]s/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>true</distinctiveDescriptorPathPattern>
                  <descriptorPathPattern>[org]/[type]s/[module]-[baseRev](-[fileItegRev]).pom</descriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.+</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.+</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>nuget-default</name>
                  <artifactPathPattern>[orgPath]/[module]/[module].[baseRev](-[fileItegRev]).nupkg</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>npm-default</name>
                  <artifactPathPattern>[orgPath]/-/[module]-[baseRev](-[fileItegRev]).tgz</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>bower-default</name>
                  <artifactPathPattern>[orgPath]/[module]/[module]-[baseRev](-[fileItegRev]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>vcs-default</name>
                  <artifactPathPattern>[orgPath]/[module]/[refs&lt;tags|branches&gt;]/[baseRev]/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>[a-zA-Z0-9]{40}</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>sbt-default</name>
                  <artifactPathPattern>[org]/[module]/(scala_[scalaVersion&lt;.+&gt;])/(sbt_[sbtVersion&lt;.+&gt;])/[baseRev]/[type]s/[module](-[classifier]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>true</distinctiveDescriptorPathPattern>
                  <descriptorPathPattern>[org]/[module]/(scala_[scalaVersion&lt;.+&gt;])/(sbt_[sbtVersion&lt;.+&gt;])/[baseRev]/[type]s/ivy.xml</descriptorPathPattern>
                  <folderIntegrationRevisionRegExp>\d{14}</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>\d{14}</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>simple-default</name>
                  <artifactPathPattern>[orgPath]/[module]/[module]-[baseRev].[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>cargo-default</name>
                  <artifactPathPattern>crates/[module]/[module]-[baseRev].[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>composer-default</name>
                  <artifactPathPattern>[orgPath]/[module]/[module]-[baseRev](-[fileItegRev]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>conan-default</name>
                  <artifactPathPattern>[org]/[module]/[baseRev]/[channel&lt;[^/]+&gt;]/[folderItegRev]/(package/[package_id&lt;[^/]+&gt;]/[fileItegRev]/)[remainder&lt;(?:.+)&gt;]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>[^/]+</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>[^/]+</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>puppet-default</name>
                  <artifactPathPattern>[orgPath]/[module]/[orgPath]-[module]-[baseRev].tar.gz</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>go-default</name>
                  <artifactPathPattern>[orgPath]/[module]/@v/v[baseRev](-[fileItegRev]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>build-default</name>
                  <artifactPathPattern>[orgPath]/[module](-[fileItegRev]).[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>terraform-module-default</name>
                  <artifactPathPattern>[namespace]/[module-name]/[provider]/[version].[ext]</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>terraform-provider-default</name>
                  <artifactPathPattern>
                      [namespace]/[provider-name]/[version]/terraform-provider-[provider-name]_[version]_[os]_[arch].[ext]
                  </artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
              <repoLayout>
                  <name>swift-default</name>
                  <artifactPathPattern>[scope]/[name]/[name]-[version].zip</artifactPathPattern>
                  <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                  <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                  <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
              </repoLayout>
          </repoLayouts>
          <remoteReplications/>
          <localReplications/>
          <gcConfig>
              <cronExp>0 0 /4 * * ?</cronExp>
          </gcConfig>
          <cleanupConfig>
              <cronExp>0 12 5 * * ?</cronExp>
          </cleanupConfig>
          <virtualCacheCleanupConfig>
              <cronExp>0 12 0 * * ?</cronExp>
          </virtualCacheCleanupConfig>
          <folderDownloadConfig>
              <enabled>false</enabled>
              <enabledForAnonymous>false</enabledForAnonymous>
              <maxDownloadSizeMb>1024</maxDownloadSizeMb>
              <maxFiles>5000</maxFiles>
              <maxConcurrentRequests>10</maxConcurrentRequests>
              <enabledEmptyDirectories>false</enabledEmptyDirectories>
          </folderDownloadConfig>
          <trashcanConfig>
              <enabled>true</enabled>
              <allowPermDeletes>false</allowPermDeletes>
              <retentionPeriodDays>14</retentionPeriodDays>
          </trashcanConfig>
          <replicationsConfig>
              <blockPushReplications>false</blockPushReplications>
              <blockPullReplications>false</blockPullReplications>
          </replicationsConfig>
          <sumoLogicConfig>
              <enabled>false</enabled>
          </sumoLogicConfig>
          <releaseBundlesConfig>
              <incompleteCleanupPeriodHours>720</incompleteCleanupPeriodHours>
          </releaseBundlesConfig>
          <signedUrlConfig>
              <maxValidForSeconds>31536000</maxValidForSeconds>
          </signedUrlConfig>
          <downloadRedirectConfig>
              <fileMinimumSize>1</fileMinimumSize>
          </downloadRedirectConfig>
          <keyPairs/>
          <retentionSettings>
              <retentionPolicies/>
          </retentionSettings>
          <authentication>
              <tokens/>
          </authentication>
      </config>
      EOF

  - path: /opt/jfrog/artifactory/var/etc/artifactory/createLic.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${artifactory_license_param_name})
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/artifactory/artifactory.lic
      $${AWSCLI_COMMAND}
      EOF

  - path: /opt/jfrog/artifactory/var/etc/access/createBootstrap.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${admin_password_param_name})
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/access/bootstrap.creds
      admin@*=$${AWSCLI_COMMAND}
      EOF

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

runcmd:
  - /opt/jfrog/artifactory/var/etc/artifactory/createXmlConfig.sh
  - sudo chmod 0644 /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml
  - sudo chown artifactory:artifactory /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.import.xml
  - rm /opt/jfrog/artifactory/var/etc/security/master.key
  - /opt/jfrog/artifactory/var/etc/security/createMasterKeyYaml.sh
  - sudo chmod 0644 /opt/jfrog/artifactory/var/etc/security/master.key
  - sudo chown artifactory:artifactory /opt/jfrog/artifactory/var/etc/security/master.key
  - rm /opt/jfrog/artifactory/var/etc/system.yaml  
  - /opt/jfrog/artifactory/var/etc/createSystemYaml.sh
  - sudo chmod 0644 /opt/jfrog/artifactory/var/etc/system.yaml
  - sudo chown artifactory:artifactory /opt/jfrog/artifactory/var/etc/system.yaml
  - /opt/jfrog/artifactory/var/etc/artifactory/createLic.sh
  - sudo chmod 0644 /opt/jfrog/artifactory/var/etc/artifactory/artifactory.lic
  - sudo chown artifactory:artifactory /opt/jfrog/artifactory/var/etc/artifactory/artifactory.lic
  - /opt/jfrog/artifactory/var/etc/access/createBootstrap.sh
  - sudo chmod 0600 /opt/jfrog/artifactory/var/etc/access/bootstrap.creds
  - sudo chown artifactory:artifactory /opt/jfrog/artifactory/var/etc/access/bootstrap.creds
  - systemctl enable artifactory
  - sudo echo "${efs_filesystem_id} /var/lib/artifactory efs _netdev,tls,accesspoint=${efs_access_point_id} 0 0" >> /etc/fstab
  - sudo mount -a
  - sudo chown artifactory:artifactory /var/opt/jfrog/artifactory/etc/artifactory/binarystore.xml
  - systemctl restart artifactory
  - rm /opt/jfrog/artifactory/var/etc/access/createBootstrap.sh
  - rm /opt/jfrog/artifactory/var/etc/artifactory/createLic.sh
  - rm /opt/jfrog/artifactory/var/etc/createSystemYaml.sh
  - rm /opt/jfrog/artifactory/var/etc/security/createMasterKeyYaml.sh
  - rm /opt/jfrog/artifactory/var/etc/artifactory/createXmlConfig.sh
