import os,sys,webbrowser




def verifyExistenceAMisandCreate(aplicationName):

    project1="mysqlwordpress"
    project2="wordpress"
    status = "false"
    versionProject=1.3


    amisMysql = os.popen("aws ec2 describe-images --owners self --filters '"'Name=tag:Name,Values=mysqlwordpress'"' '"'Name=tag:version,Values=1.3'"' --query "'"Images[].[ImageId]"'" --output text | grep -m5 '"'ami-'"'").readlines()
    # print(amisMysql)

    amisWordpress = os.popen("aws ec2 describe-images --owners self --filters '"'Name=tag:Name,Values='''+aplicationName +''''''"' '"'Name=tag:version,Values=1.3'"' --query "'"Images[].[ImageId]"'" --output text | grep -m5 '"'ami-'"'").readlines()
    # print(amisWordpress)

    if len(amisMysql) == 0:
        print("Criando AMI - Aguarde")
        make_packer = os.popen("cd ../packer/mysqlwordpress/ && make")

    else:
        print("ami existente")

    if len(amisWordpress) == 0:
            print("Criando AMI - Aguarde")
            make_packer = os.popen("cd ../packer/wordpress/ && make projectname="+aplicationName).readlines()

    else:
        print("ami existente")

def cloudAutomation(aplicationName , ambient , instance_type, number,action):

     if action == "create":
          verifyExistenceAMisandCreate(aplicationName)
          startInfra(aplicationName, ambient, instance_type, number)

     if action == "destroy":
        stopInfra(aplicationName,ambient,instance_type,number)

def startInfra(aplicationName , ambient , instance_type, number):
    print("Start MYSQL")
    make_packer_mysql = os.popen("cd ../terraform/mysql-wordpress/ && make ").readlines()


    print("Start Wordpress")
    make_packer_wordpress = os.popen("cd ../terraform/wordpress/ && make projectname=""" + aplicationName+ " " + "instancetype="+instance_type + " " + "qnt="+number +" " + "enviroment="+ambient ).readlines()
    make_packer_wordpress = str(make_packer_wordpress)

    posout = make_packer_wordpress.find("Outputs")
    output = make_packer_wordpress[posout:]
    outs = output.split(' , ')
    for outputs in outs:
        ips = outputs.find("instances_ips")
        loadbalancer = outputs.find("loadbalancer_dns")

        ips_instances = outputs[ips:loadbalancer]
        dns_loadbalancer = outputs[loadbalancer:]
        ips_instances = ips_instances.strip("\n ', '")
        ipToInstall = ips_instances.split('=')[1].split(" ")[1]

        dns_loadbalancer = dns_loadbalancer.strip("']\n")
        endLoadBalancer = dns_loadbalancer.split('=')[1]

        ipToInstall = "http://" + ipToInstall + ":8000"
        endLoadBalancer = "http://" + endLoadBalancer.strip(" ")

        webbrowser.open_new(ipToInstall)

        print("Primeiro uso por favor realizar a instalacao: " + ipToInstall)

        print("Endereco ELB utilizar apos a instalacao: " + endLoadBalancer)




def stopInfra(aplicationName , ambient , instance_type, number):
    print("Stopping Wordpress ...")
    make_packer_wordpress = os.popen(
        "cd ../terraform/wordpress/ && make destroy projectname=""" + aplicationName + " " + "instancetype=" + instance_type + " " + "qnt=" + number +" " + "enviroment="+ambient ).readlines()


    print("Stopping MYSQL ...")
    make_packer_mysql = os.popen("cd ../terraform/mysql-wordpress/ && make destroy").readlines()



def main(aplicationName, ambient, instance_type, number, action):
    cloudAutomation(aplicationName, ambient, instance_type, number, action)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
