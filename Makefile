up:
	cd src && python -m http.server -b 0.0.0.0 80

lint:
	terraform fmt -write -recursive

tf:
	cd terraform && terraform apply -auto-approve -var-file=.tfvars && terraform output --json > ../terraform-output.json

deploy-src:
	cd scripts && source ./venv/bin/activate && python deploy.py

deploy: tf deploy-src

destroy:
	cd terraform && terraform destroy -auto-approve -var-file=.tfvars
