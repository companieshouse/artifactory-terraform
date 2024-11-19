write_files:
  - path: /tmp/amazon-cloudwatch-agent.json
    owner: root:root
    permissions: '0644'
    content: |
      {
        "agent": {
          "metrics_collection_interval": 60,
          "run_as_user": "cwagent"
        },
%{ if cloudwatch_log_collection_enabled ~}
        "logs": {
          "logs_collected": {
            "collect_list": ${cloudwatch_collect_list_json}
          }
        },
%{ endif ~}
        "metrics": {
          "aggregation_dimensions": [
            [
              "AutoScalingGroupName"
            ]
          ],
          "append_dimensions": {
            "AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
            "ImageId": "$${aws:ImageId}",
            "InstanceId": "$${aws:InstanceId}",
            "InstanceType": "$${aws:InstanceType}"
          },
          "namespace": "${cloudwatch_namespace}",
          "metrics_collected": {
            "cpu": {
              "measurement": [
                "cpu_usage_active",
                "cpu_usage_idle",
                "cpu_usage_iowait",
                "cpu_usage_user",
                "cpu_usage_system"
              ],
              "metrics_collection_interval": 60,
              "resources": [
                "*"
              ],
              "totalcpu": true
            },
            "disk": {
              "measurement": [
                "used_percent",
                "inodes_free"
              ],
              "metrics_collection_interval": 60,
              "resources": [
                "/"
              ]
            },
            "mem": {
              "measurement": [
                "mem_used_percent"
              ],
              "metrics_collection_interval": 60
            }
          }
        }
      }

# Loop added to resolve issue causing RPMDB to be locked due to
# automatic SSM agent update on instance boot of AL2023
# https://github.com/amazonlinux/amazon-linux-2023/issues/397
runcmd:
  - until dnf install -y amazon-cloudwatch-agent; do sleep 5s; done
  - amazon-cloudwatch-agent-ctl -a fetch-config -c file:/tmp/amazon-cloudwatch-agent.json -m ec2 -s
