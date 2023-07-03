// ---- Instance Role ----

resource "aws_iam_role" "iam_instance_role" {
  name               = "${var.service}.${var.environment}-iam-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.iam_instance_policy.json
}


// ---- Instance Policy ----
data "aws_iam_policy_document" "iam_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// ---- instance Role Policy Attachments ----

resource "aws_iam_role_policy_attachment" "ssm_service_policy" {
  role       = aws_iam_role.iam_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  # policy_arn = aws_iam_policy.ssm_service.arn
}

 // ----- WILL need below resource & amended document policy to enable the implemetation of KMS
 // -- will need to replace resources to target ch kms arn's for dev, need new variables and secrets created
 // -- Multiple statements will need to be created within the docuemnt & possible dynamic statements being created for some for-each loop checking for ssm access 

# resource "aws_iam_policy" "ssm_service" {
#   name        = "${var.service}.${var.environment}-ssm-service"
#   policy      = data.aws_iam_policy_document.ssm_service.json
# }

# data "aws_iam_policy_document" "ssm_service" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "ssm:GetParameter",
#       "ssm:GetParameters"
#       #"kms:Decrypt",
#       #"ec2:DescribeInstanceStatus",
#       #"ec2:DescribeInstances"
#     ]

#     resources = [
#       # "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
#       "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#     ]
#   }
# }



