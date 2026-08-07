# x-ci

Reusable GitHub Actions workflows for C++ projects using **kmpkg** or **vcpkg**.

Linux jobs are labeled by **C++ standard tier** (`std17` / `std20`) and match [koomx/dockers](https://github.com/koomx/dockers) images on `ghcr.io/koomx`. Every job is **off by default**; consumers enable the images they need via independent `enable-*` inputs.

> [中文文档](README_CN.md)

## Benchmark demo

Self-test generates random sample data and a matplotlib bar chart, then publishes to the `benchmark-results` branch. This README link stays fixed:

![Benchmark demo](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/plots/summary.png)

---

## Table of Contents

- [Templates](#templates)
- [Platform Matrix](#platform-matrix)
- [Usage](#usage)
- [Benchmark & plot](#benchmark--plot)
- [Workflow Reference](#workflow-reference)
- [Inputs](#inputs)
- [Logs & Debugging](#logs--debugging)
- [Best Practices](#best-practices)
- [Local Testing](#local-testing)

---

## Templates

| Workflow | Package manager | Path |
|----------|-----------------|------|
| `kmpkg-ci-template.yml` | kmpkg (`kumose/kmpkgcore`) | `.github/workflows/kmpkg-ci-template.yml` |
| `vcpkg-template.yml` | vcpkg (`microsoft/vcpkg` **latest `master`**) | `.github/workflows/vcpkg-template.yml` |

Migration: `ci-template.yml` was renamed to `kmpkg-ci-template.yml`. Update callers accordingly.

This repository's self-test (`ci-self.yml`) uses **vcpkg-template**.

---

## Platform Matrix

### Linux std17 (`ghcr.io/koomx/kumo-std17-…`)

| Job ID | Image | Arch |
|--------|-------|------|
| `std17-ubuntu20-amd64` | `kumo-std17-ubuntu20-amd64` | x86_64 |
| `std17-ubuntu20-arm64` | `kumo-std17-ubuntu20-arm64` | arm64 |
| `std17-debian11-amd64` | `kumo-std17-debian11-amd64` | x86_64 |
| `std17-debian11-arm64` | `kumo-std17-debian11-arm64` | arm64 |
| `std17-centos7-amd64` | `kumo-std17-centos7-amd64` | x86_64 |
| `std17-centos7-arm64` | `kumo-std17-centos7-arm64` | arm64 |

### Linux std20 (`ghcr.io/koomx/kumo-std20-…`)

| Job ID | Image | Arch |
|--------|-------|------|
| `std20-ubuntu22-amd64` | `kumo-std20-ubuntu22-amd64` | x86_64 |
| `std20-ubuntu22-arm64` | `kumo-std20-ubuntu22-arm64` | arm64 |
| `std20-ubuntu24-amd64` | `kumo-std20-ubuntu24-amd64` | x86_64 |
| `std20-ubuntu24-arm64` | `kumo-std20-ubuntu24-arm64` | arm64 |
| `std20-debian12-amd64` | `kumo-std20-debian12-amd64` | x86_64 |
| `std20-debian12-arm64` | `kumo-std20-debian12-arm64` | arm64 |
| `std20-alpine319-amd64` | `kumo-std20-alpine319-amd64` | x86_64 |
| `std20-alpine319-arm64` | `kumo-std20-alpine319-arm64` | arm64 |
| `std20-alpine320-amd64` | `kumo-std20-alpine320-amd64` | x86_64 |
| `std20-alpine320-arm64` | `kumo-std20-alpine320-arm64` | arm64 |
| `std20-centos9-amd64` | `kumo-std20-centos9-amd64` | x86_64 |
| `std20-centos9-arm64` | `kumo-std20-centos9-arm64` | arm64 |

### Hosted (no std container)

| Job ID | Runner | Arch |
|--------|--------|------|
| `macos-arm64` | `macos-latest` | arm64 |
| `macos-x86` | `macos-13` | x86_64 |
| `windows` | `windows-latest` | x86_64 |
| `windows-arm64` | `windows-11-arm` | arm64 |

---

## Usage

### Choose which CI to run

All jobs default to **disabled**. Enable each image/job independently:

```yaml
jobs:
  ci:
    permissions:
      contents: write   # only needed if publishing benchmark branch
    uses: koomx/x-ci/.github/workflows/vcpkg-template.yml@v1
    with:
      enable-std20-ubuntu24-amd64: true
      enable-macos-arm64: true
      config-command: |
        cmake --preset=default -DCMAKE_TOOLCHAIN_FILE=$VCPKG_CMAKE
      build-command: cmake --build build -j$(nproc)
      test-command: ctest --test-dir build --output-on-failure -j1
```

### vcpkg

```yaml
jobs:
  ci:
    uses: koomx/x-ci/.github/workflows/vcpkg-template.yml@v1
    with:
      enable-std20-ubuntu24-amd64: true
      config-command: |
        cmake --preset=default -DCMAKE_TOOLCHAIN_FILE=$VCPKG_CMAKE
      build-command: cmake --build build -j$(nproc)
      test-command: ctest --test-dir build --output-on-failure -j1
```

Exported env: `VCPKG_ROOT`, `VCPKG_CMAKE`, `VCPKG_DEFAULT_BINARY_CACHE`.

### kmpkg

```yaml
jobs:
  ci:
    uses: koomx/x-ci/.github/workflows/kmpkg-ci-template.yml@v1
    with:
      enable-std20-ubuntu24-amd64: true
      config-command: cmake --preset=default -DKMCMAKE_BUILD_TEST=ON
      build-command: cmake --build build -j$(nproc)
      test-command: ctest --test-dir build --output-on-failure -j1
      deps-ubuntu: libssl-dev
```

---

## Benchmark & plot

Optional steps after Test (empty command = skip):

1. `benchmark-command` — produce data under `benchmark-results/`
2. `plot-command` — draw charts into that directory
3. Upload Artifact `<job-id>-benchmarks`
4. Optionally publish to a fixed git branch so the README can keep a **stable image URL**

Demo in this repo (`scripts/bench_demo.py` + `scripts/plot_demo.py`): random numbers → matplotlib bar chart → publish on push.

```yaml
permissions:
  contents: write
with:
  enable-std20-ubuntu24-amd64: true
  benchmark-command: |
    python3 scripts/bench_demo.py
  plot-command: |
    python3 scripts/plot_demo.py
  benchmark-publish-branch: benchmark-results
  benchmark-publish-job: std20-ubuntu24-amd64
```

README (write once, never change for each run):

```markdown
![Benchmark](https://raw.githubusercontent.com/<owner>/<repo>/benchmark-results/latest/plots/summary.png)
```

Publish runs only on `push` / `workflow_dispatch`, and only on the job named by `benchmark-publish-job`.

---

## Workflow Reference

Each job: Checkout → deps → Bootstrap → Configure → Build → Test → Benchmark → Plot → upload/publish → failure logs.

---

## Inputs

| Name | Required | Default | Description |
|------|----------|---------|-------------|
| `config-command` | ✅ | — | CMake configure |
| `build-command` | ✅ | — | Build |
| `test-command` | ❌ | `''` | Test; skipped if empty |
| `benchmark-command` | ❌ | `''` | Benchmark; skipped if empty |
| `plot-command` | ❌ | `''` | Plot after benchmark; skipped if empty |
| `benchmark-artifact-path` | ❌ | `benchmark-results/` | Upload / publish directory |
| `benchmark-publish-branch` | ❌ | `''` | If set, push `latest/` to this branch |
| `benchmark-publish-job` | ❌ | `''` | Only this job id publishes |
| `deps-*` | ❌ | `''` | Extra system packages |
| `enable-<job-id>` | ❌ | `false` | Enable one job |

---

## Logs & Debugging

Failure artifacts `<job-id>-logs`; benchmark Artifact `<job-id>-benchmarks`.

---

## Best Practices

- Enable only the jobs you need
- Pin the workflow tag (`@v1`)
- Keep plot output filename stable (e.g. `plots/summary.png`) for the fixed README URL
- Grant `permissions: contents: write` when using `benchmark-publish-branch`

---

## Local Testing

```bash
python3 scripts/bench_demo.py
python3 scripts/plot_demo.py
# writes benchmark-results/plots/summary.png
```

---

## License

MIT
