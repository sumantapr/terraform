pipeline {
agent any

environment {
TF_VAR_example = 'value' // Optionally define environment variables
}

stages {
stage('Checkout Code') {
steps {
// Checkout code from GitHub repository
git branch: 'main', url: 'https://github.com/hemantmay07/demo.hack.git'
}
}

stage('Install Terraform') {
steps {
// Install Terraform if not already installed
script {
if (!fileExists('/usr/local/bin/terraform')) {
sh 'curl -LO https://github.com/hashicorp/terraform/releases/download/v1.5.0/terraform_1.5.0_linux_amd64.zip'
sh 'unzip terraform_1.5.0_linux_amd64.zip'
sh 'mv terraform /usr/local/bin/'
}
}
}
}

stage('Terraform Init') {
steps {
// Initialize Terraform
sh 'terraform init'
}
}

stage('Terraform Plan') {
steps {
// Run Terraform Plan
sh 'terraform plan'
}
}

stage('Terraform Apply') {
steps {
// Apply Terraform (only run in certain cases like manual approval)
input message: 'Do you want to apply the Terraform plan?', ok: 'Yes'
sh 'terraform apply -auto-approve'
}
}
}

post {
success {
echo 'Terraform job completed successfully.'
}
failure {
echo 'Terraform job failed.'
}
}
}

