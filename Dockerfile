FROM nginx:stable-alpine

# Copy the built Ember app from your local machine into the NGINX container
COPY ./dist /usr/share/nginx/html

# Optionally: Copy your custom NGINX config if needed
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
