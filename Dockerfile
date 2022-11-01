FROM python:3.9-buster

RUN apt-get update
RUN apt-get clean
RUN apt-get update && apt-get install nginx vim -y --no-install-recommends
COPY nginx.default /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /opt/app
RUN mkdir -p /opt/app/pip_cache
RUN mkdir -p /opt/app/martor_demo
COPY requirements.txt start-server.sh /opt/app/

COPY .pip_cache /opt/app/pip_cache/
COPY martor_demo /opt/app/martor_demo/
COPY martor_demo/martor_static /opt/app/martor_demo/martor_static
COPY martor_demo/martor_static /opt/app/martor_demo/static

WORKDIR /opt/app

RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt --cache-dir /opt/app/pip_cache
RUN chown -R www-data:www-data /opt/app
RUN apt-get -y install mc


EXPOSE 8020
STOPSIGNAL SIGTERM
CMD ["/opt/app/start-server.sh"]
