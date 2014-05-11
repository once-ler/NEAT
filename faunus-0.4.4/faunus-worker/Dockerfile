#HBase
FROM htaox/faunus-base:0.4.4
MAINTAINER htaox htaox@hotmail.com

ADD files /root/hbase_worker_files
RUN chmod 700 /root/hbase_worker_files/default_cmd
# Add the entrypoint script for the worker
CMD ["/root/hbase_worker_files/default_cmd"]
