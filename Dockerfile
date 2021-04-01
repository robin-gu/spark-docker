FROM bitnami/spark:3.1.1-debian-10-r21
ADD https://github.com/tencentyun/hadoop-cos/releases/download/v5.9.3/hadoop-cos-3.1.0-5.9.3.jar /opt/bitnami/spark/jars/hadoop-cos-3.1.0-5.9.3.jar
ADD https://github.com/tencentyun/hadoop-cos/releases/download/v5.9.3/cos_api-bundle-5.6.35.jar /opt/bitnami/spark/jars/cos_api-bundle-5.6.35.jar
USER root
RUN chmod a+r  /opt/bitnami/spark/jars/cos_api-bundle-5.6.35.jar && \
    chmod a+r  /opt/bitnami/spark/jars/hadoop-cos-3.1.0-5.9.3.jar
USER 1001