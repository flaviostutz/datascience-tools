FROM tensorflow/tensorflow:1.0.0-py3
#FROM tensorflow/tensorflow:1.0.0.2-gpu-py3

RUN apt-get update && \
    apt-get install git -y

#PROCESSING
RUN pip install scoop

#DATA
RUN pip install h5py && \
    pip install pyexcel-ods && \
    pip install pandas-profiling && \
    pip install sklearn-pandas

#LEARNING
RUN apt-get install pandoc -y && pip install pypandoc && pip install deap && \
    pip install git+https://github.com/tflearn/tflearn.git && \
    pip install tpot && \
    pip install heamy

#IMAGE
RUN pip install pydicom && \
    pip install scikit-image && \
    pip install opencv-python && \
    pip install ImageHash && \
    apt-get install libav-tools -y && \
    apt-get install imagemagick -y

#GRAPHING
RUN pip install plotly && \
#    pip install python-igraph && \
    pip install altair && \
    pip install git+https://github.com/jakevdp/JSAnimation.git

#GEO
RUN pip install Geohash && \
    pip install mplleaflet && \
    apt-get install libgeos-dev -y

#TEXT PROCESSING
RUN pip install textblob && \
    pip install git+git://github.com/amueller/word_cloud.git && \
    pip install toolz cytoolz

#MISC
RUN pip install wavio && \
    pip install trueskill

#CLEANUP
RUN rm -rf /root/.cache/pip/* && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /usr/local/src/*

RUN apt-get install supervisor -y

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
