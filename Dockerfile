# syntax=docker/dockerfile:1.2
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:7.0 AS build
RUN apt-get update && \
    apt-get install -y libxml2-utils
WORKDIR /source

COPY **/*.csproj .
RUN for file in $(ls *.csproj); do mkdir -p ${file%.*}/ && mv $file ${file%.*}/; done
COPY MySolution.sln .

RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet restore MySolution.sln

COPY . .
RUN  --mount=type=cache,id=nuget,target=/root/.nuget/packages  \
     dotnet publish -c Release -o /app \
     --no-restore \
     --packages /root/.nuget/packages

FROM scratch
WORKDIR /app
COPY --from=build /source/ConsoleWasmDocker/bin/Release/net7.0/ConsoleWasmDocker.wasm /ConsoleWasmDocker.wasm
ENTRYPOINT [ "ConsoleWasmDocker.wasm" ]
