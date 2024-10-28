# Ramyasahithya Magani - G01425752
# Arsitha Sathu - G01445215
# Athiksha Venkannagari - G01461169
# Sreshta Kosaraju - G01460468

# Dockerfile builds an Nginx image using Alpine, 
# and copies form.html and form.css into the Nginx directory. 
# It exposes port 80 and runs Nginx to serve the copied files.

FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY form.html /usr/share/nginx/html/
COPY form.css /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx","-g","daemon off;"]