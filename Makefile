.PHONY: plan apply destroy deploy up down

ENV ?= staging

plan:
	cd terraform/environments/$(ENV) && terraform init && terraform plan

apply:
	cd terraform/environments/$(ENV) && terraform apply

destroy:
	cd terraform/environments/$(ENV) && terraform destroy

deploy:
	helm upgrade --install app helm/app -n app --create-namespace

up:
	docker compose up --build

down:
	docker compose down -v
