FROM lambci/lambda-base:build

COPY tessbuild.sh .

RUN bash tessbuild.sh

WORKDIR /var/task