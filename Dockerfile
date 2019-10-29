FROM heroku/miniconda

# Grab requirements.txt.
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip install -qr /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/
WORKDIR /opt/

RUN conda install scikit-learn

CMD gunicorn --bind 0.0.0.0:$PORT wsgi
