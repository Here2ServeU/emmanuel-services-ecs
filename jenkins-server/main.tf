# Generate an SSH Key Pair
resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Import SSH Public Key to AWS
resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.jenkins_key.public_key_openssh
}

# Save the Private Key Locally
resource "local_file" "private_key" {
  filename        = "${path.root}/${var.ssh_key_name}.pem"
  content         = tls_private_key.jenkins_key.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.jenkins_key_pair.key_name
  subnet_id                   = var.subnet_id
  security_groups             = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name

  user_data = templatefile("${path.module}/jenkins-userdata.sh", {})

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins-sg-"
  description = "Allow SSH and Jenkins access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Jenkins UI access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "jenkins_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "jenkins_policy" {
  name       = "jenkins-policy"
  roles      = [aws_iam_role.jenkins_role.name]
  policy_arn = var.iam_policy_arn
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.jenkins_role.name
  lifecycle {
    ignore_changes = [name]
  }
}