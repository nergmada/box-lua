VERSION := 0.7
NAME := resty
OWNER := kureikain

build:
	docker build -t $(OWNER)/$(NAME):$(VERSION) .

push:
	docker push $(OWNER)/$(NAME):$(VERSION)

