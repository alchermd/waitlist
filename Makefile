up:
	cd src && python -m http.server -b 0.0.0.0 80

lint:
	terraform fmt -write -recursive

tf:
	cd terraform && terraform apply -auto-approve -var-file=.tfvars && terraform output --json > ../terraform-output.json

deploy-src:
	sh ./scripts/upload-to-s3.sh

deploy: tf

destroy:
	cd terraform && terraform destroy -auto-approve -var-file=.tfvars
