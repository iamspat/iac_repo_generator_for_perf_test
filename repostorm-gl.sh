#!/bin/sh

repo_name=$1
group_id=$2
group_name=$3
repo_count_from=$4
repo_count_to=$5
token=$6

test -z $repo_name && echo "Usage: ./repostorm <repo_name> <group_id> <group_name> <repo_count_from> <repo_count_to> <personal_access_token> e.g. ./repostorm.sh testrepo 12903634 1 5 xSgCsR32yq-GDViigHd5" 1>&2 && exit 1
brew install jq >/dev/null 2>&1
for ((i = $repo_count_from; i <= $repo_count_to; i++)); do
    if [ -d "iac-content" ]; then
        echo "---------- Preparing Project $i ----------"
        # Create project. A repo. == Project in gitlab.
        project_id=$(curl --silent -H "Content-Type:application/json" https://gitlab.com/api/v4/projects?private_token=$token -d "{ \"name\": \"$repo_name$i\",\"visibility\": \"private\" }" | jq ".id")
        echo "Created project: $repo_name$i"
        echo "Transferring project to group: $group_name : "
        ssh_url=$(curl --silent -X PUT -H "PRIVATE-TOKEN: $token" "https://gitlab.com/api/v4/projects/$project_id/transfer?namespace=$group_id" | jq ".ssh_url_to_repo")
        echo "cloning repository..."
        git clone https://oauth2:$token@gitlab.com/$group_name/$repo_name$i.git
        echo "copying content..."
        cp -R iac-content/. "$repo_name$i" >/dev/null 2>&1
        cd "$repo_name$i" >/dev/null 2>&1 || exit
        echo "pushing content..."
        git init --initial-branch=main >/dev/null 2>&1
        git remote add origin git@gitlab.com:$group_name/"$repo_name$i".git >/dev/null 2>&1
        git add . >/dev/null 2>&1
        git commit -m "Initial commit" >/dev/null 2>&1
        git push -u origin main >/dev/null 2>&1
        echo "your repo. is ready - $ssh_url"
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
