FROM ubuntu:20.04 as build
ARG URI
RUN apt update; apt install -y build-essential libffi-dev perl zlib1g-dev wget
RUN wget $URI -O duoauthproxy-src.tgz
RUN mkdir /duoauthproxy-src; tar xzf duoauthproxy-src.tgz -C /duoauthproxy-src --strip-components=1
RUN cd /duoauthproxy-src; make

FROM ubuntu:20.04 as install
COPY --from=build /duoauthproxy-src/duoauthproxy-build/ /duoauthproxy-build
RUN /duoauthproxy-build/install --install-dir /opt/duoauthproxy --service-user duo_authproxy_svc --log-group duo_authproxy_grp --create-init-script no; rm -rf /duoauthproxy-build
ENTRYPOINT /opt/duoauthproxy/bin/authproxy