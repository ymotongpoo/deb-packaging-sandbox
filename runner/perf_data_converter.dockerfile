ARG bazel_ver=1.0.0
ARG project_id
FROM gcr.io/$project_id/perf_to_profile_builder:$bazel_ver
LABEL maintainer Yoshi Yamaaguchi
COPY ./perf_data_converter /perf_data_converter
WORKDIR /perf_data_converter
RUN bazel build src:perf_to_profile
WORKDIR /workspace
RUN mv /perf_data_converter/bazel-bin/src/perf_to_profile .
CMD ./perf_to_profile