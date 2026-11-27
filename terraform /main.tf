
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP and SSH access"

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "python_app" {
  ami                    = "ami-0c1ac8a41498c1a9c"
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update -y
    apt-get install -y python3 python3-pip python3-venv git

    mkdir -p /opt/python-calculator
    cd /opt/python-calculator

    git clone https://github.com/YOUR_USERNAME/python-aws-terraform-project.git .

    python3 -m venv venv
    ./venv/bin/pip install -r requirements.txt

    cat > /etc/systemd/system/python-calculator.service <<'SERVICE'
    [Unit]
    Description=Python Flask Calculator
    After=network.target

    [Service]
    User=root
    WorkingDirectory=/opt/python-calculator
    ExecStart=/opt/python-calculator/venv/bin/gunicorn --workers 2 --bind 127.0.0.1:5000 app:app
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    cat > /etc/nginx/sites-available/python-calculator <<'NGINX'
    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://127.0.0.1:5000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
    NGINX

    apt-get install -y nginx
    ln -sf /etc/nginx/sites-available/python-calculator /etc/nginx/sites-enabled/python-calculator
    rm -f /etc/nginx/sites-enabled/default

    systemctl daemon-reload
    systemctl enable python-calculator
    systemctl restart python-calculator
    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}

