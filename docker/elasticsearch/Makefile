all: push

TAG = 0.2
PREFIX = hackd.azurecr.io/elasticsearch-kubernetes

container:
	docker build -t $(PREFIX):$(TAG) .

push: container
	docker push $(PREFIX):$(TAG)

clean:
	docker rmi $(PREFIX):$(TAG)
