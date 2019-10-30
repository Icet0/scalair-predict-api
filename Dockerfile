FROM heroku/miniconda


# Grab requirements.txt.
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip install -qr /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

RUN pip install --upgrade pip
#RUN conda install numpy
#RUN conda install scipy
RUN sudo apt-get install python-numpy python-dev

RUN conda install scikit-learn
RUN conda install pandas
RUN pip install pickle-mixin
#RUN pip uninstall numpy
#RUN pip install numpy


CMD gunicorn --bind 0.0.0.0:$PORT wsgi
