FROM python:3-alpine

ENV PYTHONUNBUFFERED 1

RUN apk add bash libxml2 libxslt libffi libjpeg zlib expect 
RUN apk add tzdata unzip build-base libxml2-dev libxslt-dev libffi-dev libc-dev jpeg-dev zlib-dev postgresql-dev libpq

RUN mkdir /sopds
WORKDIR /sopds

#add fb2converter for epub and mobi - https://github.com/rupor-github/fb2converter
ADD scripts/fb2c_linux_i386.zip /fb2c_linux_i386.zip
ADD scripts/fb2conv /fb2conv
#
RUN mkdir -p /sopds/convert/fb2c
COPY requirements.txt /sopds/

RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN echo "Europe/Moscow" > /etc/timezone

RUN pip3 install --upgrade -r requirements.txt 

RUN unzip /fb2c_linux_i386.zip -d /sopds/convert/fb2c/ 
RUN rm /fb2c_linux_i386.zip 
RUN pip install toml-cli 
RUN /sopds/convert/fb2c/fb2c export /sopds/convert/fb2c/ 
RUN toml set --toml-path /sopds/convert/fb2c/configuration.toml logger.file.level none
RUN mv /fb2conv /sopds/convert/fb2c/fb2conv
RUN chmod +x /sopds/convert/fb2c/fb2conv 
RUN ln -sT /sopds/convert/fb2c/fb2conv /sopds/convert/fb2c/fb2epub
RUN ln -sT /sopds/convert/fb2c/fb2conv /sopds/convert/fb2c/fb2mobi
RUN apk del tzdata unzip build-base libxml2-dev libxslt-dev libffi-dev libc-dev jpeg-dev zlib-dev postgresql-dev 

RUN rm -rf /root/.cache/ 
RUN mkdir -p /sopds/tmp/ 
RUN chmod ugo+w /sopds/tmp/ 
#
ADD scripts/start.sh /sopds/scripts/start.sh
RUN chmod +x /sopds/scripts/start.sh 

EXPOSE 8001

ENTRYPOINT ["/sopds/scripts/start.sh"]
