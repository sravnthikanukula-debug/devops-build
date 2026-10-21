# DevOps Capstone: React App CI/CD

## Submission links
- **GitHub repository:** https://github.com/sravnthikanukula-debug/devops-build
- **Deployed site:** http://54.186.143.174
- **Docker images:**
  - `sravanthikanukuladocker/dev` (public)
  - `sravanthikanukuladocker/prod` (private)

## Architecture
GitHub (`dev` / `master`) → Jenkins (webhook) → build and push to Docker Hub → deploy to AWS EC2 → monitored by Prometheus + Blackbox exporter + Alertmanager.

## Project contents
| File | Purpose |
|---|---|
| `Dockerfile`, `nginx.conf` | Serve the prebuilt React app with nginx on port 80 |
| `docker-compose.yml` | Run the image as the `react-app` container |
| `build.sh` | Build the Docker image (`./build.sh <dev\|prod> [tag]`) |
| `deploy.sh` | Pull and start the image on the server |
| `Jenkinsfile` | Build, push and deploy pipeline |
| `monitoring/` | Prometheus, Blackbox and Alertmanager configuration |

## Branch flow
- **Push to `dev`:** Jenkins builds the image and pushes it to the `dev` Docker Hub repository. Nothing is deployed.
- **Merge `dev` into `master`:** Jenkins builds the image, pushes it to the private `prod` repository, and deploys it on EC2.

## Infrastructure notes
- EC2 instance type is **t3.medium** (instead of t2.micro) because Jenkins and monitoring run on the same server as the app.
- Security group: HTTP (80) is open to everyone; SSH (22) is limited to my own IP.
- Port 8080 (Jenkins) is open so GitHub can deliver webhooks; port 9090 (Prometheus) is for the monitoring demo.

## Monitoring
Prometheus uses the Blackbox exporter to probe the site every 15 seconds. The `AppDown` alert fires when `probe_success == 0` for one minute, and Alertmanager sends an email only in that case (`send_resolved: false`, so no recovery emails).
