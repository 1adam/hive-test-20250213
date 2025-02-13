# Hive DevOps Take-Home // Adam Barrett // Feb 2025

## Deployment Instructions
- Run `terraform apply`. All variables without defaults have been defined in `terraform.tfvars`; all variables with defaults can be found in `variables.tf`

## Chosen Approach and Rationale
I've chosen to deploy the nginx image in ECS, with an ALB in front. This is a good choice because it allows the ECS tasks to scale both vertically (cpu and memory tunables) as well as horizontally (desired count). These specific tunables can all be adjusted by way of variables.  The load balancer front allows for the backend to be scaled to whatever extent is necessary while maintaining relative simplicity in its implementation.  EKS/Kubernetes felt like overkill given this simple setup (I don't think that degree of abstracton is required for a simple webserver scenario). 

Only the Load Balancer is reachable externally, via port 80. It's best not to allow direct access to the server instances themselves (whether it's EC2, ECS, etc.) for security reasons.

Other than tuning the CPU/MEM and Desired count, and a volume to support proper content, I think this solution is extremely durable and scalable.  If more "extreme" scale is needed, it might make sense to go with EKS over ECS, but in my experience ECS is very performant, even for large-scale deployments of a simple application (eg. webserver).


## Assumptions Made
- The state is managed already, as per the instructions (as it is, this project will create a local state file)


## Areas for Improvement, Given More Time
- Outbound access is currently allowed to 0.0.0.0/0:443. This is not good practice, but it's in place to allow ECS to pull the docker image. Normally I would restrict access using an outbound proxy (something like Squidproxy) or only allow ECS to hit ECR for images.
- VPC Flow Logs are not enabled in this setup, because I ran out of time. Normally, in a production environment, I prefer to have as much logging as is feasible, given any budget constraints. So, for the "real" setup, I would have flow logs enabled.
- More robust health checks on the Load Balancer/ Target Group and ECS levels.
- Support for mapping a volume to the ECS tasks, to properly serve actual content rather than the default "Welcome to nginx" page.
- More use of CloudWatch -- dashboards, alarms around KPIs/SLOs, etc.
