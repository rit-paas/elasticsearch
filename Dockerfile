FROM docker.io/openshift/base-centos7:latest
MAINTAINER Udo Urbantschitsch udo@urbantschitsch.com

LABEL io.openshift.tags java,java18,elasticsearch,elasticsearch172
LABEL io.k8s.description Elasticsearch Cluster Image
LABEL io.openshift.expose-services 9200/tcp:http,9300/tcp:cluster

RUN \
yum update -y && \
yum install -y iproute && \
yum install -y ruby && \
yum install -y java-1.8.0 && \
curl -O https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.0.0/elasticsearch-2.0.0.rpm && \
# curl -O https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.noarch.rpm && \
rpm -i elasticsearch-2.0.0.rpm && \
yum clean all && \
rm -f elasticsearch-2.0.0.rpm && \
ln -s /etc/elasticsearch /usr/share/elasticsearch/config && \
ln -s /usr/share/elasticsearch/bin/elasticsearch /bin/elasticsearch && \
chmod +x /bin/elasticsearch && \
chmod -R 777 /usr/share/elasticsearch && \
chmod -R 777 /etc/elasticsearch

COPY container-files /

ENV node_master true
ENV node_data true
ENV http_enabled true

EXPOSE 9200 9300

RUN useradd elastic

USER elastic

ENTRYPOINT /docker-entrypoint.sh
