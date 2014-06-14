# HBase
FROM htaox/hbase-base:0.94.18
MAINTAINER htaox htaox@hotmail.com

ADD files /root/hbase_master_files
RUN chmod 700 /root/hbase_master_files/default_cmd
CMD ["/root/hbase_master_files/default_cmd"]
