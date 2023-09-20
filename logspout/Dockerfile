FROM gliderlabs/logspout:master
RUN echo "Logspout built with Splunk adapter" > ha-logspout.txt

COPY rootfs /

ONBUILD COPY ./build.sh /src/build.sh
ONBUILD COPY ./modules.go /src/modules.go

CMD ["/start.sh"]
