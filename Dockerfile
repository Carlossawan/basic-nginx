# Use the official NGINX image (Alpine-based for a smaller footprint)
FROM nginx:alpine

# Copy the static files (index.html and picture.jpg) to the NGINX document root
COPY index.html /usr/share/nginx/html/index.html
COPY picture.jpg /usr/share/nginx/html/picture.jpg

# Expose port 80 (NGINX listens on port 80 by default)
EXPOSE 80
