FROM debian AS map-app-search-service-base-env
RUN apt update && apt -y install g++-12 g++ wget perl cmake lcov
RUN mkdir /workspace

FROM  map-app-search-service-base-env AS map-app-search-service-dep-build
ARG CONANFILE
ARG ARTIFACTS_NAME
ARG CONAN_BUILD_TYPE
WORKDIR /workspace
COPY $CONANFILE .
RUN wget https://github.com/conan-io/conan/releases/download/2.0.14/conan-ubuntu-64.deb && \
    dpkg -i conan-ubuntu-64.deb && \
    rm conan-ubuntu-64.deb && \
    conan profile detect && \
    conan install $CONANFILE --output-folder=$ARTIFACTS_NAME --build=missing  -s build_type=${CONAN_BUILD_TYPE} --deployer=full_deploy && \
    conan cache clean && \
    dpkg -r conan && \
    rm -rf ~/.conan2

FROM map-app-search-service-dep-build AS map-app-search-service-dep-archive
ARG ARTIFACTS_NAME
WORKDIR /workspace
RUN tar czf ${ARTIFACTS_NAME}.tar.gz ${ARTIFACTS_NAME}

FROM scratch AS map-app-search-service-artifacts
ARG ARTIFACTS_NAME
COPY --from=map-app-search-service-dep-archive /workspace/${ARTIFACTS_NAME}.tar.gz .
