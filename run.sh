#!/bin/bash
echo -e 'Em qual ambiente deseja executar o projeto: '
echo -e '\t1. Local'
echo -e '\t2. DEV (Disabled)'
echo -e '\t3. UAT (Disabled)'
echo -e '\t4. PRD'
echo -e '\t0. Sair'

function checkProdServer(){
    HOST=`cat inventory-prd | grep \<SERVER_HOST\>`
    USER_SSH=`cat inventory-prd | grep \<USERNAME\>`
    if [ ! -z "$HOST" ] || [ ! -z "$USER_SSH" ]; then
        echo -e '\n[ERROR] Dados do servidor de produção não encontrados'
        echo -e 'Informe os dados do servidor de produção:'
        printf '\t1. IP ou Host: ' && read -p "" SERVER_HOST
        printf '\t1. Usuario SSH: ' && read -p "" USERNAME_SSH
        sed -i '' "s/\<SERVER_HOST\>/${SERVER_HOST}/g" inventory-prd
        sed -i '' "s/\<USERNAME\>/${USERNAME_SSH}/g" inventory-prd
    fi
}

while true; do
    read -p "Digite uma das opções acima: " option
    case $option in
        1)
            ansible-playbook -i inventory-local -vv --ask-sudo-pass --extra-vars="@extra-vars.yml" install.yml
            break;;
        4)
            checkProdServer
            ansible-playbook -i inventory-prd -vv --ask-sudo-pass --extra-vars="@extra-vars.yml" install.yml
            git checkout inventory-prd
            break;;
        0)
            exit;;
        * )
            echo "Opção inválida";;
    esac
done