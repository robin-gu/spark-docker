#FROM ubuntu:16.04
FROM openjdk:8-jdk-alpine

#ENV JAVA_HOME		/usr/lib/jvm/java-8-openjdk-amd64

#ARG APT_MIRROR=archive.ubuntu.com
#RUN sed -i s/archive.ubuntu.com/$APT_MIRROR/g /etc/apt/sources.list

#RUN apt-get update -q && \
#    DEBIAN_FRONTEND=noninteractive apt-get install -qy openjdk-8-jdk && \
#    rm -rf /var/lib/apt/lists/*

####################
# HADOOP
####################

ENV HADOOP_VERSION	2.7.3
ENV HADOOP_HOME		/opt/hadoop
ENV HADOOP_OPTS		-Djava.library.path=/opt/hadoop/lib/native
ENV PATH		$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
#RUN apt-get update -q && \
#    DEBIAN_FRONTEND=noninteractive apt-get install -qy wget libssl-dev && \
RUN apk add --update --no-cache openssl ca-certificates bash && \
    update-ca-certificates && \
    wget -q https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -zxf /hadoop-$HADOOP_VERSION.tar.gz && \
    rm /hadoop-$HADOOP_VERSION.tar.gz && \
    mkdir -p /opt && \
    mv hadoop-$HADOOP_VERSION /opt/hadoop && \ 
    mkdir -p /opt/hadoop/logs

# Overwrite default HADOOP configuration files with our config files
COPY conf  $HADOOP_HOME/etc/hadoop/

# Formatting HDFS
RUN mkdir -p /data/dfs/data /data/dfs/name /data/dfs/namesecondary && \
    hdfs namenode -format
VOLUME /data


# Helper script for starting YARN
ADD start-yarn.sh /usr/local/bin/start-yarn.sh




#spark

#ENV SPARK_VERSION	2.0.0
#ENV HADOOP_VERSION_SHORT    2.7
#ENV SPARK_HOME		/opt/spark
#ENV PATH		$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

#RUN wget -q https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION_SHORT.tgz && \
#    tar -zxf /spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION_SHORT.tgz && \
#    rm /spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION_SHORT.tgz && \
#    mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION_SHORT /opt/spark && \
#    mkdir -p /opt/spark/logs
#
####################
# PORTS
####################
#
# http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.0/bk_HDP_Reference_Guide/content/reference_chap2.html
# http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cdh_ig_ports_cdh5.html
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

# HDFS: NameNode (NN):
#	 8020 = fs.defaultFS			(IPC / File system metadata operations)
#						(9000 is also frequently used alternatively)
#	 8022 = dfs.namenode.servicerpc-address	(optional port used by HDFS daemons to avoid sharing RPC port)
#       50070 = dfs.namenode.http-address	(HTTP  / NN Web UI)
#	50470 = dfs.namenode.https-address	(HTTPS / Secure UI)
# HDFS: DataNode (DN):
#	50010 = dfs.datanode.address		(Data transfer)
#	50020 = dfs.datanode.ipc.address	(IPC / metadata operations)
#	50075 = dfs.datanode.http.address	(HTTP  / DN Web UI)
#	50475 = dfs.datanode.https.address	(HTTPS / Secure UI)
# HDFS: Secondary NameNode (SNN)
#	50090 = dfs.secondary.http.address	(HTTP / Checkpoint for NameNode metadata)
EXPOSE 9000 8020 50070 50010 50020 50075 50090

CMD ["sh"]
