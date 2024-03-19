data "aws_iam_policy_document" "aws_retailmass_mlops_plolicy" {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "sagemaker_domain_execution_role" {
  name               = "aws-test-sagemaker-domain-execution-iam-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.aws_retailmass_mlops_plolicy.json
}

resource "aws_iam_role_policy_attachment" "s3-fullaccess-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker-fullaccess-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker-canvas-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess"
}
resource "aws_iam_role_policy_attachment" "cloudformation-fullaccess-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}
resource "aws_iam_role_policy_attachment" "sagemaker-pipelineintegrations-role-policy-attach" {
  role       = "${aws_iam_role.sagemaker_domain_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerPipelinesIntegrations"
}


resource "aws_sagemaker_domain" "aws_mlops_retailmass_domain" {
  domain_name = "aws-mlops-retailmass-domain"
  auth_mode   = "IAM"
  vpc_id = var.sm_vpc_id
  subnet_ids = var.sm_subnets
  default_user_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
  default_space_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
}

resource "aws_sagemaker_user_profile" "aws-mlops-rpc-build" {
  domain_id         = aws_sagemaker_domain.aws_mlops_retailmass_domain.id
  user_profile_name = "aws-mlops-rpc"
  user_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
}

resource "aws_sagemaker_app" "rpc_sagemaker_pipeline" {
  domain_id         = aws_sagemaker_domain.aws_mlops_retailmass_domain.id
  user_profile_name = aws_sagemaker_user_profile.aws-mlops-rpc-build.user_profile_name
  app_name          = "default"
  app_type          = "JupyterServer"
}