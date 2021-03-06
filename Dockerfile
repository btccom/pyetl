FROM ubuntu:20.04
MAINTAINER Yihao Peng yihao.peng@bitmain.com

ENV LD_LIBRARY_PATH=/lib:/lib64:/usr/lib:/usr/local/lib:/usr/local/cuda/lib64/:/opt/hadoop/lib/native

ARG APT_MIRROR_URL=http://mirrors.aliyun.com/ubuntu/
ARG PIP_MIRROR_URL=https://mirrors.aliyun.com/pypi/simple/

RUN sed -i "s#http://[a-z0-9.-]*\.[cno][oer][mtg]/ubuntu/#${APT_MIRROR_URL}#g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y python3 python3-pip python3-snappy python3-confluent-kafka \
    && apt-get clean \
    && apt-get autoremove -y

RUN pip3 install --upgrade pip -i "${PIP_MIRROR_URL}" \
 && pip3 config --global set global.index-url "${PIP_MIRROR_URL}" \
 && pip3 install brotli kazoo requests numpy pandas cython colorama numba fastparquet

ADD pyetl.py /app/
ADD bin/ /app/bin/

CMD ["/app/bin/maprpyparqetl.sh"]
