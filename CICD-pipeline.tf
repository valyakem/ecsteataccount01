# # CODECOMMIT REPOSITORY
# resource "random_string" "rand" {
#   length  = 24
#   special = false
#   upper   = false
# }

# locals {
#   namespace = substr(join("-", [var.snsname, random_string.rand.result]), 0, 24)
#   projects  = ["plan", "apply"]
# }

# resource "aws_sns_topic" "codepipeline" {
#   name = "${local.namespace}-pipeline-topic"
# }

# resource "aws_codecommit_repository" "repo" {
#   repository_name = var.repo_name
# }

# # CODEBUILD#
# resource "aws_codebuild_project" "repo-project" {
#   name         = "${var.build_project}"
#   service_role = "${aws_iam_role.codebuild-role.arn}"

#   artifacts {
#     type = "NO_ARTIFACTS"
#   }

#   source {
#     type     = "CODECOMMIT"
#     location = "${aws_codecommit_repository.repo.clone_url_http}"
#   }

#   environment {
#     compute_type    = "BUILD_GENERAL1_SMALL"
#     image           = "aws/codebuild/standard:5.0"
#     type            = "LINUX_CONTAINER"
#     privileged_mode = true
#   }
# }

# # S3 BUCKET FOR ARTIFACTORY_STORE
# resource "aws_s3_bucket" "bucket-artifact" {
#   bucket = "eroz-artifactory-bucket"
#   acl    = null
# }

# # CODEPIPELINE
# resource "aws_codepipeline" "pipeline" {
#   name     = "pipeline"
#   role_arn = "${data.aws_iam_role.pipeline_role.arn}"

#   artifact_store {
#     location = "${aws_s3_bucket.bucket-artifact.bucket}"
#     type     = "S3"
#   }
#   # SOURCE
#   stage {
#     name = "Source"
#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = "CodeCommit"
#       version          = "1"
#       output_artifacts = ["source_output"]

#       configuration = {
#         RepositoryName = "${var.repo_name}"
#         BranchName     = "${var.branch_name}"
#       }
#     }
#   }
#   # BUILD
#   stage {
#     name = "Build"
#     action {
#       name             = "Build"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       version          = "1"
#       input_artifacts  = ["source_output"]
#       output_artifacts = ["build_output"]

#       configuration = {
#         ProjectName = "${var.build_project}"
#       }
#     }
#   }

#  dynamic "stage" {
#     for_each = ! var.auto_apply ? [1] : []
#     content {
#       name = "Approval"

#       action {
#         name     = "Approval"
#         category = "Approval"
#         owner    = "AWS"
#         provider = "Manual"
#         version  = "1"

#         configuration = {
#           CustomData      = "Please review output of plan and approve"
#           NotificationArn = aws_sns_topic.codepipeline.arn
#         }
#       }
#     }
#   }

#   # DEPLOY
#   stage {
#     name = "Deploy"
#     action {
#       name            = "Deploy"
#       category        = "Deploy"
#       owner           = "AWS"
#       provider        = "ECS"
#       version         = "1"
#       input_artifacts = ["build_output"]

#       configuration = {
#         ClusterName = "clusterDev"
#         ServiceName = "golang-Service"
#         FileName    = "imagedefinitions.json"
#       }
#     }
#   }
# }