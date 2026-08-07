# x-ci

面向 **kmpkg** / **vcpkg** 的可复用 GitHub Actions CI。Linux job 按 `std17` / `std20` 标注，镜像来自 `ghcr.io/koomx`。**默认全关**，用 `enable-*` 按镜像打开。

> [English](README.md)

## Benchmark demo（按 job 区分）

自测打开**全矩阵**。每个 job 发布到独立路径：

`https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/<job-id>/plots/summary.png`

Artifact 也是分开的：`<job-id>-benchmarks`。

### std17

#### `std17-ubuntu20-amd64`

![std17-ubuntu20-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std17-ubuntu20-amd64/plots/summary.png)

#### `std17-ubuntu20-arm64`

![std17-ubuntu20-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std17-ubuntu20-arm64/plots/summary.png)

#### `std17-debian11-amd64`

![std17-debian11-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std17-debian11-amd64/plots/summary.png)

#### `std17-debian11-arm64`

![std17-debian11-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std17-debian11-arm64/plots/summary.png)

#### `std17-centos7-amd64`

![std17-centos7-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std17-centos7-amd64/plots/summary.png)

#### `std17-centos7-arm64`

![std17-centos7-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std17-centos7-arm64/plots/summary.png)

### std20

#### `std20-ubuntu22-amd64`

![std20-ubuntu22-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-ubuntu22-amd64/plots/summary.png)

#### `std20-ubuntu22-arm64`

![std20-ubuntu22-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-ubuntu22-arm64/plots/summary.png)

#### `std20-ubuntu24-amd64`

![std20-ubuntu24-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-ubuntu24-amd64/plots/summary.png)

#### `std20-ubuntu24-arm64`

![std20-ubuntu24-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-ubuntu24-arm64/plots/summary.png)

#### `std20-debian12-amd64`

![std20-debian12-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-debian12-amd64/plots/summary.png)

#### `std20-debian12-arm64`

![std20-debian12-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-debian12-arm64/plots/summary.png)

#### `std20-alpine319-amd64`

![std20-alpine319-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-alpine319-amd64/plots/summary.png)

#### `std20-alpine319-arm64`

![std20-alpine319-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-alpine319-arm64/plots/summary.png)

#### `std20-alpine320-amd64`

![std20-alpine320-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-alpine320-amd64/plots/summary.png)

#### `std20-alpine320-arm64`

![std20-alpine320-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-alpine320-arm64/plots/summary.png)

#### `std20-centos9-amd64`

![std20-centos9-amd64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-centos9-amd64/plots/summary.png)

#### `std20-centos9-arm64`

![std20-centos9-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/std20-centos9-arm64/plots/summary.png)

### Hosted

#### `macos-arm64`

![macos-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/macos-arm64/plots/summary.png)

#### `macos-x86`

![macos-x86](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/macos-x86/plots/summary.png)

#### `windows`

![windows](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/windows/plots/summary.png)

#### `windows-arm64`

![windows-arm64](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/windows-arm64/plots/summary.png)

---

## 用法摘要

- `enable-<job-id>: true` 打开对应镜像
- `benchmark-command` / `plot-command` 可选；空则跳过
- 发布分支：`benchmark-publish-branch: benchmark-results`
- `benchmark-publish-job: ''` 表示每个 job 都发到 `latest/<job-id>/`
- Artifact：`<job-id>-benchmarks`

Demo：`scripts/bench_demo.py` + `scripts/plot_demo.py`。

---

## 许可证

MIT
