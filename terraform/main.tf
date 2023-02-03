# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
resource "aws_iam_role" "aft_states" {
  name               = "aft-account-provisioning-customizations-role"
  assume_role_policy = templatefile("${path.module}/iam/states_trust_policy.json", { })
}

resource "aws_iam_role_policy" "aft_states" {
  name = "aft-account-provisioning-customizations-policy"
  role = aws_iam_role.aft_states.id

  policy = templatefile("${path.module}/iam/states_policy.json", {
    account_provisioning_customizations_sfn_arn = aws_sfn_state_machine.aft_account_provisioning_customizations.arn
  })
}

resource "aws_sfn_state_machine" "aft_account_provisioning_customizations" {
  name       = "aft-account-provisioning-customizations"
  role_arn   = aws_iam_role.aft_states.arn
  definition = templatefile("${path.module}/states/customizations.asl.json", {})
}
