# Terraform-AWS-EKS 구현



## Describe

인프라를 손쉽게 구축하고 효율적으로 인프라를 코드로 관리하는 IaC(Infrastructure as Code)툴인 Terraform을 이용하여
AWS EKS를 구현합니다.

모듈로 간단하게 구현이 가능하지만, 구조를 파악하는 것이 중요하고 구조를 파악하고 싶어자하는 사람들을 위해서 정리하였습니다.

구현에 필요한 각 요소 VPC, ACL, IAM, Cluster, Worker Node를 tf파일로 작성하였습니다.

## Version

```bash
aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
}
EKS version = "1.21"
```



## 디렉토리 구조

```bash
├── README.md
├── acl.tf
├── bastion.tf
├── eks-cluster.tf
├── eks-nodes.tf
├── iam.tf
├── main.tf
├── outputs.tf
├── security_group.tf
├── variables.tf
└── vpc.tf
```



## how to use
```bash
#init 초기화
$terraform init
#plan 테스트
$terraform plan
#apply 실행
$terraform apply
# destroy 제거
$terraform destroy
```



## Reference
https://registry.terraform.io/providers/hashicorp/aws/latest/docs