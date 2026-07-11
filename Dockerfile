# syntax=docker/dockerfile:1

FROM debian:bookworm-slim AS builder

ARG CLUSTALO_VERSION=1.2.4
ARG CLUSTALO_URL=https://codeload.github.com/GSLBiotech/clustal-omega/tar.gz/refs/tags/1.2.4
ARG CLUSTALO_SHA256=7f61b607d1f69e2f26372ddd80d3ffdcd2b2dd961af22887f6eb60412b7ec776

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl g++ libargtable2-dev make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN curl -fsSL "$CLUSTALO_URL" -o clustalo.tar.gz \
    && echo "$CLUSTALO_SHA256  clustalo.tar.gz" | sha256sum -c - \
    && tar -xzf clustalo.tar.gz

WORKDIR /src/clustal-omega-${CLUSTALO_VERSION}
RUN ./configure --prefix=/opt/clustalo \
    && make -j"$(nproc)" \
    && make install-strip

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/clustalo/bin/clustalo /usr/local/bin/clustalo
WORKDIR /data
ENTRYPOINT ["/usr/local/bin/clustalo"]
