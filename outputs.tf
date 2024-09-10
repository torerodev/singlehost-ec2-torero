output "instance-id" {
  description = "The EC2 instance ID"
  value       = "${aws_instance.instance_main.id}"
}

output "instance-public-dns" {
  description = "The EC2 instance public DNS"
  value       = "${aws_instance.instance_main.public_dns}"
}

output "instructions" {
  value = <<EOT
  
  
  You can login here immediately:
  ssh -i YOUR_KEY.pem ec2-user@${aws_instance.instance_main.public_dns}
  
  Wait a minute or two, then you'll need to get your password for the torero server, so run:
  
  ssh -i YOUR_KEY.pem ec2-user@${aws_instance.instance_main.public_dns} "cat /var/log/cloud-init-output.log"

  You should get an output like:
  ===================
  CREATED TEMPORARY ADMIN

  And a username/password for admin will follow.
  
  EOT
}
