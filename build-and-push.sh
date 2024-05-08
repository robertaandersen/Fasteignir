# docker buildx build --platform linux/amd64 --force-rm -t 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-backend:latest . -f Dockerfile.FasteignirApi
docker buildx build --platform=linux/amd64 --builder cloud-robertaandersen-test . -t cloud-test -f Dockerfile.FasteignirApi
docker tag cloud-test 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-backend:latest

docker push 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-backend:latest

aws ecs update-service --force-new-deployment --service frontend-cluster-service --cluster frontend-cluster
