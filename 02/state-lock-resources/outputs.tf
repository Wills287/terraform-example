output "state_bucket_arn" {
  description = "The ARN of the S3 bucket used for storing state"
  value = aws_s3_bucket.state.arn
}

output "locks_table_name" {
  description = "The name of the DynamoDB table used for maintaining locks"
  value = aws_dynamodb_table.locks.name
}
