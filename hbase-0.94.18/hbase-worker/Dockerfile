#HBase
FROM htaox/hbase-base:0.94.18
MAINTAINER htaox htaox@hotmail.com

ADD files /root/hbase_worker_files
RUN chmod 700 /root/hbase_worker_files/default_cmd
# Add the entrypoint script for the master
CMD ["-h"]
ENTRYPOINT ["/root/hbase_worker_files/default_cmd"]
