docker buildx build --platform linux/amd64 --force-rm -t 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-backend:latest . -f Dockerfile.FasteignirApi
docker push 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-backend:latest

aws ecs update-service --force-new-deployment --service frontend-cluster-service --cluster frontend-cluster
