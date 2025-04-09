# AWS EC2 Instance Terraform Configuration

This Terraform configuration provisions an EC2 instance in AWS with:
- t2.micro instance type
- Amazon Linux 2 AMI
- Security group allowing SSH (port 22) and HTTP (port 80) access
- IAM role with configurable policies
- Consistent resource tagging
- Lifecycle management
- Outputs for public IP and DNS

## Usage
1. Initialize Terraform (with S3 backend and DynamoDB locking):
   ```bash
   terraform init
   ```
2. Review execution plan:
   ```bash
   terraform plan
   ```
3. Apply configuration:
   ```bash
   terraform apply
   ```

### State Management
- State is stored in S3: `my-terraform-state-bucket`
- State locking is enforced via DynamoDB: `terraform-lock-table`
- To migrate from local to remote state:
  ```bash
  terraform init -migrate-state
  ```

## Enhancement Suggestions

1. **Variables Customization**:
   - Modify `variables.tf` to add more configurable parameters
   - Add validation blocks for input variables

2. **Security Improvements**:
   - Restrict SSH access to specific IP ranges
   - Add HTTPS (port 443) access
   - Implement IAM roles for the EC2 instance

3. **Additional Features**:
   - Add Elastic IP association
   - Include user-data for instance initialization
   - Add monitoring/alerts configuration
   - Implement auto-scaling group

4. **Security**:
   - IAM role with EC2 read-only access by default
   - Restricted SSH access to private networks
   - Configurable IAM policies via variables

5. **CI/CD Integration**:
   - Add Terraform CI/CD pipeline examples
   - Include testing framework setup
