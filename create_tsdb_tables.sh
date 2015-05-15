
#!/bin/bash

export COMPRESSION="NONE"
export HBASE_HOME=/opt/hbase
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk

cd /opt/opentsdb
./src/create_table.sh
touch /opt/opentsdb_tables_created.txt
