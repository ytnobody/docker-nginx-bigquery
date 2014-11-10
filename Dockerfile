FROM ytnobody/ubuntu-jp:latest
MAINTAINER ytnobody <ytnobody@gmail.com>

RUN /usr/lib/fluent/ruby/bin/gem install fluent-plugin-bigquery --no-ri --no-rdoc
RUN /usr/lib/fluent/ruby/bin/gem install fluent-plugin-imkayac --no-ri --no-rdoc
RUN apt-get update && apt-get install nginx -y --force-yes

ADD td-agent/td-agent.conf /etc/td-agent/td-agent.conf
ADD bin/run /usr/local/bin/run
ADD bin/log-cleaner /usr/local/bin/log-cleaner

RUN chmod +x /usr/local/bin/run
RUN chmod +x /usr/local/bin/log-cleaner

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/run"]
