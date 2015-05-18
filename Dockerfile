#Basic update/upgrade/setup and install packages needed in other sections at once to save on number of apt-get instantiations

FROM centos:centos7
MAINTAINER Cristian Leonte <cristian.leonte@gmail.com>
#RUN yum -y -q update; yum clean all
RUN yum -y -q install epel-release; yum clean all
RUN yum -y groupinstall base
RUN yum -y -q install curl git python java-1.7.0-openjdk-devel  supervisor openssh-server automake gnuplot unzip tar make
RUN mkdir -p /opt/sei-bin/

#Install HBase and scripts
RUN mkdir -p /data/hbase
RUN mkdir -p /root/.profile.d
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
RUN git clone -b v2.0.1 --single-branch git://github.com/OpenTSDB/opentsdb.git /opt/opentsdb
RUN cd /opt/opentsdb && bash ./build.sh
ADD start_opentsdb.sh /opt/sei-bin/
ADD create_tsdb_tables.sh /opt/sei-bin/
EXPOSE 4242

#Install Supervisord
RUN mkdir -p /var/log/supervisor
ADD supervisor-hbase.ini /etc/supervisord.d/hbase.ini
ADD supervisor-system.ini /etc/supervisord.d/system.ini
ADD supervisor-tsdb.ini /etc/supervisord.d/tsdb.ini

#Configure SSHD properly
ADD supervisor-sshd.ini /etc/supervisord.d/sshd.ini
RUN mkdir -p /root/.ssh
RUN chmod 0600 /root/.ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g; s/#UsePAM no/UsePAM no/g;' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
RUN chown 0:0 /var/run/sshd
RUN chmod 0744 /var/run/sshd
ADD create_ssh_key.sh /opt/sei-bin/


#CMD ["/usr/bin/supervisord","-d","/etc/","-c", "/etc/supervisord.conf"]
