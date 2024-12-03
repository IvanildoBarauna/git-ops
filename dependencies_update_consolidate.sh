#!/bin/bash

# Nome da branch consolidada
CONSOLIDATED_BRANCH="dependabot/consolidated-update"

# Base para a branch consolidada
BASE_BRANCH="main"

# Checkout para a branch base
git checkout $BASE_BRANCH
git pull origin $BASE_BRANCH

# Criação da branch consolidada
git checkout -b $CONSOLIDATED_BRANCH

# Lista de branches do Dependabot
DEPENDABOT_BRANCHES=$(git branch -r | grep "origin/dependabot" | sed 's/origin\///')

for BRANCH in $DEPENDABOT_BRANCHES; do
    echo "Fazendo merge da branch $BRANCH..."
    git merge --no-ff --strategy-option theirs $BRANCH -m "Merge automático da branch $BRANCH para consolidar dependências"
    if [ $? -ne 0 ]; then
        echo "Erro inesperado ao fazer merge da branch $BRANCH."
        exit 1
    fi
done

# Push da branch consolidada
git push origin $CONSOLIDATED_BRANCH
echo "Atualizações do Dependabot consolidadas automaticamente na branch $CONSOLIDATED_BRANCH."
