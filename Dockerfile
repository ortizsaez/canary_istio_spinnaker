FROM python:3.7.10
RUN pip3 install flask
RUN mkdir -p /python_server 

COPY python_server/webapp/* /python_server
#COPY templates /python_server
WORKDIR /python_server
EXPOSE 8080
CMD [ "python", "app.py" ]