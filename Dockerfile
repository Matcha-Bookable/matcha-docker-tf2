FROM ghcr.io/matcha-bookable/docker-tf2-server:latest
LABEL maintainer="avan"

ENV GH_PAT=""
ENV MATCHA_API_KEY=""

ADD ./sourcemod.sh ./matcha-build.sh ./matcha-runner.sh $SERVER/

RUN chmod +x $SERVER/sourcemod.sh $SERVER/matcha-build.sh $SERVER/matcha-runner.sh \
	&& $SERVER/sourcemod.sh \
	&& $SERVER/matcha-build.sh

EXPOSE 27015/udp 27015/tcp 27021/tcp 27020/udp

WORKDIR /home/$USER/hlserver

ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "1", "+map", "cp_process_f12", "+servercfgfile", "server.cfg", "+maxplayers", "24", "-enablefakeip"]