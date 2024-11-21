# Providers
provider "local" {}

# Variables
variable "app_name" {
  default = "team-web-app"
}

variable "dockerhub_username" {
  description = "Your Docker Hub username"
}

variable "dockerhub_password" {
  description = "Your Docker Hub password"
  sensitive   = true
}

# Build and Push Docker Image Locally
resource "null_resource" "build_and_push_docker_image" {
  provisioner "local-exec" {
    command = <<EOT
      # Create Dockerfile dynamically
      echo 'FROM python:3.9-slim' > Dockerfile
      echo 'RUN pip install flask' >> Dockerfile
      echo 'COPY app.py /app.py' >> Dockerfile
      echo 'CMD ["python", "/app.py"]' >> Dockerfile

      # Create the Flask app dynamically
      echo 'from flask import Flask' > app.py
      echo 'app = Flask(__name__)' >> app.py
      echo '' >> app.py
      echo '@app.route("/")' >> app.py
      echo 'def home():' >> app.py
      echo '    return """' >> app.py
      echo '    <html>' >> app.py
      echo '    <body style="background-color: green;">' >> app.py
      echo '    <h1>Team Members</h1>' >> app.py
      echo '    <ul>' >> app.py
      echo '      <li>Bhala</li>' >> app.py
      echo '      <li>Hemant</li>' >> app.py
      echo '      <li>Nikhil</li>' >> app.py
      echo '    </ul>' >> app.py
      echo '    </body>' >> app.py
      echo '    </html>' >> app.py
      echo '    """' >> app.py
      echo '' >> app.py
      echo 'if __name__ == "__main__":' >> app.py
      echo '    app.run(host="0.0.0.0", port=80)' >> app.py

      # Log in to Docker Hub, build, and push the image
      docker login -u ${var.dockerhub_username} -p ${var.dockerhub_password}
      docker build -t ${var.dockerhub_username}/${var.app_name}:latest .
      docker push ${var.dockerhub_username}/${var.app_name}:latest
    EOT
  }
}

# Output Docker Hub Image URL
output "docker_image_url" {
  value = "${var.dockerhub_username}/${var.app_name}:latest"
}

