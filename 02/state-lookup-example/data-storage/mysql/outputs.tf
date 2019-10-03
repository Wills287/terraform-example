output "address" {
  description = "Endpoint address used to connect to the database"
  value = aws_db_instance.example.address
}

output "port" {
  description = "The port the database is listening on"
  value = aws_db_instance.example.port
}
