FROM heroku/miniconda

# Grab requirements.txt.
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip install -qr /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

RUN conda install -c conda-forge numpy
RUN conda install scipy
RUN conda install scikit-learn
RUN conda install pandas
RUN pip install pickle-mixin


CMD gunicorn --bind 0.0.0.0:$PORT wsgi
