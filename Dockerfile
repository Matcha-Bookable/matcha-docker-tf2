FROM ghcr.io/matcha-bookable/docker-tf2-server:latest
LABEL maintainer="avan"

USER root
RUN apt update
RUN apt-get install -y python3 python3-pip curl && \
    pip install requests

USER tf2
ENV GH_PAT=""
ENV MATCHA_API_KEY=""

ADD --chown=tf2:tf2 ./sourcemod.sh ./matcha-build.sh ./matcha-runner.sh ./webhook_server.py ./tf.sh ./parse_demo $SERVER/

RUN chmod +x $SERVER/sourcemod.sh \
	$SERVER/matcha-build.sh \
	$SERVER/matcha-runner.sh \
	$SERVER/tf.sh \
	$SERVER/parse_demo 
	
RUN echo "=== Starting sourcemod.sh ===" && \
	$SERVER/sourcemod.sh && \
	echo "=== Starting matcha-build.sh ===" && \
	$SERVER/matcha-build.sh && \
	echo "=== Completed ==="

EXPOSE 27015/udp 27015/tcp 27021/tcp 27020/udp 8080/tcp

WORKDIR /home/$USER/hlserver

ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "1", "+map", "cp_process_f12", "+servercfgfile", "server.cfg", "+maxplayers", "24", "-enablefakeip"]