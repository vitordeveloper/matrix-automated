import os

def verifyExistenceAMis():

    project1="mysqlwordpress"
    project2="wordpress"
    status = "false"
    versionProject=1.3


    amisMysql = os.system("aws ec2 describe-images --owners self --filters '"'Name=tag:Name,Values=mysqlwordpress'"' '"'Name=tag:version,Values=1.4'"' --query "'"Images[].[ImageId]"'" --output text | grep -m5 '"'ami-'"'")
    amisWordpress = os.system("aws ec2 describe-images --owners self --filters '"'Name=tag:Name,Values=wordpress'"' '"'Name=tag:version,Values=1.3'"' --query "'"Images[].[ImageId]"'" --output text | grep -m5 '"'ami-'"'")
    print(amisMysql)
    print(amisWordpress)

    if len(amisMysql) == 0:
        print("vazio")
    else:
        print("cheio")




