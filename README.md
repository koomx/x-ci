# x-ci

Reusable GitHub Actions workflows for C++ projects using **kmpkg** or **vcpkg**.

Linux jobs are labeled by **C++ standard tier** (`std17` / `std20`) and match [koomx/dockers](https://github.com/koomx/dockers) images on `ghcr.io/koomx`. Every job is **off by default**; consumers enable the images they need via independent `enable-*` inputs.

> [中文文档](README_CN.md)

## Benchmark demo (per job)

Self-test enables the **full** matrix. Each job publishes under a distinct path on the `benchmark-results` branch:

`https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/<job-id>/plots/summary.png`

Artifacts are also separate: `<job-id>-benchmarks`.

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

## Table of Contents

- [Templates](#templates)
- [Platform Matrix](#platform-matrix)
- [Usage](#usage)
- [Benchmark & plot](#benchmark--plot)
- [Workflow Reference](#workflow-reference)
- [Inputs](#inputs)
- [Best Practices](#best-practices)

---

## Templates

| Workflow | Package manager | Path |
|----------|-----------------|------|
| `kmpkg-ci-template.yml` | kmpkg | `.github/workflows/kmpkg-ci-template.yml` |
| `vcpkg-template.yml` | vcpkg (latest `master`) | `.github/workflows/vcpkg-template.yml` |

Self-test uses **vcpkg-template** with the full matrix enabled.

---

## Platform Matrix

Job IDs match the gallery above. Linux images: `ghcr.io/koomx/kumo-<std>-<distro>-<arch>:latest`.

---

## Usage

```yaml
jobs:
  ci:
    permissions:
      contents: write
    uses: koomx/x-ci/.github/workflows/vcpkg-template.yml@v1
    with:
      enable-std20-ubuntu24-amd64: true
      config-command: |
        cmake --preset=default -DCMAKE_TOOLCHAIN_FILE=$VCPKG_CMAKE
      build-command: cmake --build build -j$(nproc)
      test-command: ctest --test-dir build --output-on-failure -j1
```

---

## Benchmark & plot

After Test (empty = skip):

1. `benchmark-command`
2. `plot-command`
3. Upload Artifact `<job-id>-benchmarks`
4. Optional publish to `benchmark-publish-branch` under `latest/<job-id>/`

```yaml
permissions:
  contents: write
with:
  enable-std20-ubuntu24-amd64: true
  enable-std20-alpine320-amd64: true
  benchmark-command: |
    python3 scripts/bench_demo.py
  plot-command: |
    python3 scripts/plot_demo.py
  benchmark-publish-branch: benchmark-results
  benchmark-publish-job: ''   # empty = all enabled jobs publish separately
```

README fixed links (one per job):

```markdown
![std20-ubuntu24-amd64](https://raw.githubusercontent.com/<owner>/<repo>/benchmark-results/latest/std20-ubuntu24-amd64/plots/summary.png)
```

---

## Inputs

| Name | Default | Description |
|------|---------|-------------|
| `config-command` / `build-command` | required | Configure / build |
| `test-command` | `''` | Skip if empty |
| `benchmark-command` / `plot-command` | `''` | Skip if empty |
| `benchmark-artifact-path` | `benchmark-results/` | Upload / publish source dir |
| `benchmark-publish-branch` | `''` | Branch for `latest/<job-id>/` |
| `benchmark-publish-job` | `''` | Empty = all jobs; or one job id |
| `enable-<job-id>` | `false` | Opt-in per image |

---

## Best Practices

- Keep plot filename stable (`plots/summary.png`)
- Use `contents: write` when publishing
- Prefer empty `benchmark-publish-job` so each container keeps its own folder

---

## License

MIT
