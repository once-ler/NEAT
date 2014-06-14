#HBase
FROM htaox/faunus-base:0.4.4
MAINTAINER htaox htaox@hotmail.com

ADD files /root/faunus_worker_files
RUN chmod 700 /root/faunus_worker_files/default_cmd
CMD ["/root/faunus_worker_files/default_cmd"]
