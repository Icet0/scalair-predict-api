#FROM heroku/miniconda# Grab requirements.txt.ADD ./webapp/requirements.txt /tmp/requirements.txt# Install dependenciesRUN pip install -qr /tmp/requirements.txt# Add our codeADD ./webapp /opt/webapp/WORKDIR /opt/webappRUN conda install scikit-learnRUN pip install pickle-mixinCMD gunicorn --bind 0.0.0.0:$PORT wsgi

FROM heroku/miniconda

# Grab requirements.txt.
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip install -qr /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

RUN conda install scikit-learn
RUN pip install pickle-mixin	

CMD gunicorn --bind 0.0.0.0:$PORT wsgi
