output "public_ip" {
  value = aws_instance.example.public_ip
  description = "Public IP for the web server"
}