export DNS_REPLICAS=1
export DNS_DOMAIN=cluster.local
export DNS_SERVER_IP=10.0.0.10

yaml=/tmp/skydns.yaml
cp -f skydns.yaml.in /tmp/skydns.yaml
sed -in "s#{{ pillar\['dns_replicas'\] }}#${DNS_REPLICAS}#g" $yaml
sed -in "s#{{ pillar\['dns_domain'\] }}#${DNS_DOMAIN}#g" $yaml
sed -in "s#{{ pillar\['dns_server'\] }}#${DNS_SERVER_IP}#g" $yaml


kubectl get ns
#kubectl create -f ./kube-system.yaml
#sleep 3
#kubectl create -f /tmp/skydns.yaml

