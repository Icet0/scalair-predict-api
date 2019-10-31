#FROM heroku/miniconda# Grab requirements.txt.ADD ./webapp/requirements.txt /tmp/requirements.txt# Install dependenciesRUN pip install -qr /tmp/requirements.txt# Add our codeADD ./webapp /opt/webapp/WORKDIR /opt/webappRUN conda install scikit-learnRUN pip install pickle-mixinCMD gunicorn --bind 0.0.0.0:$PORT wsgi
FROM heroku/cedar:14

ENV PORT 3000
# Which version of Python?
ENV PYTHON_VERSION python-3.4.2

# Add Python binaries to path.
ENV PATH /app/.heroku/python/bin/:$PATH

# Create some needed directories
RUN mkdir -p /app/.heroku/python /app/.profile.d
RUN apt-get update -y && \
    apt-get install -y python-pip python-dev
# Grab requirements.txt.
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip install -qr /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

RUN pip install scikit-learn
RUN pip install pickle-mixin	

CMD gunicorn --bind 0.0.0.0:$PORT wsgi
