write_files:
  - path: /opt/jfrog/artifactory/var/etc/artifactory/test.xml
    owner: artifactory:artifactory
    permissions: '0644'
    content: |
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <config xmlns="http://artifactory.jfrog.org/xsd/2.1.5" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.jfrog.org/xsd/artifactory-v2_1_5.xsd">
        <offlineMode>false</offlineMode>
        <helpLinksEnabled>true</helpLinksEnabled>
        <fileUploadMaxSizeMb>100</fileUploadMaxSizeMb>
        <revision>2</revision>
        <dateFormat>dd-MM-yy HH:mm:ss z</dateFormat>
        <addons>
            <showAddonsInfo>true</showAddonsInfo>
            <showAddonsInfoCookie>1530683484114</showAddonsInfoCookie>
        </addons>
        <security>
            <anonAccessEnabled>true</anonAccessEnabled>
            <anonAccessToBuildInfosDisabled>false</anonAccessToBuildInfosDisabled>
            <hideUnauthorizedResources>false</hideUnauthorizedResources>
            <passwordSettings>
                <encryptionPolicy>supported</encryptionPolicy>
                <expirationPolicy>
                    <enabled>false</enabled>
                    <passwordMaxAge>564217</passwordMaxAge>
                    <notifyByEmail>true</notifyByEmail>
                </expirationPolicy>
                <resetPolicy>
                    <enabled>true</enabled>
                    <maxAttemptsPerAddress>3</maxAttemptsPerAddress>
                    <timeToBlockInMinutes>600</timeToBlockInMinutes>
                </resetPolicy>
            </passwordSettings>
            <ldapSettings>
                <ldapSetting>
                    <key>${ldapSetting_id}</key>
                    <enabled>true</enabled>
                    <ldapUrl>${ldapSetting_ldapUrl}</ldapUrl>
                    <userDnPattern></userDnPattern>
                    <search>
                        <searchFilter>${ldapSetting_searchFilter}</searchFilter>
                        <searchBase>${ldapSetting_searchBase}</searchBase>
                        <searchSubTree>true</searchSubTree>
                        <managerDn>${ldapSetting_managerDn}</managerDn>
                        <managerPassword>${ldapSetting_managerPassword}</managerPassword>
                    </search>
                    <autoCreateUser>true</autoCreateUser>
                    <emailAttribute>${ldapSetting_emailAttribute}</emailAttribute>
                    <ldapPoisoningProtection>true</ldapPoisoningProtection>
                    <allowUserToAccessProfile>false</allowUserToAccessProfile>
                </ldapSetting>
            </ldapSettings>
            <ldapGroupSettings>
                <ldapGroupSetting>
                    <name>${ldapSetting_id}</name>
                    <groupBaseDn>${ldapGroupSettings_groupBaseDn}</groupBaseDn>
                    <groupNameAttribute>${ldapGroupSettings_groupNameAttribute}</groupNameAttribute>
                    <groupMemberAttribute>${ldapGroupSettings_groupMemberAttribute}</groupMemberAttribute>
                    <subTree>${ldapGroupSettings_subTree}</subTree>
                    <filter>${ldapGroupSettings_filter}</filter>
                    <descriptionAttribute>${ldapGroupSettings_descriptionAttribute}</descriptionAttribute>
                    <strategy>${ldapGroupSettings_strategy}</strategy>
                    <enabledLdap>${ldapSetting_id}</enabledLdap>
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
                <excludeBuilds>false</excludeBuilds>
                <excludeNewRepositories>false</excludeNewRepositories>
                <precalculate>false</precalculate>
            </backup>
            <backup>
                <key>backup-weekly</key>
                <enabled>false</enabled>
                <cronExp>0 0 2 ? * SAT</cronExp>
                <retentionPeriodHours>336</retentionPeriodHours>
                <createArchive>false</createArchive>
                <excludedRepositories/>
                <sendMailOnError>true</sendMailOnError>
                <excludeBuilds>false</excludeBuilds>
                <excludeNewRepositories>false</excludeNewRepositories>
                <precalculate>false</precalculate>
            </backup>
        </backups>
        <indexer>
            <enabled>false</enabled>
            <cronExp>0 23 5 * * ?</cronExp>
        </indexer>
        <localRepositories>
            <localRepository>
                <key>example-repo-local</key>
                <type>generic</type>
                <description>Example artifactory repository</description>
                <includesPattern>**/*</includesPattern>
                <repoLayoutRef>simple-default</repoLayoutRef>
                <dockerApiVersion>V2</dockerApiVersion>
                <forceNugetAuthentication>false</forceNugetAuthentication>
                <blackedOut>false</blackedOut>
                <handleReleases>true</handleReleases>
                <handleSnapshots>true</handleSnapshots>
                <maxUniqueSnapshots>0</maxUniqueSnapshots>
                <maxUniqueTags>0</maxUniqueTags>
                <suppressPomConsistencyChecks>true</suppressPomConsistencyChecks>
                <propertySets>
                    <propertySetRef>artifactory</propertySetRef>
                </propertySets>
                <archiveBrowsingEnabled>false</archiveBrowsingEnabled>
                <snapshotVersionBehavior>unique</snapshotVersionBehavior>
                <localRepoChecksumPolicyType>client-checksums</localRepoChecksumPolicyType>
                <calculateYumMetadata>false</calculateYumMetadata>
                <yumRootDepth>0</yumRootDepth>
                <debianTrivialLayout>false</debianTrivialLayout>
                <enableFileListsIndexing>false</enableFileListsIndexing>
            </localRepository>
        </localRepositories>
        <remoteRepositories/>
        <virtualRepositories/>
        <distributionRepositories/>
        {% if (http_proxy_host is defined) and (http_proxy_port is defined) %}
        <proxies>
            <proxy>
                <key>${http_proxy_host}</key>
                <host>${http_proxy_host}</host>
                <port>${http_proxy_port}</port>
                <defaultProxy>true</defaultProxy>
            </proxy>
        </proxies>
        {% else %}
        <proxies/>
        {% endif %}
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
                <name>gradle-default</name>
                <artifactPathPattern>[org]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]</artifactPathPattern>
                <distinctiveDescriptorPathPattern>true</distinctiveDescriptorPathPattern>
                <descriptorPathPattern>[org]/[module]/ivy-[baseRev](-[fileItegRev]).xml</descriptorPathPattern>
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
                <artifactPathPattern>[orgPath]/[module]/[module]-[baseRev](-[fileItegRev]).tgz</artifactPathPattern>
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
                <name>composer-default</name>
                <artifactPathPattern>[orgPath]/[module]/[module]-[baseRev](-[fileItegRev]).[ext]</artifactPathPattern>
                <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
            </repoLayout>
            <repoLayout>
                <name>conan-default</name>
                <artifactPathPattern>[org]/[module]/[baseRev]/[channel&lt;[^/]+&gt;][remainder&lt;(?:.*)&gt;].[ext]</artifactPathPattern>
                <distinctiveDescriptorPathPattern>false</distinctiveDescriptorPathPattern>
                <folderIntegrationRevisionRegExp>.*</folderIntegrationRevisionRegExp>
                <fileIntegrationRevisionRegExp>.*</fileIntegrationRevisionRegExp>
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
                <artifactPathPattern>[orgPath]/[module]/@v/v[refs].zip</artifactPathPattern>
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
        <bintrayApplications/>
        <sumoLogicConfig>
            <enabled>false</enabled>
        </sumoLogicConfig>
        <releaseBundlesConfig>
            <incompleteCleanupPeriodHours>720</incompleteCleanupPeriodHours>
        </releaseBundlesConfig>
    </config>
