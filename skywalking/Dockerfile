FROM apache/skywalking-oap-server:8.5.0-es7


RUN wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.25/mysql-connector-java-8.0.25.jar -O /skywalking/oap-libs/mysql-connector-java-8.0.25.jar





# docker run --name skywalking-oap-server \
# -p 1234:1234 -p 11800:11800 -p 12800:12800 \
# -e SW_STORAGE=mysql -e SW_JDBC_URL="jdbc:mysql://10.43.153.4:4000/skywalking?useSSL=false" -e SW_DATA_SOURCE_USER=root -e SW_DATA_SOURCE_PASSWORD=""\
# -e SW_DATA_SOURCE_CACHE_PREP_STMTS="true" \
# -e SW_DATA_SOURCE_PREP_STMT_CACHE_SQL_SIZE=250 \
# -e SW_DATA_SOURCE_PREP_STMT_CACHE_SQL_LIMIT=2048 \
# -e SW_DATA_SOURCE_USE_SERVER_PREP_STMTS="true" \
# -e SW_STORAGE_MYSQL_QUERY_MAX_SIZE=5000 \
# test