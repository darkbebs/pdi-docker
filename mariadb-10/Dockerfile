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

RUN wget https://cdn.mysql.com/archives/mysql-connector-java-5.1/mysql-connector-java-5.1.49.zip \
	&& unzip -q mysql-connector-java-5.1.49.zip \
	&& rm -f mysql-connector-java-5.1.49.zip \
	&& mv mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar lib/

# First time run
RUN pan.sh -file ./plugins/platform-utils-plugin/samples/showPlatformVersion.ktr \
	&& kitchen.sh -file samples/transformations/files/test-job.kjb

RUN apt-get update && apt-get install -y \
	mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Install xauth
# RUN apt-get update && apt-get install -y xauth

#VOLUME /jobs
COPY . /jobs

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]