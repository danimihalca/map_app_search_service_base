# Map App Search Service base environment

## Description

Provides needed dependencies for building `map_app_search_service` repository and to create a  Docker environment image with them.

## Build

### Local dependencies build
* Prerequisites:
    - CMake 3.25
    - Conan 2.0.14

* Build dependencies via `conan`:
```
conan install conanfile.txt --output-folder=<CONAN_BUILD_FOLDER> \
    --build=missing -s build_type=<Debug/Release> --deployer=full_deploy
```

### Docker image build
Example usages:

- base docker build environment:
```
docker build --target map-app-search-service-base-env -t <IMAGE_NAME> .
```

- base docker build environment containing release/debug dependencies:
```
docker build --target=map-app-search-service-dep-build \
    `./docker_build/source-build-args.sh docker_build/args/<release/debug>.args` \
    -t <IMAGE_NAME> .
```

- build release/debug dependency artifacts only:
```
docker build --target=map-app-search-service-artifacts \
    `./docker_build/source-build-args.sh docker_build/args/<release/debug>.args` \
    --output type=local,dest=$(pwd)/out/ .
```