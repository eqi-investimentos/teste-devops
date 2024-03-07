## Instruções Gerais De Como Rodar o TF

1. **Variáveis AWS:**
   - Primeiro deve rodar os comandos abaixo, colocando os valores de chaves do seu IAM dentro da AWS:
   - export AWS_ACCESS_KEY_ID=
   - export AWS_SECRET_ACCESS_KEY=

2. **Para Acesso a EC2:**
   - Deve-se gerar a chave pub dentro da pasta ec2 com o comando: ssh-keygen -f aws-key
 
3. **Para rodar o TF:**
   - Rodar primeiramente o comando "terraform init" para baixar os módulos
   - Após rodar esse comando, utilizar o "terraform plan" para mapear a infra dos arquivos tf
   - E para finalizar, deve-se rodar o comando "terraform apply" e dar yes quando solicitado.

4. **Alteração dos valores VPC e Subnet:**
   - Alterar os valores dos recursos aws_vpc e aws_subnet no arquivo main.tf dentro da pasta ec2, pelo os que serão mostrados após finalizar o terraform apply nas variáveis outputs
   - Após alteração dos valores, entrar na pasta ec2 e rodar os comandos terraform init, terraform plan e terraform apply.

5. **Final:**
   - Após subir todos os recursos, realizar o comando terraform destroy para baixar todo o ambiente provisionado na AWS.


OBS: A API estava dando erros no build localmente, então apenas foi realizada a subida da infraestrutura provisionada sem a api.