FROM spiretf/docker-tf2-server
LABEL maintainer="avan"

USER root

ARG GH_PAT
ENV GH_PAT=${GH_PAT}

RUN apt-get update && apt-get install -y git
COPY ./maps.sh ./sourcemod.sh ./matcha.sh ./update-matcha.sh ./tf.sh $SERVER/
RUN chmod +x $SERVER/maps.sh $SERVER/sourcemod.sh $SERVER/matcha.sh $SERVER/update-matcha.sh $SERVER/tf.sh

USER tf2
RUN $SERVER/maps.sh \
	&& $SERVER/sourcemod.sh \
	&& $SERVER/matcha.sh

EXPOSE 27015/udp 27015/tcp 27021/tcp 27020/udp

WORKDIR /home/$USER/hlserver

ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "1", "+map", "cp_process_f12", "+maxplayers", "24", "-enablefakeip"]
