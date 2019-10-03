output "address" {
  value = aws_db_instance.example.address
  description = "Endpoint address used to connect to the database"
}

output "port" {
  value = aws_db_instance.example.port
  description = "The port the database is listening on"
}
