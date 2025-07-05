FROM spiretf/docker-tf2-server
LABEL maintainer="avan"

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
COPY ./maps.sh ./sourcemod.sh ./matcha.sh ./update-matcha.sh ./tf.sh $SERVER/
RUN chmod +x $SERVER/maps.sh $SERVER/sourcemod.sh $SERVER/matcha.sh $SERVER/update-matcha.sh $SERVER/tf.sh

# Setup TF2 server
USER tf2
RUN $SERVER/maps.sh \
    && $SERVER/sourcemod.sh \
    && $SERVER/matcha.sh

EXPOSE 27015/udp 27015/tcp 27021/tcp 27020/udp

WORKDIR /home/$USER/hlserver

ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "1", "+map", "cp_process_f12", "+servercfgfile", "server.cfg", "+maxplayers", "24", "-enablefakeip"]