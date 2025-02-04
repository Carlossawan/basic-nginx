# Use the official lightweight Nginx image
FROM nginx:alpine

# Copy the local files to Nginx's default public directory
COPY . /usr/share/nginx/html
