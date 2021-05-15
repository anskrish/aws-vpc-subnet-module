all:	set plan
set:
		rm -f .terraform/terraform.tfstate
		terraform init
		terraform init --backend-config="key=unit/<account>/aws-guardduty/terraform.tfstate"

plan:
		terraform plan -out=aws-vpc.out

apply:
		terraform apply aws-vpc.out

clean:
		rm -f *.tfvars
		rm -f *.out
		rm -rf .terraform/*
