resource "aws_security_group" "ssh-allowed" {
    vpc_id = module.vpc.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }    

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp" 
        cidr_blocks = ["103.70.197.152/32"]
    } 

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["103.70.197.152/32"]
    }    
    
    tags = merge({
        Name = "ssh-allowed"
        For = "bastion"
    }, local.tags)
}

data "aws_ami" "ubuntu" {
    most_recent = true

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

data "aws_subnet_ids" "public" {
    vpc_id = module.vpc.vpc_id
    filter {
        name   = "tag:Name"
        values = ["education-vpc-public-*"]
    }
}

resource "aws_instance" "bastion" {
    depends_on = [
        module.eks
    ]

    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.small"    
    
    subnet_id = sort(data.aws_subnet_ids.public.ids)[1]
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "${aws_key_pair.key-pair.id}"

    provisioner "file" {
        source = "./kubeconfig_${var.cluster_name}"
        destination = "/home/ubuntu/.kube/config"
    }

    provisioner "remote-exec" {
        inline = [
             "curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl",
             "chmod +x kubectl && sudo mv kubectl /usr/local/bin"
        ]
    }    

    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = "${file(local.private_key_path)}"
    }

    tags = merge(
        {
            For = "Bastion"
            Name = "${var.environment}-${var.project}-bastion"
        }, 
        local.tags)
}

locals  {
    public_key_path = "./keys/${var.environment}/${var.project}.pub"
    private_key_path = "./keys/${var.environment}/${var.project}"
}

resource "aws_key_pair" "key-pair" {
    key_name = "${var.environment}-${var.project}-key-pair"
    public_key = "${file(local.public_key_path)}"
    tags = local.tags
}
