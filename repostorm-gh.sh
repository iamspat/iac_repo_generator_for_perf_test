#!/bin/sh

repo_name=$1
org_name=$2
repo_count_from=$3
repo_count_to=$4
token=$5

test -z $repo_name && echo "Usage: ./repostorm <repo_name> <group_id> <group_name> <repo_count_from> <repo_count_to> <personal_access_token> e.g. ./repostorm.sh testrepo 12903634 1 5 xSgCsR32yq-GDViigHd5" 1>&2 && exit 1
brew install jq >/dev/null 2>&1
for ((i = $repo_count_from; i <= $repo_count_to; i++)); do
    if [ -d "iac-content" ]; then
        echo "---------- Preparing Repository $i ----------"
        curl -H "Authorization: token $token" --data '{"name":"'$repo_name$i'", "private":true}' https://api.github.com/orgs/$org_name/repos >/dev/null 2>&1
        echo "cloning repository..."
        git clone https://oauth2:$token@github.com/$org_name/$repo_name$i.git >/dev/null 2>&1
        echo "copying content to the new repository..."
        cp -R iac-content/. "$repo_name$i" >/dev/null 2>&1
        cd "$repo_name$i" >/dev/null 2>&1 || exit
        echo "pushing content..."
        git init --initial-branch=main >/dev/null 2>&1
        git remote add origin git@github.com:$org_name/"$repo_name$i".git >/dev/null 2>&1
        git add . >/dev/null 2>&1
        git commit -m "Initial commit" >/dev/null 2>&1
        git push -u origin main >/dev/null 2>&1
        echo "your repo. is ready - https://github.com/$org_name/$repo_name$i"
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
