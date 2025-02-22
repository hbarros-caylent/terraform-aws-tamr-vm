/*
IAM role for the Tamr role for an EC2 instance. This role will have iam policies attached to it through
a secondary module (usually aws-emr-tamr-user-policies`module.
(https://github.com/Datatamer/terraform-emr-tamr-policies))
*/
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tamr_user_iam_role" {
  name                 = var.aws_role_name
  assume_role_policy   = data.aws_iam_policy_document.instance-assume-role-policy.json
  permissions_boundary = var.permissions_boundary
}

resource "aws_iam_instance_profile" "tamr_user_instance_profile" {
  name = var.aws_instance_profile_name
  role = aws_iam_role.tamr_user_iam_role.name
}
