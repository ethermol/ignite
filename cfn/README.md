After cloudformation:
- helm missing
curl -LO https://get.helm.sh/helm-v3.4.1-linux-arm64.tar.gz
Only downloaded the .tgz .into thr root. Should be optimized later. Will be removed from the templace for now.

# First step for setup: make create
- This install and execute an AWS Cloudwatch Template in the region you're connected to (AWS_ENVIRONMENT)
I wanted to use a hip t4g-instance (ARM) for my project and had to swap regions from France to Germany.

- Added user mos to the instance manually (adduser). Added the user within /etc/sudoers.d next to ec2-user. 

- Standard included within k3s is traefik v1.7. We need V2 do this has to be added to the installation manually.

# Second Step: Copy stuff from repo to Instance
- copy helm-install.sh and helm-deploy.sh
- install helm: run helm-install && helm-deploy (this will also add the traefik repo)
- (consider implementing a values.yaml file to override traefik defaults, this should be done within the helm-deploy script. Also see: https://github.com/traefik/traefik-helm-chart/tree/master/traefik)

## Output for manual steps:
'''
[mos@myth /store/repo/ignite/cfn]$ scp helm-install.sh helm-deploy.sh elft.net:bin              (master|✚ 3…) 11:06AM
helm-install.sh                                                                     100%  266     3.2KB/s   00:00
helm-deploy.sh                                                                      100%  404     4.9KB/s   00:00
[mos@myth /store/repo/ignite/cfn]$                                                              (master|✚ 3…) 11:11AM
#...Instance:
[mos@ip-172-31-12-44 ~]$ chmod +x bin/*; helm-install
[mos@ip-172-31-12-44 ~]$ helm version
version.BuildInfo{Version:"v3.4.1", GitCommit:"c4e74854886b2efe3321e185578e6db9be0a6e29", GitTreeState:"clean", GoVersion:"go1.14.11"}
[mos@ip-172-31-12-44 ~]$ helm-deploy
[mos@ip-172-31-12-44 helm-charts]$ helm repo update
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /etc/rancher/k3s/k3s.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /etc/rancher/k3s/k3s.yaml
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "traefik" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
[mos@ip-172-31-12-44 helm-charts]$ helm install traefik traefik/traefik
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /etc/rancher/k3s/k3s.yaml
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /etc/rancher/k3s/k3s.yaml
W0118 11:55:29.209034    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:29.216295    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:29.224779    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:29.237105    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:29.244382    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:29.256149    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:29.270727    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:31.278734    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:31.281300    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:31.283629    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:31.285928    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:31.288201    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:31.290452    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W0118 11:55:31.292700    4447 warnings.go:67] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
NAME: traefik
LAST DEPLOYED: Mon Jan 18 11:55:31 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
[mos@ip-172-31-12-44 ~]$ kubectl apply -f ./helm-charts/whoami/
deployment.apps/whoami created
Warning: resource services/whoami is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
service/whoami configured
ingressroute.traefik.containo.us/whoami created
[mos@ip-172-31-12-44 ~]$

'''
helm install -f myvals.yaml ./mychart

## Known issues:
- The security-group allows access for my-ip and AWS-CONNECT in ce-central-1.
This should be setup more generic/externally.
