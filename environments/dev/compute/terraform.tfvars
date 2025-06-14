project_id   = "aqueous-scout-444117-j2"
region       = "us-central1"
zone         = "us-central1-a"

vpc_name     = "my-vpc"
subnet_cidr  = "10.0.0.0/16"

network      = "my-vpc"
subnetwork   = "my-subnet"

instance_name = "benchmark"
machine_type  = "e2-medium"

tags = [
  "benchmark"
]

metadata = {
  startup-script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io docker-compose
    usermod -aG docker $USER

    cd /home/ubuntu
    git clone https://github.com/rsingh0101/terraform-gcp.git /opt/redis-benchmark
    cd /opt/redis-benchmark/scripts/redis-benchmark
    docker-compose up -d

  EOT
}

firewall_rules = [
  {
    name        = "allow-benchmark"
    description = "Allow multiple app endpoints"
    direction   = "INGRESS"
    priority    = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["benchmark"]
    allowed = [
      {
        protocol = "tcp"
        ports    = ["22","80","443","3000","9090"]
      }
    ]
  }
]
