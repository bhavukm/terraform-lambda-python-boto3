resource "aws_iam_role" "lambda_role" {
  name="${var.project_name}-lambda-role"
  assume_role_policy=jsonencode({
    Version="2012-10-17",
    Statement=[{Effect="Allow",Principal={Service="lambda.amazonaws.com"},Action="sts:AssumeRole"}]
  })
}
resource "aws_iam_role_policy" "lambda_policy" {
  role=aws_iam_role.lambda_role.id
  policy=jsonencode({
    Version="2012-10-17",
    Statement=[
      {Effect="Allow",Action=["ec2:StartInstances","ec2:StopInstances","ec2:DescribeInstances"],Resource="*"},
      {Effect="Allow",Action=["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],Resource="*"}
    ]
  })
}
resource "aws_lambda_function" "scheduler"{
  function_name="${var.project_name}-scheduler"
  role=aws_iam_role.lambda_role.arn
  handler="lambda_function.lambda_handler"
  runtime="python3.12"
  filename=data.archive_file.lambda_zip.output_path
  source_code_hash=data.archive_file.lambda_zip.output_base64sha256
  environment { variables={ INSTANCE_IDS=join(",",var.instance_ids)}}
}
resource "aws_cloudwatch_event_rule" "stop"{
  name="${var.project_name}-stop"
  schedule_expression="cron(10 17 17 7 ? 2026)"
}
resource "aws_cloudwatch_event_rule" "start"{
  name="${var.project_name}-start"
  schedule_expression="cron(13 17 17 7 ? 2026)"
}
resource "aws_cloudwatch_event_target" "stop"{
  rule=aws_cloudwatch_event_rule.stop.name
  arn=aws_lambda_function.scheduler.arn
  input=jsonencode({action="stop"})
}
resource "aws_cloudwatch_event_target" "start"{
  rule=aws_cloudwatch_event_rule.start.name
  arn=aws_lambda_function.scheduler.arn
  input=jsonencode({action="start"})
}
resource "aws_lambda_permission" "stop"{
  statement_id="AllowStop"
  action="lambda:InvokeFunction"
  function_name=aws_lambda_function.scheduler.function_name
  principal="events.amazonaws.com"
  source_arn=aws_cloudwatch_event_rule.stop.arn
}
resource "aws_lambda_permission" "start"{
  statement_id="AllowStart"
  action="lambda:InvokeFunction"
  function_name=aws_lambda_function.scheduler.function_name
  principal="events.amazonaws.com"
  source_arn=aws_cloudwatch_event_rule.start.arn
}
