# Copyright 2019 Yoshi Yamaguchi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM python:3.7-slim-buster
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes
LABEL maintainer Yoshi Yamaguchi
ENV PATH $PATH:$HOME/bin
ENV PERF_TO_PROFILER_DEPS \
  g++ \
  git \
  libelf-dev \
  libcap-dev
ENV TEMPORARY_DEPS \
  curl \
  git \
  gnupg
RUN apt-get -qq update \
  && apt-get install -y --no-install-recommends -q \
  ${PERF_TO_PROFILER_DEPS} ${TEMPORARY_DEPS}
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl -s -N https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends -q bazel
RUN apt-get remove -y ${TEMPORARY_DEPS} \
  && apt-get autoremove -y
WORKDIR /workspace
CMD bazel
