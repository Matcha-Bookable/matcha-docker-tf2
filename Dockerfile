FROM ubuntu:22.04
LABEL maintainer="avan"

RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
	&& echo steam steam/license note '' | debconf-set-selections \
	&& apt-get -y update \
	&& apt-get -y install software-properties-common \
	&& add-apt-repository multiverse \
	&& dpkg --add-architecture i386 \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install libstdc++6 libcurl3-gnutls wget libncurses5 bzip2 unzip vim nano lib32gcc-s1 lib32stdc++6 steamcmd  \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates \
		lib32z1 \
		libncurses5:i386 \
		libbz2-1.0:i386 \
		libtinfo5:i386 \
		libcurl3-gnutls:i386 \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& useradd -m tf2 \
	&& su tf2 -c '/usr/games/steamcmd +quit'

USER tf2

ENV USER tf2
ENV HOME /home/$USER
ENV SERVER $HOME/hlserver

ADD --chown=tf2:tf2 tf2_ds.txt update.sh matcha.sh update-matcha.sh maps.sh sourcemod.sh clean.sh tf.sh $SERVER/
RUN chmod +x $SERVER/update.sh \
    $SERVER/clean.sh \
    $SERVER/maps.sh \
    $SERVER/sourcemod.sh \
    $SERVER/matcha.sh \
    $SERVER/update-matcha.sh \
    $SERVER/tf.sh

RUN mkdir -p $SERVER/tf2 \
	&& ln -s /usr/games/steamcmd $SERVER/steamcmd.sh \
	&& $SERVER/update.sh \
	&& $SERVER/clean.sh \
    && $SERVER/maps.sh \
    && $SERVER/sourcemod.sh \
    && $SERVER/matcha.sh

# ------------------ STOCK SETUP ENDS -------------------

USER root

# Build arguments and environment variables
ARG GH_PAT
ARG MATCHA_API_KEY
ARG MATCHA_API_DETAILS_URL

ENV GH_PAT=${GH_PAT} \
    MATCHA_API_KEY=${MATCHA_API_KEY} \
    MATCHA_API_DETAILS_URL=${MATCHA_API_DETAILS_URL}

# Install dependencies and copy scripts
RUN apt-get update && apt-get install -y git curl

USER tf2

EXPOSE 27015/udp 27015/tcp 27021/tcp 27020/udp

WORKDIR /home/$USER/hlserver

ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "1", "+map", "cp_process_f12", "+servercfgfile", "server.cfg", "+maxplayers", "24", "-enablefakeip"]