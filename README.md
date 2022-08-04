# Kubernetes Buildkite Plugin

[![](https://img.shields.io/github/license/muhlba91/buildkite-plugin-kubernetes?style=for-the-badge)](LICENSE)
[![](https://img.shields.io/github/workflow/status/muhlba91/buildkite-plugin-kubernetes/Plugin?style=for-the-badge)](https://github.com/muhlba91/buildkite-plugin-kubernetes/actions)
[![](https://img.shields.io/github/workflow/status/muhlba91/buildkite-plugin-kubernetes/Container?style=for-the-badge)](https://github.com/muhlba91/buildkite-plugin-kubernetes/actions)
[![](https://img.shields.io/github/workflow/status/muhlba91/buildkite-plugin-kubernetes/Helm?style=for-the-badge)](https://github.com/muhlba91/buildkite-plugin-kubernetes/actions)
[![](https://img.shields.io/github/release-date/muhlba91/buildkite-plugin-kubernetes?style=for-the-badge)](https://github.com/muhlba91/buildkite-plugin-kubernetes/releases)
[![](https://quay.io/repository/muhlba91/buildkite-agent/status)](https://quay.io/repository/muhlba91/buildkite-agent)
[![](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/buildkite-plugin-kubernetes)](https://artifacthub.io/packages/search?repo=buildkite-plugin-kubernetes)
<a href="https://www.buymeacoffee.com/muhlba91" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="28" width="150"></a>

An opinionated [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for running pipeline steps as [Kubernetes Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/).

The plugin is based on the work of the [EmabrkStudios/k8s-buildkite-plugin](https://github.com/EmbarkStudios/k8s-buildkite-plugin).

---

## Quirks & Issues

Since the step isn't actually performed by the build-agent itself, but in a separately scheduled (and isolated) container, a few things don't work as on a "normal" build-agent.

The build step container will have the `buildkite-agent` binary mounted at `/usr/local/bin/buildkite-agent` to allow using the agent subcommands for annotations, metadata and artifacts directly.

This behavior may be disabled by setting `mount-buildkite-agent: false` in the pipeline.

> **Note:** The user is responsible for making sure the container specified in `image` contains any external dependencies required by the otherwise statically linked buildkite-agent binary. This includes certificate authorities, and possibly git and ssh depending on how it's being used.

### Build artifacts

As the build-agent doesn't run in the same container as the actual commands, automatic upload of artifacts specified in `artifact_paths` won't work.
A workaround to this is to run `buildkite-agent artifact upload ...` as a command in the step itself.

---

## Installation Notes

### Image Requirements

The plugin requires `jsonnet`, `jq`, and `kubectl` to be installed in the Buildkite agent (and the init) image used.

By default, the init image used is defined in this repositories `Dockerfile` and published as `quay.io/muhlba91/buildkite-agent:<TAG>`.

For your convenience, you can also use this image as yout Buildkite agent image as it's based on the official Buildkite image.

### Versioning

Please make sure to define a correct version of the plugin. Plugin releases are always tagged with `v*` (for example `v1.0.0`).

### Kubernetes Requirements

To be able to create and manage the jobs in your cluster, make sure the `ServiceAccount` linked to your Buildkite agent deployment has sufficient RBAC permissions.

Please refer to [`charts/agent/templates/rbac.yml`](charts/agent/templates/rbac.yml) for the RBAC permissions required.

### Helm Charts

#### buildkite-agent-kubernetes

For your convencience, a Helm chart is provided. Please take a look at the [`values.yaml`](charts/agent/values.yaml) file for customization.

You can install the chart with Helm like this:

```bash
helm repo add buildkite-agent-kubernetes https://muhlba91.github.io/buildkite-agent-kubernetes
helm install buildkite-agent-kubernetes buildkite-agent-kubernetes/agent -f values.yaml
```

#### buildkite-agent-buildscaler

If you want to scale the Buildkite agent, you need to scrape and external metrics like `buildkite_busy_agent_percentage` from Buildkite.

For example, you can use [https://github.com/elotl/buildscaler](https://github.com/elotl/buildscaler).

For your convenience, a Helm chart to run Buildscaler is provided. Please take a look at the [`values.yaml`](charts/buildscaler/values.yaml) file for customization.

You can install the chart with Helm like this:

```bash
helm repo add buildkite-agent-kubernetes https://muhlba91.github.io/buildkite-agent-kubernetes
helm install buildkite-agent-kubernetes buildkite-agent-kubernetes/buildscaler -f values.yaml
```

---

## Example

```yaml
steps:
  - command: "echo 'Hello, World!'"
    plugins:
      - muhlba91/kubernetes#v0.0.0:
          image: alpine
```

If you want to control how your command is passed to the container, you can use the `command` parameter on the plugin directly:

```yaml
steps:
  - plugins:
      - muhlba91/kubernetes#v0.0.0:
          image: alpine
          always-pull: true
          command: ["echo", "command"]
```

You can pass in additional environment variables, including values from a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/):

```yaml
steps:
  - command:
      - "yarn install"
      - "yarn run test"
    plugins:
      - muhlba91/kubernetes#v0.0.0:
          image: "node:16"
          environment:
            - "PUBLIC_ENVIRONMENT_VARIABLE=value"
          environment-from-secret:
            - "environment-secrets"
```

---

## Configuration

### Required

### `image` (required, string)

The name of the container image to use.

Example: `node:16`

### Optional

### `always-pull` (optional, boolean)

Whether to always pull the latest image before running the command. Sets [imagePullPolicy](https://kubernetes.io/docs/concepts/containers/images/#updating-images) on the container. If `false`, the value `IfNotPresent` is used.

Default: `false`

### `command` (optional, array)

Sets the command for the container. Useful if the container image has an entrypoint, but requires extra arguments.

Note that [this has different meaning than in Docker](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#notes). This sets the `args` field for the Container.

This option can't be used if your step already has a top-level, non-plugin `command` option present.

Examples: `[ "/bin/mycommand", "-c", "test" ]`, `["arg1", "arg2"]`

### `entrypoint` (optional, string)

Override the image’s default entrypoint.

Note that [this has different meaning than in Docker](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#notes). This sets the `command` field for the Container.

Example: `/my/custom/entrypoint.sh`

### `environment` (optional, array)

An array of additional environment variables to pass into to the docker container. Items can be specified as `KEY=value`.

Example: `[ "FOO=bar", "PUBLIC_VALUE=value" ]`

### `environment-from-secret` (optional, string or array)

One or more [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) that should be added to the container as environment variables. Each key in the secret will be exposed as an environment variable. If specified as an array, all listed secrets will be added in order.

Example: `my-secrets`

### `init-environment-from-secret` (optional, string or array)

One or more [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) that should be added to the [job init container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) as environment variables. Each key in the secret will be exposed as an environment variable. If specified as an array, all listed secrets will be added in order.

Example: `my-secrets`

### `init-image` (optional, string)

Override the [job initContainer](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/). A buildkite-agent binary is expected to exist to do the checkout, along with git and ssh. The default is to use a public image based on the Dockerfile in this repository. If set to an empty string no init container is used.

Example: `quay.io/muhlba91/buildkite-agent:<VERSION>`

### `privileged` (optional, boolean)

Wether to run the container in [privileged mode](https://kubernetes.io/docs/concepts/workloads/pods/pod/#privileged-mode-for-pod-containers).

### `agent-token-secret-name` (optional, string)

The name of the secret containing the buildkite agent token used for bootstrapping in the init container.

### `agent-token-secret-key` (optional, string)

The key of the secret value containing the buildkite agent token, within the secret specified in `agent-token-secret-name`.

Default: `buildkite-agent-token`

### `git-credentials-secret-name` (optional, string)

The name of the secret containing the git credentials used for checking out source code with HTTPS.

### `git-credentials-secret-key` (optional, string)

The key of the secret value containing the git credentials used for checking out source code with HTTPS.

The contents of this file will be used as the [git credential store](https://git-scm.com/docs/git-credential-store) file.

Default: `git-credentials`

### `git-ssh-secret-name` (optional, string)

The name of the secret containing the git credentials used for checking out source code with SSH.

### `git-ssh-secret-key` (optional, string)

The key of the secret value containing the SSH key used when checking out source code with SSH as transport.

Default: `ssh-key`

### `mount-hostpath` (optional, string or array)

Mount a host path as a directory inside the container. Must be in the form of `/host/path:/some/mount/path`.
Multiple host paths may be mounted by specifying a list of host/mount pairs.

Example: `my-secret:/my/secret`

### `mount-secret` (optional, string or array)

Mount a secret as a directory inside the container. Must be in the form of `secretName:/some/mount/path`.
Multiple secrets may be mounted by specifying a list of secret/mount pairs.

Example: `my-secret:/my/secret`

### `default-secret-name` (optional, string)

The name of the secret containing the buildkite agent token, ssh and git credentials used for bootstrapping in the init container.
The key names of the secret are configured as with separate secrets.
This is useful if you have control over secret creation and would like to avoid explicitly providing the key and secret names.

Example: `buildkite-secrets`

### `build-path-host-path` (optional, string)

Optionally mount a [host path](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) to be used as base directory for buildkite builds. This allows local caching and incremental builds using fast local storage.

Should be used with some care, since the actual storage used is outside the control of Kubernetes itself.

Example: `/var/lib/buildkite/builds`

### `build-path-pvc` (optional, string)

Optionally mount an existing [Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) used as backing storage for the build.

### `git-mirrors-host-path` (optional, string)

Optionally mount a [host path](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) to be used as [git-mirrors](https://forum.buildkite.community/t/shared-git-repository-checkouts-in-the-agent/443) path. This enables multiple pipelines to share a single git repository.

Should be used with some care, since the actual storage used is outside the control of Kubernetes itself.

Example: `/var/lib/buildkite/builds`

### `resources-request-cpu` (optional, string)

Sets [cpu request](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/) for the build container.

### `resources-limit-cpu` (optional, string)

Sets [cpu limit](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/) for the build container.

### `resources-request-memory` (optional, string)

Sets [memory request](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/) for the build container.

### `resources-limit-memory` (optional, string)

Sets [memory limit](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/) for the build container.

### `service-account-name` (optional, string)

Sets the [service account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) for the build container.

Default: `default`

### `use-agent-node-affinity` (optional, boolean)

If set to `true`, the spawned jobs will use the same [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/), [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/), and [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) as the buildkite agent.

### `workdir` (optional, string)

Override the working directory to run the command in, inside the container. The default is the build directory where the buildkite bootstrap and git checkout runs.

### `patch` (optional, string)

(Advanced / hack use). Provide a [jsonnet](https://jsonnet.org/) function to transform the resulting job manifest.

Example:

```yaml
patch: |
  function(job) job {
    spec+: {
      template+: {
        spec+: {
          tolerations: [ { key: 'foo', value: 'bar', operator: 'Equal', effect: 'NoSchedule' }, ],
        },
      },
    },
  }
```

### `print-resulting-job-spec` (optional, boolean)

If set to `true`, the resulting k8s job spec is printed to the log. This can be useful when debugging.

### `job-backoff-limit` (optional, integer)

Configures [`spec.backoffLimit`](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) to enable retries of job's pod creation.
Default value: `0`.

### `job-ttl-seconds-after-finished` (optional, integer)

Configures [`spec.ttlSecondsAfterFinished`](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/) on the k8s job, requires TTL Controller enabled in the cluster, otherwise ignored.
Default value: `86400`.

### `jobs-cleanup-via-plugin` (optional, boolean)

If set to `true`, the plugin cleans up k8s jobs older than 1 day even if they're still running.
Default value: `true`.

If you have [TTL Controller](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/) enabled or some other means to cleanup finished jobs, it is recommended to set the value to `false` in order to reduce load on k8s api servers.

### `job-cleanup-after-finished-via-plugin` (optional, boolean)

If set to `true` plugin cleans up finished k8s job.
Default value: `true`.

If you have TTL controller or https://github.com/lwolf/kube-cleanup-operator running, it is highly recommended to set the value to `false` to reduce load on k8s api servers.

---

## Contributing

We welcome community contributions to this project.

## Supporting

If you enjoy the application and want to support my efforts, please feel free to buy me a coffe. :)

<a href="https://www.buymeacoffee.com/muhlba91" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="75" width="300"></a>
