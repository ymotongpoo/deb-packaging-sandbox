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

FROM debian:buster-slim as builder
LABEL maintainer Yoshi Yamaguchi
RUN apt-get -qq update \
  && apt-get install -y --no-install-recommends -q golang-go
WORKDIR /workdir
COPY hello.go .
RUN go build -o hello hello.go

FROM debian:buster-slim as packager
ENV DEB_DEPENDENCY \
  build-essential \
  dh-make \
  fakeroot \
  devscripts \
  pbuilder \
  cdbs
RUN apt-get -qq update \
  && apt-get install -y --no-install-recommends -q ${DEB_DEPENDENCY}
WORKDIR /out
RUN mkdir -p /pkgroot/usr/bin \
  && mkdir -p /pkgroot/DEBIAN
COPY --from=builder /workdir/hello /pkgroot/usr/bin/hello
COPY control /pkgroot/DEBIAN/control
RUN fakeroot dpkg-deb --build /pkgroot .

FROM debian:buster-slim as installer
COPY --from=packager /out/hello_0.0.1_amd64.deb .
RUN dpkg -i hello_0.0.1_amd64.deb
CMD /usr/bin/hello