ARG BUILDKITE_AGENT_VERSION="latest"
ARG KUBERNETES_VERSION="v1.23.0"

FROM buildkite/agent:${BUILDKITE_AGENT_VERSION}

ARG BUILDKITE_AGENT_VERSION
ARG KUBERNETES_VERSION
ARG CI_COMMIT_TIMESTAMP
ARG CI_COMMIT_SHA
ARG CI_COMMIT_TAG

LABEL org.opencontainers.image.authors="Daniel Muehlbachler-Pietrzykowski <daniel.muehlbachler@niftyside.com>"
LABEL org.opencontainers.image.vendor="Daniel Muehlbachler-Pietrzykowski"
LABEL org.opencontainers.image.source="https://github.com/muhlba91/buildkite-plugin-kubernetes"
LABEL org.opencontainers.image.created="${CI_COMMIT_TIMESTAMP}"
LABEL org.opencontainers.image.title="buildkite-agent-kubernetes"
LABEL org.opencontainers.image.description="Buildkite Agent with Kubernetes Support"
LABEL org.opencontainers.image.base.name "buildkite/agent:${BUILDKITE_AGENT_VERSION}"
LABEL org.opencontainers.image.revision="${CI_COMMIT_SHA}"
LABEL org.opencontainers.image.version="${BUILDKITE_AGENT_VERSION}-${KUBERNETES_VERSION}-${CI_COMMIT_TAG}"

USER root

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash ca-certificates coreutils curl git jq libstdc++ openssh jsonnet
RUN curl -sfL https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

ENTRYPOINT [ "/entrypoint.sh"]
CMD ["start"]
