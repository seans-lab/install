# Install K8s Cluster

## Installing K8s

### Setup Overlay on all nodes

```
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay

sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```
### Install and Configur containerd on All Nodes

```
sudo apt-get update && sudo apt-get install -y containerd

sudo mkdir -p /etc/containerd

sudo containerd config default | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd
```

### Disable Swap

```
sudo swapoff -a

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### Install kubeadm, kubelet, and kubectl.

```
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y kubelet=1.20.1-00 kubeadm=1.20.1-00 kubectl=1.20.1-00

sudo apt-mark hold kubelet kubeadm kubectl
```

### On Control Node setup kubectl access

```
sudo kubeadm init --pod-network-cidr 192.168.0.0/16

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl version
```

### On control node, setup Calico

```
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl get pods -n kube-system
```

### On Control Node setup join command

```
kubeadm token create --print-join-command
```

### On worker nodes join cluster

```
sudo kubeadm join ...
```

### On Control Node check nodes

```
kubectl get nodes
```

# Upgrading K8s with kubeadm

## On Control Node

```
kubectl drain <control plane node name> --ignore-daemonsets

sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubeadm=1.20.2-00

kubeadm version

sudo kubeadm upgrade plan v1.20.2

sudo kubeadm upgrade apply v1.20.2

sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubelet=1.20.2-00 kubectl=1.20.2-00

sudo systemctl daemon-reload

sudo systemctl restart kubelet

kubectl uncordon <control plane node name>

kubectl get nodes
```

## Upgrade the worker nodes.

### On the Control Plane, cordon worker node

```
kubectl drain <worker 1 node name> --ignore-daemonsets --force
```

### On the Worker Node

```
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubeadm=1.20.2-00

kubeadm version

sudo kubeadm upgrade node

sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubelet=1.20.2-00 kubectl=1.20.2-00

sudo systemctl daemon-reload

sudo systemctl restart kubelet
```

### On the Control Node

```
kubectl uncordon <worker 1 node name>
kubectl get nodes
```
