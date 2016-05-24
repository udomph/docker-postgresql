FROM centos:6
MAINTAINER Udomph <elep.ls@gmail.com>

# Add necessary repository
RUN yum -y install http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-2.noarch.rpm

# Update OS
#RUN yum -y update

# Install PostgreSQL
RUN yum -y install postgresql94-server

# Set PostgreSQL Environment
RUN mkdir -p /app/pgdata
RUN mkdir -p /app/logs/pgsql
RUN chown postgres.postgres /app/pgdata
RUN chown postgres.postgres /app/logs/pgsql
RUN chmod 750 /app/pgdata
RUN chmod 750 /app/logs/pgsql
COPY postgresql-9.4 /etc/sysconfig/pgsql/postgresql-9.4

# Initial PostgreSQL 
RUN service postgresql-9.4 initdb
COPY pg_hba.conf /app/pgdata/pg_hba.conf
COPY postgresql.conf /app/pgdata/postgresql.conf
RUN chown postgres.postgres /app/pgdata/pg_hba.conf
RUN chown postgres.postgres /app/pgdata/postgresql.conf

# Post Install
RUN chkconfig iptables off
RUN chkconfig netfs off
RUN chkconfig restorecond off
RUN chkconfig postgresql-9.4 on
RUN yum clean all

# Running PostgreSQL Service
EXPOSE 5432
ENTRYPOINT ["/sbin/init"]
