# docker buildx build --platform linux/amd64 --force-rm -t "992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-web:latest . -f Dockerfile.FasteignirApi
aws ecr get-login-password  | docker login --username AWS --password-stdin 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-web
docker buildx build --platform=linux/amd64 --builder cloud-robertaandersen-test . -t cloud-test-web -f Dockerfile.fasteignirweb
docker tag cloud-test-web 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-web:latest

docker push 992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-web:latest

aws ecs update-service --force-new-deployment --service web-cluster-service --cluster web-cluster
