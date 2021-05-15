resource "aws_instance" "web1" {
    ami = "${lookup(var.ami, var.aws_region)}"
    instance_type = "t2.micro"    
    
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
    key_name = "${aws_key_pair.prod-key-pair.id}"

    provisioner "file" {
        source = "nginx.sh"
        destination = "/tmp/nginx.sh"
    }    
    
    provisioner "remote-exec" {
        inline = [
             "chmod +x /tmp/nginx.sh",
             "sudo /tmp/nginx.sh"
        ]
    }    

    connection {
        type = "ssh"
        host = self.public_ip
        user = "${var.ec2_user}"
        private_key = "${file(var.private_key_path)}"
    }
}

resource "aws_key_pair" "prod-key-pair" {
    key_name = "prod-key-pair"
    public_key = "${file(var.public_key_path)}"
}
