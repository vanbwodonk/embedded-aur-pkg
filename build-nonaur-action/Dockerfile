FROM archlinux:latest

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN date
RUN pacman-key --init
RUN pacman -Syu --noconfirm
RUN pacman -S base-devel git python nodejs yarn --noconfirm

COPY entrypoint.sh /entrypoint.sh

USER root

ENTRYPOINT ["/entrypoint.sh"]
