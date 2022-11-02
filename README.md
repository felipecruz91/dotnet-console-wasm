# dotnet-console-wasm

A .NET7 Console App compiled to WASM that runs in Docker Desktop using the WasmEdge runtime. Learn more at: https://docs.docker.com/desktop/wasm/

## Build

```console
docker buildx build --platform wasi/wasm32 -t dotnet-console-wasm . --load
```

## Run

```console
docker run --rm --runtime=io.containerd.wasmedge.v1 --platform=wasi/wasm32 dotnet-console-wasm
```
