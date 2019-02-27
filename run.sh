#!/bin/bash
echo -e 'Em qual ambiente deseja executar o projeto: '
echo -e '\t1. Local'
echo -e '\t2. DEV (Disabled)'
echo -e '\t3. UAT (Disabled)'
echo -e '\t4. PRD'
echo -e '\t0. Sair'

while true; do
    read -p "Digite uma das opções acima: " option
    case $option in
        1)
            ansible-playbook -i inventory-local -vv --ask-sudo-pass --extra-vars="@extra-vars.yml" install.yml
            break;;
        4)
            ansible-playbook -i inventory-prd -vv --ask-sudo-pass --extra-vars="@extra-vars.yml" install.yml
            break;;
        0)
            exit;;
        * )
            echo "Opção inválida";;
    esac
done