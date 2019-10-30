#FROM heroku/miniconda# Grab requirements.txt.ADD ./webapp/requirements.txt /tmp/requirements.txt# Install dependenciesRUN pip install -qr /tmp/requirements.txt# Add our codeADD ./webapp /opt/webapp/WORKDIR /opt/webappRUN conda install scikit-learnRUN pip install pickle-mixinCMD gunicorn --bind 0.0.0.0:$PORT wsgi
#Grab the latest alpine image
FROM alpine:latest

# Install python and pip
RUN apk add --no-cache --update python3 py3-pip bash
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt
RUN pip3 install --upgrade pip

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

RUN pip install scikit-learn
RUN pip install pickle-mixin	

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku			
CMD gunicorn --bind 0.0.0.0:$PORT wsgi 
