#!/usr/bin/env bash
curl https://docs.projectcalico.org/manifests/calico.yaml -O

sed -i 's/# - name: CALICO_IPV4POOL_CIDR/- name: CALICO_IPV4POOL_CIDR/g' calico.yaml
sed -i 's/#   value: "192.168.0.0\/16"/  value: "192.168.0.0\/20"/g' calico.yaml

cat calico.yaml | grep CALICO_IPV4POOL_CIDR -A1

kubectl apply -f ./calico.yaml
kubectl create ns cis-benchmarks

# Install Kube-Bench
wget https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml
kubectl apply -f job.yaml -n cis-benchmarks
kubectl logs -l "app=kube-bench"

# Kube-Bench Job Node
wget https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job-node.yaml
kubectl apply -f job.yaml -n cis-benchmarks

# Kube-Bench Job Master
wget https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job-master.yaml
kubectl apply -f job-master.yaml -n cis-benchmarks

# Trust the falcosecurity GPG key, configure the apt repository, and update the package list:

curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y

# Install kernel headers:
sudo apt-get -y install linux-headers-$(uname -r)

# Install Falco:
sudo apt-get install -y falco

# If you installed Falco by using the DEB or the RPM package, you can start the service by running:
sudo systemctl enable falco
sudo systemctl start falco

# You can also view the Falco logs using journalctl.
journalctl -fu falco
sleep 5

# Health Checks
kubectl logs -l "app=kube-bench"  -n cis-benchmarks
sleep 5
kubectl logs -l "job-name=kube-bench"  -n cis-benchmarks
sleep 5
kubectl logs -l "job-name=kube-bench-master"  -n cis-benchmarks
sleep 5

# Confirm Cluster Configuration
kubectl version
kubectl cluster-info

# [FAIL] --protect-kernel-defaults argument is set to true

#Run as an admin
sudo snap install docker
sudo docker run --rm -v `pwd`:/host docker.io/aquasec/kube-bench:latest install
sudo ./kube-bench
