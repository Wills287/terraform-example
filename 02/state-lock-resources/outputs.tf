output "state_bucket_arn" {
  value = aws_s3_bucket.state.arn
  description = "The ARN of the S3 bucket used for storing state"
}

output "locks_table_name" {
  value = aws_dynamodb_table.locks.name
  description = "The name of the DynamoDB table used for maintaining locks"
}
