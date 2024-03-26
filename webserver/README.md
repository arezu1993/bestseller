# Terraform AWS Load Balancer Project

This Terraform project sets up an AWS infrastructure consisting of an Application Load Balancer (ALB) and two EC2 instances to forward traffic. It utilizes modular structure using Terraform modules for various AWS resources.

## Project Structure

.
├── modules

│   ├── alb

│   ├── route53

│   ├── sg

│   ├── vpc

│   └── vm

├── main.tf

├── variables.tf

├── outputs.tf

└── README.md



### Modules

- **acm**: Manages AWS Certificate Manager.
- **alb**: Manages Application Load Balancer.
- **route53**: Manages DNS records using Route 53.
- **sg**: Manages Security Groups.
- **vpc**: Manages AWS VPC.
- **vm**: Manages EC2 instances.

## Usage

1. Clone this repository:

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Modify `variables.tf` to customize your deployment parameters.

4. Apply the Terraform configuration:

    ```bash
    terraform apply
    ```

5. Review the changes and confirm by typing `yes`.

## Configuration

- **main.tf**: Defines the main Terraform configuration for setting up the infrastructure.
- **variables.tf**: Contains input variables used in the Terraform configuration.
- **outputs.tf**: Contains output values that might be useful after applying the Terraform configuration.

## Requirements

- Terraform installed locally. You can download it from [terraform.io](https://www.terraform.io/downloads.html).
- AWS account with appropriate permissions.
- Proper AWS credentials configured locally.

## Contributing

Feel free to contribute to this project by submitting issues or pull requests.

## License

This project is licensed under the [MIT License](LICENSE).
