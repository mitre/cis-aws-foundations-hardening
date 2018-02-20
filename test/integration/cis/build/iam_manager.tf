#======================================================#
#               IAM Manager User
#======================================================#
resource "aws_iam_user" "iam_manager_user" {
  name = "${var.prefix}-iam-manager"
}

#======================================================#
#               IAM Manager Role
#======================================================#
resource "aws_iam_role" "iam_manager_role" {
  name = "${var.prefix}-iam-manager-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.iam_manager_user.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_manager_role_attach" {
  role       = "${aws_iam_role.iam_manager_role.name}"
  policy_arn = "${aws_iam_policy.iam_manager_policy.arn}"

  depends_on = [
    "aws_iam_role.iam_manager_role",
    "aws_iam_policy.iam_manager_policy",
  ]
}

#======================================================#
#               IAM Manager Policy
#======================================================#
data "aws_iam_policy_document" "iam_manager_permissions_policy" {
  statement {
    effect = "Allow"

    actions = [
      "iam:AddUserToGroup",
      "iam:AttachGroupPolicy",
      "iam:DeleteGroupPolicy",
      "iam:DeleteUserPolicy",
      "iam:DetachGroupPolicy",
      "iam:DetachRolePolicy",
      "iam:DetachUserPolicy",
      "iam:PutGroupPolicy",
      "iam:PutUserPolicy",
      "iam:RemoveUserFromGroup",
      "iam:UpdateGroup",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateUser",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetUser",
      "iam:GetUserPolicy",
      "iam:ListEntitiesForPolicy",
      "iam:ListGroupPolicies",
      "iam:ListGroups",
      "iam:ListGroupsForUser",
      "iam:ListPolicies",
      "iam:ListPoliciesGrantingServiceAccess",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "iam:ListAttachedGroupPolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListAttachedUserPolicies",
      "iam:ListRoles",
      "iam:ListUsers",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    effect = "Deny"

    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateGroup",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateUser",
      "iam:DeleteGroup",
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DeleteUser",
      "iam:PutRolePolicy",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "iam_manager_policy" {
  name   = "IAM-MANAGER-POLICY"
  path   = "/"
  policy = "${data.aws_iam_policy_document.iam_manager_permissions_policy.json}"
}
