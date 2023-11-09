FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -yq upgrade

RUN apt-get install -yq nginx curl wget qemu-system-arm

WORKDIR /app/

RUN curl https://github.com/tsl0922/ttyd/releases | grep -Po "https://.*expanded_assets[^\"]+" | head -1  | xargs curl | grep -Po "href=\"\K[^\"]+.$(uname -m)" | head -1 | xargs -I {} wget https://github.com{} -O ttyd && chmod +x ttyd

RUN rm -rf /etc/nginx/sites-enabled

COPY images/ .
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh .

EXPOSE 80

STOPSIGNAL SIGKILL
COPY ids.list .
RUN chown root:root ids.list
RUN chmod 400 ids.list

RUN chmod -R 444 Image rootfs.ext2 sd.img
RUN chmod 400 flag
RUN groupadd -g 2000 -o noone
RUN useradd -m -u 2000 -g 2000 -o -s /bin/bash noone

CMD ["./entrypoint.sh"]
