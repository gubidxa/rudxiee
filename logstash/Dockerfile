FROM docker.elastic.co/logstash/logstash:8.1.2
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
# Download JDBC connector for Logstash
RUN curl -L --output "mysql-connector-java-8.0.28.tar.gz" "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.28.tar.gz" \
    && tar -xf "mysql-connector-java-8.0.28.tar.gz" "mysql-connector-java-8.0.28/mysql-connector-java-8.0.28.jar" \
    && mv "mysql-connector-java-8.0.28/mysql-connector-java-8.0.28.jar" "mysql-connector-java-8.0.28.jar" \
    && rm -r "mysql-connector-java-8.0.28" "mysql-connector-java-8.0.28.tar.gz"
RUN bin/logstash-plugin install logstash-output-opensearch

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]