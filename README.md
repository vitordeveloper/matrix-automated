# matrix-automated
Projeto de Automação de Start and Destroy Wordpress na aws. 

Subir na AWS uma aplicação Web que utilize persistência externa como por exemplo uma aplicação wordpress utilizando banco Mysql. A aplicação deverá ser uma imagem docker pública ou customizada. (Se for customizada commite o Dockerfile).

O entregável principal deve ser um script que recebe 5 parâmetros: nome da aplicação, ambiente , instance-type, número de instancias e ação.
 
Por exemplo: ./cloud-automation wordpresstest dev t2.micro 3 create 
 
Os tipos de ação são somente create and destroy. 
 
O resultado desse script deverá ser a url do loadbalancer apenas.

## pre requesitos:

    * Python
    * Packer
    * Terraform
    * Ansible
    * Variaveis de ambiente: 
        AWS_DEFAULT_REGION
        AWS_ACCESS_KEY_ID
        AWS_ACCESS_SECRET_KEY_ID
   
# Start do Ambiente:         

´´´sh
Na pasta Python executar o seguinte comando ex. 

 python main.py wordpress dev t2.micro 4 create

´´´

#Gerar as Amis:
Na Pasta Terraform(mysqlwordpress / wordpress) executar o seguinte commando: 
 
  make projectname=wordpresstest  enviroment=dev instancetype=t2.micro 
  
  
#Start Infra estrutura:

Na Pasta Terraform(mysqlwordpress / wordpress): 
make projectname=wordpresstest  enviroment=dev instancetype=t2.micro qnt=3


