# Create a service account within your eks cluster

export KUBECONFIG=aws.kubeconfig
kubectl apply -f ./assets/eks-service-account.yml

#kubectl get secret $(kubectl get secrets|grep default|awk '{print $1}') -o jsonpath="{['data']['ca\.crt']}" | base64 --decode
kubectl get secret $(kubectl get secrets|grep default|awk '{print $1}') -o jsonpath="{['data']['ca\.crt']}" | base64 --decode > cert.pem
cat cert.pem

#kubectl apply -f ./assets/eks-service-account.yml

#K8STOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')|grep "token:"|awk '{print $2}')
#echo $K8STOKEN

#K8SAPI=$(cat aws.kubeconfig|grep "server:"|awk '{print $2}')
curl --header "Private-Token: ${GL_API_TOKEN}" https://gitlab.example.com/api/v4/projects/${CI_PROJECT_ID}/clusters/user \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data '{"name":"cluster-5", "platform_kubernetes_attributes":{"api_url":"https://35.111.51.20","token":"12345","namespace":"cluster-5-namespace","ca_cert":"-----BEGIN CERTIFICATE-----\r\nhFiK1L61owwDQYJKoZIhvcNAQELBQAw\r\nLzEtMCsGA1UEAxMkZDA1YzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM4ZDBj\r\nMB4XDTE4MTIyNzIwMDM1MVoXDTIzMTIyNjIxMDM1MVowLzEtMCsGA1UEAxMkZDA1\r\nYzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM.......-----END CERTIFICATE-----"}}'