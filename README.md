opentsdb-docker
===============

Files required to make a trusted opentsdb Docker such that opentsdb can be tested easyer. This is based on petergrace/opentsdb-docker but rebuild to use centos7 docker image, removed serf for now, will add it back if needed

Notes
=====
 
 * If you need to ssh to the container, make sure to pass your ssh key into the run command, e.g. docker run -tiP -e "SSH_KEY=$(cat /root/.ssh/id_dsa.pub)" petergrace/opentsdb
   
