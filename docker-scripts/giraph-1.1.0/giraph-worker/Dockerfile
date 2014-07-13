#Giraph
FROM htaox/giraph-base:1.1.0
MAINTAINER htaox htaox@hotmail.com

ADD files /root/giraph_worker_files
RUN chmod 700 /root/giraph_worker_files/default_cmd
# Add the entrypoint script for the master
CMD ["-h"]
ENTRYPOINT ["/root/giraph_worker_files/default_cmd"]
