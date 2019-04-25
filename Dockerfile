FROM tensorflow/tensorflow:2.0.0a0-py3-jupyter
# FROM flaviostutz/datascience-tools:2.0.0

RUN apt-get update && \
    apt-get install git -y

RUN pip install --upgrade pip

#PROCESSING
RUN pip install scoop && \
    pip install multiprocessing_generator

#GRAPHING
RUN pip install plotly && \
#    pip install python-igraph && \
    pip install seaborn && \
    pip install altair && \
    pip install git+https://github.com/jakevdp/JSAnimation.git && \
    pip install bokeh

#TEXT PROCESSING
RUN pip install textblob && \
    pip install git+git://github.com/amueller/word_cloud.git && \
    pip install toolz cytoolz && \
    pip install gensim && \
    pip install PyPDF2 && \
    pip install slate3k && \
    pip install bs4
RUN python -c "import nltk; nltk.download('punkt')"
RUN python -c "import nltk; nltk.download('rslp')"
RUN python -c "import nltk; nltk.download('stopwords')"
RUN python -c "import nltk; nltk.download('floresta')"
RUN python -c "import nltk; nltk.download('all-corpora')"

#DATA
RUN pip install h5py && \
    pip install pyexcel-ods && \
    pip install pandas-profiling && \
    pip install sklearn-pandas

#IMAGE
RUN pip install pydicom && \
    pip install --trusted-host itk.org -f https://itk.org/SimpleITKDoxygen/html/PyDownloadPage.html SimpleITK && \
    pip install scikit-image && \
    pip install opencv-python && \
    pip install ImageHash && \
    apt-get install libav-tools -y && \
    apt-get install imagemagick -y && \
    pip install git+https://github.com/danoneata/selectivesearch.git

#LEARNING
RUN apt-get install pandoc -y && pip install pypandoc && pip install deap && \
    pip install git+https://github.com/tflearn/tflearn.git && \
    pip install scipy && \
    pip install scikit-learn && \
    pip install tpot && \
    pip install heamy

#MISC
RUN pip install wavio && \
    pip install trueskill && \
    pip install papermill

#GEO
RUN pip install Geohash && \
    pip install mplleaflet && \
    pip install shapely && \
    pip install geopandas && \
    pip install descartes && \
    pip install rasterio && \
    pip install rasterstats && \
    pip install folium && \
    pip install pyepsg && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
    apt update && \
    apt-get install libproj-dev libgeos-dev -y && \
    apt-get install -y gdal-bin python-gdal python3-gdal && \
    pip install mgrspy && \
    pip install git+https://github.com/flaviostutz/sentinelloader && \
    apt-get install -y libspatialindex-dev && \
    pip install rtree && \
    pip uninstall -y pyepsg && \
    pip install git+https://github.com/flaviostutz/pyepsg && \
    pip install cartopy

#SPARK DRIVER
# RUN apt-get install openjdk-8-jdk -y
# RUN curl https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz --output /tmp/spark-2.3.0-bin-hadoop2.7.tgz
# RUN cd /tmp && tar -xzf spark-2.3.0-bin-hadoop2.7.tgz && \
#     mv spark-2.3.0-bin-hadoop2.7 /opt/spark-2.3.0 && \
#     ln -s /opt/spark-2.3.0 /opt/spark̀
# RUN pip install findspark
# ENV SPARK_MASTER ''

#CLEANUP
RUN rm -rf /root/.cache/pip/* && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /usr/local/src/*

RUN mkdir -p /notebooks/data/input
RUN mkdir -p /notebooks/data/output

#SUPERVISOR FOR MULTIPLE PROCESSES
RUN apt-get install supervisor -y
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD /start-jupyter.sh /

CMD ["/usr/bin/supervisord"]
