FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY form.html /usr/share/nginx/html/
COPY form.css /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx","-g","daemon off;"]