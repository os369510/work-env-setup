FROM base/archlinux

MAINTAINER os369510@gmail.com

ENV Contact=os369510@gmail.com

LABEL Owner=os369510

RUN pacman -Sy --needed --noconfirm \
	git make ctags awk gcc gdb vim man wget bc cscope minicom && \
	rm -rf /var/cache/pacman/pkg
