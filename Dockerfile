FROM lambci/lambda-base:build

RUN yum install -y aclocal autoconf automake cmakegcc freetype-devel gcc gcc-c++ \
    	git lcms2-devel libjpeg-devel libjpeg-turbo-devel autogen autoconf libtool \
    	libpng-devel libtiff-devel libtool libwebp-devel libzip-devel make zlib-devel \
    	ImageMagick ImageMagick-devel

WORKDIR /root

RUN git clone https://github.com/DanBloomberg/leptonica.git
WORKDIR leptonica/
RUN ./autogen.sh && ./configure && make
RUN make install

WORKDIR /root

RUN git clone https://github.com/tesseract-ocr/tesseract.git
WORKDIR tesseract
RUN git checkout 4.1.0
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && ./autogen.sh && ./configure && make
RUN make install

WORKDIR /root/tesseract-standalone
RUN cp /usr/local/bin/tesseract .

WORKDIR /root/tesseract-standalone/lib
RUN cp /usr/local/lib/libtesseract.so.4 ./ \
    && cp /usr/lib64/libpng12.so.0 ./ \
    && cp /usr/lib64/libtiff.so.5 ./ \
    && cp /usr/lib64/libgomp.so.1 ./ \
    && cp /usr/lib64/libjbig.so.2.0 ./ \
    && cp /usr/local/lib/liblept.so.5 ./ \
    && cp /usr/lib64/libjpeg.so.62 ./ \
    && cp /usr/lib64/libwebp.so.4 ./ \
    && cp /usr/lib64/libstdc++.so.6 ./

WORKDIR /root/tesseract-standalone/tessdata

RUN curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/master/eng.traineddata --output eng.traineddata
RUN curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/master/osd.traineddata --output osd.traineddata

WORKDIR /root
RUN git clone https://github.com/tesseract-ocr/tessconfigs.git
RUN cp tessconfigs/configs /root/tesseract-standalone/tessdata && cp tessconfigs/tessconfigs /root/tesseract-standalone/tessdata

WORKDIR /root/tesseract-standalone