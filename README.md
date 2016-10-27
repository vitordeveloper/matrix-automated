# matrix-automated
Projeto de Automação de Start and Destroy Wordpress na aws. 

Subir na AWS uma aplicação Web que utilize persistência externa como por exemplo uma aplicação wordpress utilizando banco Mysql. A aplicação deverá ser uma imagem docker pública ou customizada. (Se for customizada commite o Dockerfile).

O entregável principal deve ser um script que recebe 5 parâmetros: nome da aplicação, ambiente , instance-type, número de instancias e ação.
 
Por exemplo: ./cloud-automation wordpresstest dev t2.micro 3 create 
 
Os tipos de ação são somente create and destroy. 
 
O resultado desse script deverá ser a url do loadbalancer apenas.