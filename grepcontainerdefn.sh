
echo "Getting Task defitions for $1"
y=0
for x in $(aws2 ecs list-tasks --cluster "$1" | sed 's/TASKARNS//g' | sed 's/ //g')
    do
        for i in $(aws2 ecs describe-tasks --cluster "$1" --tasks $x --output json | jq '.tasks[].taskDefinitionArn' | sed -e 's/"//' | sed -e 's/"//')  
            do 
                y=$((y+1))
                containerdefn=$(aws2 ecs describe-task-definition --task-definition $i --output json)
                name=$(aws2 ecs describe-task-definition --task-definition $i --output json | jq '."taskDefinition"."containerDefinitions"[].name' | sed -e 's/"//' | sed -e 's/"//')
                echo "Writing file for $name\n"
                echo $containerdefn | jsonpp >> ~/Scripts/"$name".json
                
            done
    done
