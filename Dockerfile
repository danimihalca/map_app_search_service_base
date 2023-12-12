FROM debian AS map-app-search-service-base-env
RUN apt update && apt -y install g++-12 g++ wget perl cmake lcov
RUN mkdir /workspace

FROM  map-app-search-service-base-env AS map-app-search-service-release-dep-build
WORKDIR /workspace
COPY conanfile-release.txt .
RUN wget https://github.com/conan-io/conan/releases/download/2.0.14/conan-ubuntu-64.deb && \
    dpkg -i conan-ubuntu-64.deb && \
    rm conan-ubuntu-64.deb && \
    conan profile detect && \
    conan install conanfile-release.txt --output-folder=search-service-dependencies-rel --build=missing  -s build_type=Release --deployer=full_deploy && \
    conan cache clean && \
    dpkg -r conan && \
    rm -rf ~/.conan2

FROM map-app-search-service-release-dep-build AS map-app-search-service-release-dep-archive
WORKDIR /workspace
RUN tar czf search-service-dependencies-rel.tar.gz search-service-dependencies-rel

FROM scratch AS map-app-search-service-release-artifacts
COPY --from=map-app-search-service-release-dep-archive /workspace/search-service-dependencies-rel.tar.gz .

FROM  map-app-search-service-base-env AS map-app-search-service-debug-dep-build
WORKDIR /workspace
COPY conanfile-debug.txt .
RUN wget https://github.com/conan-io/conan/releases/download/2.0.14/conan-ubuntu-64.deb && \
    dpkg -i conan-ubuntu-64.deb && \
    rm conan-ubuntu-64.deb && \
    conan profile detect && \
    conan install conanfile-debug.txt --output-folder=search-service-dependencies-dbg --build=missing  -s build_type=Debug --deployer=full_deploy && \
    conan cache clean && \
    dpkg -r conan && \
    rm -rf ~/.conan2

FROM map-app-search-service-debug-dep-build AS map-app-search-service-debug-dep-archive
WORKDIR /workspace
RUN tar czf search-service-dependencies-dbg.tar.gz search-service-dependencies-dbg

FROM scratch AS map-app-search-service-debug-artifacts
COPY --from=map-app-search-service-debug-dep-archive /workspace/search-service-dependencies-dbg.tar.gz .
