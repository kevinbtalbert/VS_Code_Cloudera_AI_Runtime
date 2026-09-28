# Cloudera ML runtime: VS Code in the browser (code-server)
FROM --platform=linux/amd64 docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-pbj-workbench-python3.13-standard:2026.08.1-b5

USER root

# ── System dependencies ─────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
        vim nano curl wget less tree jq unzip zip git ca-certificates \
        ripgrep fd-find bat netcat-openbsd \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && ln -sf /usr/bin/batcat /usr/local/bin/bat

# ── code-server (browser VS Code) ───────────────────────────────────────────
# Pattern from https://github.com/cloudera/community-ml-runtimes/tree/main/vscode
ARG CODE_SERVER_VERSION=4.139.1
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version "${CODE_SERVER_VERSION}"

COPY scripts/vscode-launch.sh /usr/local/bin/vscode

RUN chmod +x /usr/local/bin/vscode && \
    ln -sf /usr/local/bin/vscode /usr/local/bin/ml-runtime-editor && \
    mkdir -p /home/cdsw/.local/share/code-server/User && \
    chown -R cdsw:cdsw /home/cdsw/.local

ENV CODE_SERVER_BIND="127.0.0.1:8090"

ENV ML_RUNTIME_EDITION="VS Code" \
    ML_RUNTIME_EDITOR="VsCode" \
    ML_RUNTIME_KERNEL="Python 3.13" \
    ML_RUNTIME_SHORT_VERSION="1.0" \
    ML_RUNTIME_MAINTENANCE_VERSION="0" \
    ML_RUNTIME_DESCRIPTION="Browser VS Code (code-server) on Cloudera AI Workbench PBJ Python 3.13"

ENV ML_RUNTIME_FULL_VERSION="${ML_RUNTIME_SHORT_VERSION}.${ML_RUNTIME_MAINTENANCE_VERSION}"

LABEL com.cloudera.ml.runtime.edition=$ML_RUNTIME_EDITION \
      com.cloudera.ml.runtime.full-version=$ML_RUNTIME_FULL_VERSION \
      com.cloudera.ml.runtime.short-version=$ML_RUNTIME_SHORT_VERSION \
      com.cloudera.ml.runtime.maintenance-version=$ML_RUNTIME_MAINTENANCE_VERSION \
      com.cloudera.ml.runtime.description=$ML_RUNTIME_DESCRIPTION \
      com.cloudera.ml.runtime.editor=$ML_RUNTIME_EDITOR

WORKDIR /home/cdsw
USER cdsw
