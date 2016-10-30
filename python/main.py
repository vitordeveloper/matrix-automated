import os




def verifyExistenceAMisandCreate(aplicationName):

    project1="mysqlwordpress"
    project2="wordpress"
    status = "false"
    versionProject=1.3


    amisMysql = os.popen("aws ec2 describe-images --owners self --filters '"'Name=tag:Name,Values=mysqlwordpress'"' '"'Name=tag:version,Values=1.3'"' --query "'"Images[].[ImageId]"'" --output text | grep -m5 '"'ami-'"'").readlines()
    # print(amisMysql)

    amisWordpress = os.popen("aws ec2 describe-images --owners self --filters '"'Name=tag:Name,Values='''+aplicationName+''''''"' '"'Name=tag:version,Values=1.3'"' --query "'"Images[].[ImageId]"'" --output text | grep -m5 '"'ami-'"'").readlines()
    # print(amisWordpress)

    if len(amisMysql) == 0:
        print("Criando AMI - Aguarde")
        make_packer = os.popen("cd ../packer/mysqlwordpress/ && make")
        # print(make_packer)
    else:
        print("ami existente")

    if len(amisWordpress) == 0:
            print("Criando AMI - Aguarde")
            make_packer = os.popen("cd ../packer/wordpress/ && make projectname="+aplicationName).readlines()
            # print(make_packer)

    else:
        print("ami existente")

def cloudAutomation(aplicationName , ambient , instance_type, number,action):

     if action == "create":
          verifyExistenceAMisandCreate(aplicationName)
          startInfra(aplicationName, ambient, instance_type, number)

     if action == "destroy":
        stopInfra(aplicationName,ambient,instance_type,number)

     else:
         print("Acao invalida")


def startInfra(aplicationName , ambient , instance_type, number):
    print("Start Wordpress")
    make_packer_wordpress = os.popen("cd ../terraform/wordpress/ && make projectname=""" + aplicationName+ " " + "instancetype="+instance_type + " " + "qnt="+number).readlines()
    # print(make_packer_wordpress)

    print("Start MYSQL")
    make_packer_mysql = os.popen("cd ../terraform/mysql-wordpress/ && make ").readlines()
    # print(make_packer_mysql)


def stopInfra(aplicationName , ambient , instance_type, number,instances):
    print("Start Wordpress")
    make_packer_wordpress = os.popen(
        "cd ../terraform/wordpress/ && make destroy projectname=""" + aplicationName + " " + "instancetype=" + instance_type + " " + "qnt=" + number).readlines()
    print(make_packer_wordpress)

    print("Start MYSQL")
    make_packer_mysql = os.popen("cd ../terraform/mysql-wordpress/ && make destroy").readlines()
    print(make_packer_mysql)



cloudAutomation("testedeverdade","dev","t2.micro","2","create")