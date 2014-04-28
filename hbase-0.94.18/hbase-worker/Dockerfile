# Spark
FROM htaox/hbase-base:0.94.18
MAINTAINER htaox htaox@hotmail.com

# Instead of using a random port, bind the worker to a specific port
#ENV SPARK_WORKER_PORT 8888
#EXPOSE 8888

ADD files /root/hbase_worker_files
RUN chmod 700 /root/hbase_worker_files/default_cmd
# Add the entrypoint script for the master
CMD ["-h"]
ENTRYPOINT ["/root/hbase_worker_files/default_cmd"]
