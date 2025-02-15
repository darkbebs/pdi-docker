FROM openjdk:8

# Set Environment Variables
ENV PDI_VERSION=7.1 PDI_BUILD=7.1.0.0-12 \
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data-integration \
	KETTLE_HOME=/data-integration

# Download PDI
RUN wget --progress=dot:giga https://trivio-arquivos.s3.amazonaws.com/pdi-ce-7.1.0.0-12.zip \
	&& unzip -q *.zip \
	&& rm -f *.zip \
	&& mkdir /jobs

# Aditional Drivers
WORKDIR $KETTLE_HOME

RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.27.jre7.jar \
	&& mv postgresql-42.2.27.jre7.jar lib/ 

# First time run
RUN pan.sh -file ./plugins/platform-utils-plugin/samples/showPlatformVersion.ktr \
	&& kitchen.sh -file samples/transformations/files/test-job.kjb

RUN apt-get update && apt-get install -y \
	postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install xauth
# RUN apt-get update && apt-get install -y xauth

#VOLUME /jobs
COPY . /jobs

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]