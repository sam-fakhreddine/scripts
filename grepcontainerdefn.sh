
echo "Getting Task defitions for $1"

y=0
for x in $(aws2 ecs list-tasks --cluster "$1" | sed 's/TASKARNS//g' | sed 's/ //g')
    do
        for i in $(aws2 ecs describe-tasks --cluster "$1" --tasks $x --output json | jq '.tasks[].taskDefinitionArn' | sed -e 's/"//' | sed -e 's/"//')  
            do 
                y=$((y+1))
                taskdefn=$(aws2 ecs describe-task-definition --task-definition $i --output json)
                containerdefn=$(aws2 ecs describe-task-definition --task-definition $i --output json | jq '."taskDefinition"."containerDefinitions"[]')
                name=$(aws2 ecs describe-task-definition --task-definition $i --output json | jq '."taskDefinition"."containerDefinitions"[].name' | sed -e 's/"//' | sed -e 's/"//')
                if test -f ~/Scripts/outputs/$(date +%F)/"$name".json; then 
                continue
                else
                    echo "Writing file for $name\n"
                    mkdir -p ~/Scripts/outputs/$(date +%F)/
                    echo $taskdefn | jsonpp > ~/Scripts/outputs/$(date +%F)/"$name".json
                    sed '3d;2d;$d' ~/Scripts/outputs/$(date +%F)/"$name".json > ~/Scripts/outputs/$(date +%F)/"$name"-temp.json && mv ~/Scripts/outputs/$(date +%F)/"$name"-temp.json ~/Scripts/outputs/$(date +%F)/"$name".json
                    jq -c 'del(.requiresAttributes)' ~/Scripts/outputs/$(date +%F)/"$name".json > tmp.$$.json && mv tmp.$$.json ~/Scripts/outputs/$(date +%F)/"$name".json
                    jq -c 'del(.compatibilities)' ~/Scripts/outputs/$(date +%F)/"$name".json > tmp.$$.json && mv tmp.$$.json ~/Scripts/outputs/$(date +%F)/"$name".json
                    jq -c 'del(.status)' ~/Scripts/outputs/$(date +%F)/"$name".json > tmp.$$.json && mv tmp.$$.json ~/Scripts/outputs/$(date +%F)/"$name".json
                    jq -c 'del(.revision)' ~/Scripts/outputs/$(date +%F)/"$name".json > tmp.$$.json && mv tmp.$$.json ~/Scripts/outputs/$(date +%F)/"$name".json
                    jsonpp ~/Scripts/outputs/$(date +%F)/"$name".json > tmp.$$.json && mv tmp.$$.json ~/Scripts/outputs/$(date +%F)/"$name".json
                fi
            done
    done
