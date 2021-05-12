all: cluster up

up:
	docker-compose up -d	

down:
	docker-compose down	

cluster:
	ctlptl apply -f cluster.yaml

install:
	pip install -r requirements.txt

prepare:
	bash requirements/requirements.sh
