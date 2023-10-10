mounts:
  - [ "${efs_mount_ip_address}:/", "/var/lib/artifactory", "nfs4", "nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport", "0", "0" ]

runcmd:
  - sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/ /var/lib/artifactory
