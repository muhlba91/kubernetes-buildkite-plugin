# Changelog


### [1.0.8](https://github.com/muhlba91/kubernetes-buildkite-plugin/compare/v1.0.7...v1.0.8) (2022-08-05)


### Bug Fixes

* add additional volumes to agent chart ([15536f9](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/15536f900f8a925a72618adad4c1903e0def10e4))
* fix agent deployment ([11eb81a](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/11eb81a5eac9c8a2774d813ffee0e6d1ec522a68))
* fix agent volume modes ([e5ff65a](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/e5ff65a45840b8e982b4ca768227562050bc5bc3))
* fix bootstrap command ([71bba22](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/71bba22d463c53032b8383db63fc681542d7ba06))
* fix buildscaler deployment env ([1c8cce7](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/1c8cce71eeeae7860f6b961785af8229c6cf1b32))
* fix buildscaler duplicated rbac rolebinding ([ca404ee](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/ca404ee29eb75202a5c23a24e891f9b8b72f731e))
* fix rbac for agent chart ([6ec8c14](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/6ec8c144629257455564dc283bff3c32c7b831ac))
* fix rbac for buildscaler chart ([a989866](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/a989866f1f414df428a1d2f45b12370ca8c85a03))

### [1.0.7](https://github.com/muhlba91/kubernetes-buildkite-plugin/compare/v1.0.6...v1.0.7) (2022-08-05)


### Bug Fixes

* fix job-name label ([448dd35](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/448dd3501a003c5e7a1cd04039d2adcc59b71581))
* reduce ttl for job and set plugin cleanup to false ([2b8effe](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/2b8effe789eef6a6c1e7e1a289f83ba67ecb991d))

### [1.0.6](https://github.com/muhlba91/kubernetes-buildkite-plugin/compare/v1.0.5...v1.0.6) (2022-08-05)


### Bug Fixes

* fix hooks to retrieve the job ([8eea305](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/8eea305fd1968a3ae57fc7c1d14656ab50909a03))
* remove printing commands on startup of the container ([ffd36f1](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/ffd36f11464d1aff24bc49921098adbd548d2617))
* update chart app version ([a9e10e1](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/a9e10e1687e17f87509a319eacef6b4f785217ca))

### [1.0.5](https://github.com/muhlba91/kubernetes-buildkite-plugin/compare/v1.0.4...v1.0.5) (2022-08-04)


### Bug Fixes

* fix job-name selector ([071c551](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/071c55145fd6e4c7b3caee451a310f42d9a0cbe2))

### [1.0.4](https://github.com/muhlba91/kubernetes-buildkite-plugin/compare/v1.0.3...v1.0.4) (2022-08-04)


### Bug Fixes

* fix command hook and labels ([7d64680](https://github.com/muhlba91/kubernetes-buildkite-plugin/commit/7d646803a0d8e6f6d885b03d51c872a332e76546))

### [1.0.3](https://github.com/muhlba91/buildkite-plugin-kubernetes/compare/v1.0.2...v1.0.3) (2022-08-04)


### Bug Fixes

* fix chart deployment ([c04b248](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/c04b2485be88ab27e82d4a07d3d08ce0b1e19712))
* fix chart env ([5f7da1f](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/5f7da1f8f6f5e1551026f0a52ee765ce61d48545))
* fix chart labels ([d57d4a5](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/d57d4a535e4dcdb4e3cad97687b7778f02035a13))
* fix entrypoint detection in plugin ([d591896](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/d591896d8fcbf0af9c3e4c092d8417bedfd5255e))

### [1.0.2](https://github.com/muhlba91/buildkite-plugin-kubernetes/compare/v1.0.1...v1.0.2) (2022-08-04)

### 1.0.1 (2022-08-04)


### Bug Fixes

* add container ([879fd8c](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/879fd8ceed2a46a2a72c756b8963d029088996a7))
* add helm charts ([5eb4a5a](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/5eb4a5a9c49197274ca545d10dd9b2e4959046e7))
* add plugin ([d40ac85](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/d40ac850172e29a073fa4962eb3f755bb2dea41a))
* initial commit ([0991703](https://github.com/muhlba91/buildkite-plugin-kubernetes/commit/0991703a7ffd0af2abe030c82bc104a6ec53a187))
