provider "aws" {
  region     = "${var.aws-region}"
  #profile    = var.aws-profile != "" ? var.aws-profile : null
  access_key = var.aws-profile != "" ? null : var.aws-access-key
  secret_key = var.aws-profile != "" ? null : var.aws-secret-key
}

# Use this to get unique names for stuff
resource "random_id" "id" {
	  byte_length = 4
}

#ssh key stuff for ansible to use once deployed
resource "tls_private_key" "sshkey" {
   algorithm = "ED25519"
 }

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-ssh-key-${random_id.id.hex}"
  public_key = tls_private_key.sshkey.public_key_openssh
}


resource "aws_instance" "instance_main" {
  ami                         = "${var.instance-ami-aws2023}"
  instance_type               = "${var.instance-type-t2micro}"
  iam_instance_profile        = data.aws_iam_instance_profile.instance_profile.name
  key_name                    = "${var.instance-key-name != "" ? var.instance-key-name : ""}"
  associate_public_ip_address = "${var.instance-associate-public-ip}"
  # Not currently using the user_data to fill in the ssh key, but it's here for reference
  user_data                   = templatefile("${var.user-data-script}", 
                                  {
                                    extra_key = aws_key_pair.deployer.public_key,
                                    extra_key_priv = tls_private_key.sshkey.private_key_openssh,
                                  }
                                  ) 
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  subnet_id                   = "${aws_subnet.subnet.id}"
  tags = {
    Name = "${random_id.id.hex}-${var.instance-tag-name}"
  }
}


resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr-block}"
  enable_dns_hostnames = true

  tags = {
    Name = "${random_id.id.hex}-${var.vpc-tag-name}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${random_id.id.hex}-${var.ig-tag-name}"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.subnet-cidr-block}"

  tags = {
    Name = "${random_id.id.hex}-${var.subnet-tag-name}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_security_group" "sg" {
  name   = "${var.sg-tag-name}"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    to_port     = "22"
  }
  
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "50051"
    to_port     = "50051"
  }
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    to_port     = "0"
  }

  tags = {
    Name = "${random_id.id.hex}-${var.sg-tag-name}"
  }
}
