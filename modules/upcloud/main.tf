
resource "upcloud_server" "worker-host3" {
  # System hostname
  hostname = "worker-host3.cccp.fi"

  # Availability zone
  zone = "uk-lon1"

  # Number of CPUs and memory in GB
  plan = "1xCPU-1GB"

  storage_devices {
    # System storage device size
    size = 25
    # Template UUID for CentOS 7
     storage = "01000000-0000-4000-8000-000050010300"

     # Storage device typeC
     tier   = "maxiops"
     action = "clone"
   }
 # Network interfaces
 network_interface {
   type = "public"
 }

 network_interface {
   type = "utility"
 }

 # Include at least one public SSH key
 login {
   user = "root"
   keys = [
     "Your public SSH key, ssh-rsa etc",
   ]
   create_password = false
   password_delivery = "email"
 }
 # Configuring connection details
 connection {
   # The server public IP address
   host        = self.network_interface[0].ip_address
   type        = "ssh"
   user        = "root"
   private_key = file("~/.ssh/YourPrivate.key")
 }
 #  Remotely executing a command on the server
 provisioner "remote-exec" {
   inline = [
     "echo '[kubernetes]'  > /etc/yum.repos.d/kubernetes.repo",
     "echo 'baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch' >> /etc/yum.repos.d/kubernetes.repo",
     "echo 'enabled=1' >> /etc/yum.repos.d/kubernetes.repo",
     "echo 'gpgcheck=1' >> /etc/yum.repos.d/kubernetes.repo",
     "echo 'repo_gpgcheck=1' >> /etc/yum.repos.d/kubernetes.repo",
     "echo 'gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'  >> /etc/yum.repos.d/kubernetes.repo",
     "echo 'exclude=kubelet kubeadm kubectl' >> /etc/yum.repos.d/kubernetes.repo",
     "yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes",
     "echo 'net.bridge.bridge-nf-call-ip6tables = 1' > /etc/sysctl.d/k8s.conf",
     "echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.d/k8s.conf",
     "sysctl --system",
     "setenforce 0",
     "systemctl enable --now httpd kubelet",
     "firewall-cmd --permanent --add-port=10251/tcp",
     "firewall-cmd --permanent --add-port=10255/tcp",
     "firewall-cmd --reload"
   ]
 }
}
