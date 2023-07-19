FROM node:12-alpine as builder
WORKDIR /yapi
ENV VERSION=1.12.0
RUN wget https://github.com/YMFE/yapi/archive/v${VERSION}.zip
RUN unzip v${VERSION}.zip && mv yapi-${VERSION} vendors
WORKDIR /yapi/vendors
RUN apk add python2 make
RUN npm install --production --registry https://registry.npm.taobao.org
RUN wget https://hachiko-zjq.oss-cn-hangzhou.aliyuncs.com/shell.sh
RUN wget https://hachiko-zjq.oss-cn-hangzhou.aliyuncs.com/config.json
RUN chmod a+x shell.sh

FROM node:12-alpine
LABEL maintainer="343122875@qq.com"
ENV TZ="Asia/Shanghai"
WORKDIR /yapi/vendors
COPY --from=builder /yapi/vendors /yapi/vendors
RUN cp config.json /yapi/config.json
EXPOSE 3000
ENTRYPOINT ["sh", "shell.sh"]