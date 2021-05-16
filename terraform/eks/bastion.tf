data "aws_ami" "ubuntu" {
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "web1" {
    ami = data.aws_ami.ubuntu
    instance_type = "t2.micro"    
    
    subnet_id = 
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "${aws_key_pair.${var.environment}-key-pair.id}"

    provisioner "remote-exec" {
        inline = [
             "curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"",
             "chmod +x kubectl && sudo mv kubectl /usr/local/bin"
        ]
    }    

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }
}

resource "aws_key_pair" "prod-key-pair" {
    key_name = "${var.environment}-key-pair"
    public_key = "${file(var.public_key_path)}"
}
