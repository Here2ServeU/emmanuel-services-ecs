
---

## Angular Project Structure
```plaintext
angular-frontend/
│── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── home/
│   │   │   │   ├── home.component.html
│   │   │   │   ├── home.component.ts
│   │   │   │   ├── home.component.css
│   ├── assets/
│   │   ├── images/
│   │   │   ├── emmanuel-thumbnail.jpg
│   ├── index.html
│── Dockerfile
│── package.json
│── angular.json
│── tsconfig.json
│── .dockerignore
```


⸻

1️⃣ Install Angular CLI

If you haven’t installed Angular CLI, install it globally:
```sh
npm install -g @angular/cli
```


⸻

2️⃣ Create a New Angular App

Run the following command to generate an Angular project:
```sh
npm init -y
npm install
ng new . --directory . --skip-install
```


⸻

3️⃣ Add Home Component

Run:
```sh
ng generate component components/home
```
This will generate:
```plaintext
src/app/components/home/
│── home.component.html
│── home.component.ts
│── home.component.css
```


⸻

4️⃣ Modify home.component.html

Replace contents of src/app/components/home/home.component.html with:
```html
<div class="header-container">
    <h1>Work with Emmanuel</h1>
</div>

<div class="container">
    <p class="bio">
        <strong>Emmanuel Naweji</strong> is a 
        <strong>Cloud, DevOps, and Infrastructure Specialist</strong> with 
        <strong>over 9 years</strong> of experience leading enterprise technology solutions.  
        He has worked with top companies like <strong>IBM, Comcast, and others</strong>,  
        helping businesses scale their cloud environments efficiently and securely.
    </p>

    <h3>Sign up below to work with Emmanuel.</h3>

    <img src="assets/images/emmanuel-thumbnail.jpg" alt="Emmanuel Naweji" class="profile-img">

    <form id="signupForm">
        <input type="text" id="firstName" name="firstName" placeholder="First Name" required>
        <input type="text" id="lastName" name="lastName" placeholder="Last Name" required>
        <input type="tel" id="phone" name="phone" placeholder="Phone Number" required>
        <input type="email" id="email" name="email" placeholder="Email Address" required>
        <select id="service" name="service" required>
            <option value="" disabled selected>Select a Service</option>
            <option value="Cloud Consulting">Cloud Consulting</option>
            <option value="DevOps Coaching">DevOps Coaching</option>
            <option value="IT Strategy">IT Strategy</option>
            <option value="Mentorship">Mentorship</option>
        </select>
        <button type="submit">Sign Up</button>
    </form>

    <div id="successMessage" class="success-message" style="display: none">
        Thank you for signing up! We will get in touch with you soon.
    </div>
</div>
```


⸻

5️⃣ Add Styling to home.component.css

Paste this in src/app/components/home/home.component.css:
```css
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: white;
}

.header-container {
    background-color: navy;
    color: white;
    text-align: center;
    padding: 30px 20px;
}

.profile-img {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    margin-top: 10px;
}

.container {
    max-width: 600px;
    margin: 30px auto;
    padding: 20px;
    background: white;
    border-radius: 8px;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    text-align: center;
}

.bio {
    font-size: 18px;
    color: black;
    padding: 10px;
    margin-bottom: 20px;
    line-height: 1.6;
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
}

input,
select {
    width: 90%;
    margin: 10px 0;
    padding: 12px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

button {
    width: 90%;
    background: navy;
    color: white;
    font-size: 18px;
    padding: 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    margin-top: 10px;
}

button:hover {
    background: #005bb5;
}

.success-message {
    font-size: 18px;
    color: #28a745;
    margin-top: 15px;
}
```


⸻

6️⃣ Modify app.component.html

Replace src/app/app.component.html with:
```html
<app-home></app-home>
```


⸻

7️⃣ Move Image to assets/images/

Create the folder:
```plaintext
src/assets/images/
```
Place emmanuel-thumbnail.jpg inside src/assets/images/.

⸻

8️⃣ Modify angular.json to Serve Static Assets

In angular.json, add:
```json
"assets": [
    "src/favicon.ico",
    "src/assets"
]
```

The script will look like this: 
```json
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "newProjectRoot": "projects",
  "projects": {
    "angular-frontend": {
      "projectType": "application",
      "schematics": {},
      "root": "",
      "sourceRoot": "src",
      "prefix": "app",
      "architect": {
        "build": {
          "builder": "@angular-devkit/build-angular:application",
          "options": {
            "outputPath": "dist/angular-frontend",
            "index": "src/index.html",
            "browser": "src/main.ts",
            "polyfills": [
              "zone.js"
            ],
            "tsConfig": "tsconfig.app.json",
            "assets": [
              "src/favicon.ico",
              "src/assets"
            ],
            "styles": [
              "src/styles.css"
            ],
            "scripts": [],
            "server": "src/main.server.ts",
            "outputMode": "server",
            "ssr": {
              "entry": "src/server.ts"
            }
          },
          "configurations": {
            "production": {
              "budgets": [
                {
                  "type": "initial",
                  "maximumWarning": "500kB",
                  "maximumError": "1MB"
                },
                {
                  "type": "anyComponentStyle",
                  "maximumWarning": "4kB",
                  "maximumError": "8kB"
                }
              ],
              "outputHashing": "all"
            },
            "development": {
              "optimization": false,
              "extractLicenses": false,
              "sourceMap": true
            }
          },
          "defaultConfiguration": "production"
        },
        "serve": {
          "builder": "@angular-devkit/build-angular:dev-server",
          "configurations": {
            "production": {
              "buildTarget": "angular-frontend:build:production"
            },
            "development": {
              "buildTarget": "angular-frontend:build:development"
            }
          },
          "defaultConfiguration": "development"
        },
        "extract-i18n": {
          "builder": "@angular-devkit/build-angular:extract-i18n"
        },
        "test": {
          "builder": "@angular-devkit/build-angular:karma",
          "options": {
            "polyfills": [
              "zone.js",
              "zone.js/testing"
            ],
            "tsConfig": "tsconfig.spec.json",
            "assets": [
              "src/favicon.ico",
              "src/assets"
            ],
            "styles": [
              "src/styles.css"
            ],
            "scripts": []
          }
        }
      }
    }
  },
  "cli": {
    "analytics": "b144866e-59ac-4cc9-a5ef-acfd5c0b4890"
  }
}
```


⸻

9️⃣ Build and Run Locally

Run:
```sh
ng serve --host 0.0.0.0 --port 8080
```

Visit:
```plaintext
http://localhost:8080
```


⸻

🔟 Create a Dockerfile

In the root directory (angular-frontend/), create a Dockerfile:
```sh
# Use Node.js as base image
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the app
COPY . .

# Build Angular app
RUN npm run build --configuration=production

# Use Nginx as a lightweight server
FROM nginx:alpine
COPY --from=build /app/dist/angular-frontend /usr/share/nginx/html

# Expose port 8080
EXPOSE 8080

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
```


⸻

🔟.1 Create .dockerignore
```plaintext
node_modules
dist
.git
.gitignore
Dockerfile
```

⸻

🔟.2 Build and Run Docker Container

Run:
```sh
docker build -t angular-frontend .
npm start
```

- The 'npm start' command will provide a URL, e.g.: http://localhost:4324


⸻

### Final Steps
- 1.	Push to AWS ECR
```sh
docker tag angular-frontend:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/angular-frontend:latest
docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/angular-frontend:latest
```

2.	Deploy to ECS
- Update ECS Task Definition to pull from:
```sh
<aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/angular-frontend:latest
```

- Set Container Port → 8080
- Attach ALB Target Group (if using Load Balancer)

⸻

### Summary

- Angular Frontend with Docker support
- Uses Port 8080
- Dockerfile for production build
- Deployable to AWS ECS with ALB
