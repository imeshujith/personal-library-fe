# Use the official Node.js image from the Docker Hub to build the React app
FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json into the container
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Use a lightweight NGINX server to serve the React app
FROM nginx:alpine

# Copy the custom NGINX config file to the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the build files from the React build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port that NGINX will serve the app on
EXPOSE 80

# Command to run NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
