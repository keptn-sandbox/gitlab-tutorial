FROM centos:latest

ADD main.go .
RUN yum update -y \
  && yum install git glibc curl tar -y \
  && curl -O https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz \
  && tar -C / -xzf go1.11.5.linux-amd64.tar.gz \
  && export GOROOT=/go \
  && export PATH=$PATH:$GOROOT/bin \
  && go build -o server . \
  && chmod +x server \
  && rm -rf /var/cache/yum/* \
  && rm -rf /go/src /go/pkg \
EXPOSE 5000

CMD ["./server"]
