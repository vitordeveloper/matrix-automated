# Matrix-automated
Projeto de Automação de Start and Destroy Wordpress na aws. 


>Subir na AWS uma aplicação Web que utilize persistência externa como por exemplo uma aplicação wordpress utilizando banco Mysql. A aplicação deverá ser uma imagem docker pública ou customizada. (Se for customizada commite o Dockerfile).

## Pré-Requesitos:

    * Python
    * Packer
    * Terraform
    * Ansible
    * Variaveis de ambiente: 
        AWS_DEFAULT_REGION
        AWS_ACCESS_KEY_ID
        AWS_ACCESS_SECRET_KEY_ID
   
# Start do Ambiente:         

No diretório python executar o seguinte comando composto por 5 parâmetros: nome da aplicação, ambiente , instance-type, número de instancias e ação.: 
```sh
python main.py wordpress dev t2.micro 4 create
```


## Execução Standalone

### Criação das AMI's:
No diretorio packer (mysqlwordpress / wordpress) executar o seguinte commando:
 ```sh
make projectname=wordpresstest  enviroment=dev instancetype=t2.micro
``` 
  
### Criação da Infra:
No diretório terraform (mysqlwordpress / wordpress):
    
 ```sh
make projectname=wordpresstest  enviroment=dev instancetype=t2.micro qnt=3
```