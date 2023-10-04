## A simple `shell` utility that creates repositories in your SCM
---
1. Make sure SCM accounts have your valid ssh keys
2. Clone the repo. and go to the repostorm dir
3. Create iac-content dir. and put some iac into it
3. `chmod +x repostorm.sh`
4. Add/replace/modify the IaC contents in the repostorm-content folder
5. Run the utility as shown in the examples below

## Gitlab - Usage
* `./repostorm <repo_name> <group_id> <group_name> <repo_count_from> <repo_count_to> <personal_access_token>`
* Example: `./repostorm-gl.sh myTestRepo 12903634 group1 3 8 xSgCsR32yq-dfFViigHd5`
* This will create `private` repositories myTestRepo3, .. , myTestRepo8 in your gitlab account under group1

## Github - Usage
* `./repostorm <repo_name> <org_name> <repo_count_from> <repo_count_to> <personal_access_token>`
* Example: `./repostorm-gh.sh myTestRepo org1 3 8 xSgCsR32yq-dfFViigHd5`
* This will create `private` repositories myTestRepo3, .. , myTestRepo8 in your github account under org1

## Bitbucket - coming soon

### If you wish to keep changing the content in the `repostorm-content` folder after a few repos. are created
---
 \m/ Cheers \m/

_Spat!_