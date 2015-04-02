
# Deployment commands

To begin a deploy: 

    `ansible-playbook deploy.yml -i host-list.ini --ask-vault-pass -v -K`

where:

    * `-K` asks for the sudo password.
    * `-i` specifies the target host(s)
    * `deploy.yml` is the top level deployment file

