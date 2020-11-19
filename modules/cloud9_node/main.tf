# Node 1
resource "openstack_networking_floatingip_v2" "fip1" {
  pool = var.floating_ip_pool
}


resource "openstack_compute_instance_v2" "worker-host1" {
  availability_zone = var.availability_zone
  name      = "worker-host1.cccp.fi"
  image_id  = var.image_id
  flavor_name = "nbl-n1-tiny"
  key_pair  = var.ssh_key
  security_groups = [var.secgroup_allow_all_my_ip, var.secgroup_allow_public]
  user_data = <<-EOF
    #cloud-config
    disable_root: false
    runcmd:
      - echo "[kubernetes]"  > /etc/yum.repos.d/kubernetes.repo
      - echo "baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch" >> /etc/yum.repos.d/kubernetes.repo
      - echo "enabled=1" >> /etc/yum.repos.d/kubernetes.repo
      - echo "gpgcheck=1" >> /etc/yum.repos.d/kubernetes.repo
      - echo "repo_gpgcheck=1" >> /etc/yum.repos.d/kubernetes.repo
      - echo "gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg"  >> /etc/yum.repos.d/kubernetes.repo
      - echo "exclude=kubelet kubeadm kubectl" >> /etc/yum.repos.d/kubernetes.repo
      - yum install -y  kubelet kubeadm kubectl --disableexcludes=kubernetes
      - firewall-cmd --permanent --add-port=10251/tcp
      - firewall-cmd --permanent --add-port=10255/tcp
      - firewall-cmd --reload
      - echo "net.bridge.bridge-nf-call-ip6tables = 1" > /etc/sysctl.d/k8s.conf
      - echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf
      - sysctl --system
      - setenforce 0
      - sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
      - systemctl enable --now kubelet
      - systemctl restart sshd
      - cp /home/centos/.ssh/authorized_keys /root/.ssh/authorized_keys
  EOF
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc1" {
  floating_ip = openstack_networking_floatingip_v2.fip1.address
  instance_id = openstack_compute_instance_v2.worker-host1.id
}
