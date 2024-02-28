resource "aws_iam_instance_profile" "instance-profile" {
  name = "Jenkins-instance-profile-east"
  role = aws_iam_role.iam-role.name
}