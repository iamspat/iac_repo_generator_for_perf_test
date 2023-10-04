#!/bin/bash

user_name=$1
repo_name=$2
org_name=$3
project_name=$4
repo_count_from=$5
repo_count_to=$6
token=$7

test -z $repo_name && echo "Usage: ./repostorm <repo_name> <org_name> <project_name> <repo_count_from> <repo_count_to> <personal_access_token> e.g. ./repostorm.sh testrepo 12903634 1 5 xSgCsR32yq-GDViigHd5" 1>&2 && exit 1
brew install jq >/dev/null 2>&1
for ((i = $repo_count_from; i <= $repo_count_to; i++)); do
    if [ -d "iac-content" ]; then
        ## Create a new repository
        PROJECT_ID=$(curl -s -u $user_name:$token https://dev.azure.com/$org_name/_apis/projects?api-version=6.0 | jq -r '.value[] | select(.name == "'$project_name'") | .id') &&
        # Create a Repo
        echo "creating repo $repo_name$i.."
        curl -s --request POST -u $user_name:$token --data '{"name": "'"$repo_name$i"'","project": {"id": "'"$PROJECT_ID"'"}}' https://dev.azure.com/$org_name/$project_name/_apis/git/repositories?api-version=6.0 -H "Content-Type: application/json" >/dev/null 2>&1
        # Clone Repo
        echo "cloning repo $repo_name$i.."
        git clone git@ssh.dev.azure.com:v3/$org_name/$project_name/$repo_name$i >/dev/null 2>&1
        echo "copying content..."
        cp -R iac-content/. "$repo_name$i" >/dev/null 2>&1
        cd "$repo_name$i" >/dev/null 2>&1 || exit
        echo "pushing content..."
        # git init >/dev/null 2>&1
        # git remote add origin https://$org_name@dev.azure.com/$project_name/_git/$repo_name$i
        git add . >/dev/null 2>&1
        git commit -m "Initial commit" >/dev/null 2>&1
        git push -u origin master >/dev/null 2>&1
        echo "your repo. is ready"
        echo "deleting local code..."
        cd ..
        rm -rf "$repo_name$i"
        echo "---------------------------------------------"
    else
        echo "ERR: Looks like somebody forgot to create iac-content dir and put some iac into it!!"
        exit 1
    fi
done

#Delete Project
#curl -X DELETE -h "content-Type:application/json" https://gitlab.com/api/v4/projects/$project_id?private_token=$token
