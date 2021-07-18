PROFILE=aws-terraform

# AWS #
bash:
	aws-vault exec $(PROFILE)
login:
	aws-vault login $(PROFILE)

# TERRAFORM #
init:
	aws-vault exec $(PROFILE) -- terraform init
plan:
	aws-vault exec $(PROFILE) -- terraform plan
apply:
	aws-vault exec $(PROFILE) -- terraform apply -auto-approve
destroy:
	aws-vault exec $(PROFILE) -- terraform destroy -auto-approve
fmt:
	aws-vault exec $(PROFILE) -- terraform fmt -recursive
console:
	aws-vault exec $(PROFILE) -- terraform console