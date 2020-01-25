FROM ubuntu:latest

RUN apt update
RUN apt dist-upgrade -y
RUN apt install -y apt-utils mesa-utils wget kmod
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
RUN apt install -y ./steam.deb

RUN echo 'deb [arch=amd64,i386] http://repo.steampowered.com/steam precise steam' > /etc/apt/sources.list.d/steam-inst.list \
	&& dpkg --add-architecture i386

RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes sudo libgl1-mesa-dri steam pulseaudio \
	&& rm -rf /etc/apt/sources.list.d/steam-inst.list \
	&& apt-get update \
	&& apt-get install -yq libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386 libnss3:i386 dbus:i386 \
	&& apt-get clean

## Sublime Text

RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - \
	&& sudo apt-get install -yq --no-install-recommends --force-yes apt-transport-https \
	&& echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list \
	&& sudo apt-get update \
	&& sudo apt-get install -yq --no-install-recommends --force-yes sublime-text

## Add user

RUN echo 'marlon ALL = NOPASSWD: ALL' > /etc/sudoers.d/marlon
RUN chmod 0440 /etc/sudoers.d/marlon
RUN adduser --uid=1000 --disabled-password marlon --gecos "Marlon"

## ENV

USER marlon
ENV HOME /home/marlon
#VOLUME /home/marlon
ENV PULSE_SERVER unix:/tmp/pulse
