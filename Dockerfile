FROM ubuntu:16.04

RUN apt-get update -y && apt-get install --no-install-recommends -y -q ca-certificates python-dev python-setuptools \
                                                  wget unzip git

RUN easy_install pip
WORKDIR /Video-Classifier
COPY . /Video-Classifier
RUN apt-get install python-dev
RUN apt-get install -y python-subprocess32
RUN apt-get install python-tk -y
RUN apt-get install libhdf5-dev -y
RUN pip install pkgconfig
RUN pip install matplotlib
RUN pip install --trusted-host pypi.python.org -r requirements-on-my-python-env.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt


RUN wget -nv https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
    unzip -qq google-cloud-sdk.zip -d tools && \
    rm google-cloud-sdk.zip && \
    tools/google-cloud-sdk/install.sh --usage-reporting=false \
        --path-update=false --bash-completion=false \
        --disable-installation-options && \
    tools/google-cloud-sdk/bin/gcloud -q components update \
        gcloud core gsutil && \
    tools/google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check true && \
    touch /tools/google-cloud-sdk/lib/third_party/google.py

ADD build /vgg16_lstm_hi_dim

ENV PATH $PATH:/tools/node/bin:/tools/google-cloud-sdk/bin

CMD ["python", "vgg16_lstm_hi_dim_train.py"]