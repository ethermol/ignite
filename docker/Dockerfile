FROM alpine:3.12
WORKDIR /
EXPOSE 1313/tcp

RUN apk update && \
apk add --no-cache git hugo && \
hugo new site doclib && \
cd doclib && git init && \
git submodule add https://github.com/ethermol/hugo-book themes/book && \
cp -R themes/book/templateSite/content . && \
sed -i 's/My New Hugo Site/The DevOps Society/' config.toml && \
[ $(grep "^pygments" config.toml) ] || echo -e '\npygmentsCodefences = true\npygmentsStyle = "solarized-light"\n' >> config.toml && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/*

WORKDIR /doclib
CMD [ "hugo", "server", "--minify", "--theme", "book", "--bind", "0.0.0.0", "--baseURL", "http://cms.intelnet.nl", "--appendPort=false" ]
