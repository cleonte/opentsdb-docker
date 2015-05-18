#Basic update/upgrade/setup and install packages needed in other sections at once to save on number of apt-get instantiations

FROM centos:centos7
MAINTAINER Cristian Leonte <cristian.leonte@gmail.com>
RUN yum -y -q update
RUN yum -y -q install epel-release  &&  yum -y -q install \
    automake \
    curl \
    git  \
    gnuplot \
    java-1.7.0-openjdk-devel \
    make \
    python \
    supervisor \
    tar\
    unzip \

RUN mkdir -p /opt/sei-bin/

#Install HBase and scripts
RUN mkdir -p /data/hbase

WORKDIR /opt
ADD http://apache.org/dist/hbase/hbase-0.94.27/hbase-0.94.27.tar.gz /opt/downloads/
RUN tar xzvf /opt/downloads/hbase-*gz && rm /opt/downloads/hbase-*gz
RUN ["/bin/bash","-c","mv hbase-* /opt/hbase"]
ADD start_hbase.sh /opt/sei-bin/
ADD hbase-site.xml /opt/hbase/conf/
EXPOSE 60000
EXPOSE 60010
EXPOSE 60030

#Install OpenTSDB and scripts
RUN git clone -b tts_maintenance_v1.1.0 --single-branch https://github.com/toraTSD/opentsdb.git /opt/opentsdb
RUN cd /opt/opentsdb && bash ./build.sh
ADD start_opentsdb.sh /opt/sei-bin/
ADD create_tsdb_tables.sh /opt/sei-bin/
EXPOSE 4242

#Install Supervisord
RUN mkdir -p /var/log/supervisor
ADD supervisor-hbase.ini /etc/supervisord.d/hbase.ini
ADD supervisor-system.ini /etc/supervisord.d/system.ini
ADD supervisor-tsdb.ini /etc/supervisord.d/tsdb.ini

CMD ["/usr/bin/supervisord","-d","/etc/","-c", "/etc/supervisord.conf"]
