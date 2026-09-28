# VS Code on Cloudera AI (Custom ML Runtime)

Custom **Cloudera AI Workbench / CML** runtime that opens **VS Code in the browser** via [code-server](https://github.com/coder/code-server).

## What you get

| Surface | Behavior |
|--------|----------|
| **Workbench editor** | Launches `code-server` embedded in Cloudera AI Workbench|
| **Python 3.13** | PBJ Workbench standard image with the usual notebook/kernel tooling |
| **Integrated terminal** | Full shell in the project workspace under `/home/cdsw` |

## Prerequisites

- Cloudera AI Workbench with **custom runtime** catalog access
- Docker build host with access to `docker.repository.cloudera.com` (linux/amd64)

## Build and register the runtime

```bash
docker build --platform linux/amd64 --pull --rm \
  -f Dockerfile \
  -t <your-registry>/vscode-cloudera-ai:1.0.0 .

docker push <your-registry>/vscode-cloudera-ai:1.0.0
```

In **Admin → Runtime Catalog → Add Runtime**, use your image URL. The image sets `ML_RUNTIME_EDITOR=VsCode` so sessions offer the VS Code editor instead of JupyterLab.

**Base image:** `ml-runtime-pbj-workbench-python3.13-standard:2026.08.1-b5`. If your cluster uses a different maintenance build, change the `FROM` line to match your platform’s PBJ Workbench tag.

## Use VS Code

1. Start a session with this runtime.
2. Open the **VS Code** editor from the workbench UI.
3. Work in the project filesystem; install extensions from the Open VSX marketplace as needed.

Optional env var: `CODE_SERVER_BIND` (default `127.0.0.1:8090`).

## Architecture

| Component | Role |
|-----------|------|
| **code-server** | VS Code in the browser; bound to `127.0.0.1:8090` |
| **PBJ Workbench** | Cloudera AI Python runtime base (kernels, Spark/Hadoop client libs per base image) |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Editor does not appear in UI | Confirm the runtime is registered and `ML_RUNTIME_EDITOR=VsCode` is set on the image. |
| Port / proxy errors | Ensure nothing else binds `8090` in the session; restart the session and reopen the editor. |
| Extension install fails | Some VS Code Marketplace extensions require manual VSIX install; prefer Open VSX-compatible extensions in code-server. |

## Repository layout

| Path | Purpose |
|------|---------|
| `Dockerfile` | PBJ Workbench + code-server + runtime metadata |
| `scripts/vscode-launch.sh` | `ml-runtime-editor` entry: start code-server |

## Related projects

- [cloudera/community-ml-runtimes](https://github.com/cloudera/community-ml-runtimes/tree/main/vscode) — VS Code runtime patterns

MIT © 2026
