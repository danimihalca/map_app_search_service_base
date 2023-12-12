Provides environment setup and dependencies for building map_app_search_service repository.

Example usages:

- base docker build environment:

> docker build --target map-app-search-service-base-env -t map-app-search-base .

- base docker build environment containing release/debug dependencies:

> docker build --target=map-app-search-service-dep-build `./docker_build/source-build-args.sh docker_build/args/release.args` -t map-app-search-service-rel-env .

> docker build --target=map-app-search-service-dep-build `./docker_build/source-build-args.sh docker_build/args/debug.args` -t map-app-search-service-dbg-env .

- build release/debug dependency artifacts only:

> docker build --target=map-app-search-service-artifacts `./docker_build/source-build-args.sh docker_build/args/release.args` --output type=local,dest=$(pwd)/out/ .

> docker build --target=map-app-search-service-artifacts `./docker_build/source-build-args.sh docker_build/args/debug.args` --output type=local,dest=$(pwd)/out/ .
