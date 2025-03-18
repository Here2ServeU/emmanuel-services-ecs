## Step 1: Build Backend and Frontend Images

- Go to the **ecs-cluster** directory.
```sh
cd ecs-cluster/
```
- Update the **build-push-backend.sh** and **build-push-frontend.sh** as desired.
- You define the **region, the ecr repo name, and account ID**. 

- Make the scripts executable.
```sh
chmod +x build-push-backend.sh
chmod +x build-push-frontend.sh
```

- Run the scripts. 
```sh
./build-push-backend.sh
./build-push-frontend.sh
```

---

## Step 2: 
