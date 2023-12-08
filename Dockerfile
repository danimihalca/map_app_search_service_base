FROM debian AS map-app-search-service-base-env
RUN apt update
RUN apt -y install g++-12 g++ wget perl cmake lcov
RUN mkdir /workspace

FROM  map-app-search-service-base-env AS map-app-search-service-release-env
WORKDIR /workspace
COPY conanfile-release.txt .
RUN wget https://github.com/conan-io/conan/releases/download/2.0.14/conan-ubuntu-64.deb && \
    dpkg -i conan-ubuntu-64.deb && \
    rm conan-ubuntu-64.deb && \
    conan profile detect && \
    conan install conanfile-release.txt --output-folder=conanBuildRel --build=missing  -s build_type=Release --deployer=full_deploy && \
    conan cache clean && \
    dpkg -r conan && \
    rm -rf ~/.conan2

FROM  map-app-search-service-base-env AS map-app-search-service-debug-env
WORKDIR /workspace
COPY conanfile-debug.txt .
RUN wget https://github.com/conan-io/conan/releases/download/2.0.14/conan-ubuntu-64.deb && \
    dpkg -i conan-ubuntu-64.deb && \
    rm conan-ubuntu-64.deb && \
    conan profile detect && \
    conan install conanfile-debug.txt --output-folder=conanBuildDbg --build=missing  -s build_type=Debug --deployer=full_deploy && \
    conan cache clean && \
    dpkg -r conan && \
    rm -rf ~/.conan2
