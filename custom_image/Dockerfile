
FROM openmsi/openmsistream:latest
ARG ROOT=/home/openmsi

WORKDIR ${ROOT}
ADD --chown=openmsi:openmsi --chmod=777 ../config.config config.config
ADD --chown=openmsi:openmsi --chmod=777 startup-script.sh startup-script.sh

RUN pip install pymatgen \
    && pip install numpy \
    && pip install pandas \
    && pip install scipy \
    && pip install matplotlib \
	&& pip install opencv-python \
    && pip install ipython \
    && pip install matplotlib \
    && pip install regex 

USER root
RUN  apt-get install ffmpeg libsm6 libxext6 -y

USER openmsi
ENTRYPOINT . ./startup-script.sh 