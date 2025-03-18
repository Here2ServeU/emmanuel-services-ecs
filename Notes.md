
- Create the S3 Bucket for the state file. 
```sh
aws s3api create-bucket --bucket cc-tf-emmanuel --region us-east-1
```

- Create a DynamoDB Table for State file locking. 
```sh
aws dynamodb create-table \
    --table-name ccTfemmanuel \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
```

- Enable Versioning on the S3 Bucket
```sh
aws s3api put-bucket-versioning --bucket cc-tf-emmanuel --versioning-configuration Status=Enabled
```

- Move to the ecs-cluster directory, Initialize, Preview and Apply the Configurations
```sh
terraform init
terraform plan 
terraform apply -auto-approve
```

- Clean up
```sh
aws s3 rm s3://cc-tf-emmanuel --recursive
aws s3api delete-bucket --bucket cc-tf-emmanuel --region us-east-1

# To delete all Object versions
aws s3api list-object-versions --bucket cc-tf-emmanuel --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json | jq -c '.[]' | while read -r obj; do
    Key=$(echo $obj | jq -r '.Key')
    VersionId=$(echo $obj | jq -r '.VersionId')
    aws s3api delete-object --bucket cc-tf-emmanuel --key "$Key" --version-id "$VersionId"
done

aws s3api list-object-versions --bucket cc-tf-emmanuel --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json | jq -c '.[]' | while read -r obj; do
    Key=$(echo $obj | jq -r '.Key')
    VersionId=$(echo $obj | jq -r '.VersionId')
    aws s3api delete-object --bucket cc-tf-emmanuel --key "$Key" --version-id "$VersionId"
done

aws s3 ls s3://cc-tf-emmanuel --recursive  # To confirm the bucket is empty

aws dynamodb delete-table --table-name ccTfemmanuel --region us-east-1

aws ecr list-images --repository-name emmanuel-app-ecr-repo --region us-east-1 --query 'imageIds[*]' --output json

aws ecr batch-delete-image --repository-name emmanuel-app-ecr-repo --region us-east-1 --image-ids $(aws ecr list-images --repository-name emmanuel-app-ecr-repo --region us-east-1 --query 'imageIds[*]' --output json | jq -c '.[]')

# Install jq if not installed or run this command instead
IMAGES=$(aws ecr list-images --repository-name emmanuel-app-ecr-repo --region us-east-1 --query 'imageIds[*].imageDigest' --output text)
for image in $IMAGES; do
    aws ecr batch-delete-image --repository-name emmanuel-app-ecr-repo --region us-east-1 --image-ids imageDigest=$image
done 

aws ecr delete-repository --repository-name emmanuel-app-ecr-repo --region us-east-1 --force
```

### Docker Directory

- The /frontend/ directory
```sh
# Install Angular CLI
npm install -g @angular/cli

# Create a New Angular App
ng new angular-frontend --skip-git --directory .

# Add Home Component
ng generate component components/home
```

- Modify app.component.ts file and add the following: 
```typescript
import { Component } from '@angular/core';
import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  schemas: [CUSTOM_ELEMENTS_SCHEMA] // Allow unknown elements like web components
})
export class AppComponent { }
```

- Update the angular.json file to reflect the following: 
```json
"assets": [
    "src/favicon.ico",
    "src/assets"
]
```