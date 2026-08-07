# x-ci

面向 **kmpkg** 或 **vcpkg** 的 C++ 项目可复用 GitHub Actions CI 工作流。

Linux job **严格按 C++ 标准档位**标注（`std17` / `std20`），镜像对应 [koomx/dockers](https://github.com/koomx/dockers)（`ghcr.io/koomx`）。**默认全部关闭**；用独立的 `enable-*` 按镜像打开。

> [English](README.md)

## Benchmark demo

自测会生成随机数据并用 matplotlib 画柱状图，再推到 `benchmark-results` 分支。README 链接固定不变：

![Benchmark demo](https://raw.githubusercontent.com/koomx/x-ci/benchmark-results/latest/plots/summary.png)

---

## 目录

- [模板](#模板)
- [平台矩阵](#平台矩阵)
- [使用方式](#使用方式)
- [Benchmark 与作图](#benchmark-与作图)
- [输入参数](#输入参数)
- [最佳实践](#最佳实践)

---

## 模板

| 工作流 | 包管理器 | 路径 |
|--------|---------|------|
| `kmpkg-ci-template.yml` | kmpkg | `.github/workflows/kmpkg-ci-template.yml` |
| `vcpkg-template.yml` | vcpkg（最新 `master`） | `.github/workflows/vcpkg-template.yml` |

本仓库自测使用 **vcpkg-template**。

---

## 平台矩阵

Job ID 形如 `std20-ubuntu24-amd64`，镜像为 `ghcr.io/koomx/kumo-<std>-<distro>-<arch>:latest`。另有 `macos-arm64` / `macos-x86` / `windows` / `windows-arm64`。完整列表见 [英文 README](README.md#platform-matrix)。

---

## 使用方式

```yaml
jobs:
  ci:
    permissions:
      contents: write   # 仅在发布 benchmark 分支时需要
    uses: koomx/x-ci/.github/workflows/vcpkg-template.yml@v1
    with:
      enable-std20-ubuntu24-amd64: true
      config-command: |
        cmake --preset=default -DCMAKE_TOOLCHAIN_FILE=$VCPKG_CMAKE
      build-command: cmake --build build -j$(nproc)
      test-command: ctest --test-dir build --output-on-failure -j1
```

---

## Benchmark 与作图

Test 之后的可选步骤（命令为空则跳过）：

1. `benchmark-command` — 写出 `benchmark-results/` 数据
2. `plot-command` — 作图
3. 上传 Artifact `<job-id>-benchmarks`
4. 可选：推到固定分支，README 用**不变的图片 URL**

本仓 demo：`scripts/bench_demo.py`（随机数据）+ `scripts/plot_demo.py`（matplotlib）。

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

README 只写一次：

```markdown
![Benchmark](https://raw.githubusercontent.com/<owner>/<repo>/benchmark-results/latest/plots/summary.png)
```

发布仅在 `push` / `workflow_dispatch`，且仅 `benchmark-publish-job` 指定的 job 执行。

---

## 输入参数

| 名称 | 默认 | 说明 |
|------|------|------|
| `config-command` / `build-command` | 必填 | 配置 / 编译 |
| `test-command` | `''` | 测试；空则跳过 |
| `benchmark-command` | `''` | Benchmark；空则跳过 |
| `plot-command` | `''` | 作图；空则跳过 |
| `benchmark-artifact-path` | `benchmark-results/` | 上传/发布目录 |
| `benchmark-publish-branch` | `''` | 非空则推送到该分支的 `latest/` |
| `benchmark-publish-job` | `''` | 仅该 job 负责发布 |
| `enable-<job-id>` | `false` | 按镜像打开 job |

---

## 最佳实践

- 只 enable 需要的镜像
- 作图文件名保持稳定（如 `plots/summary.png`）以便 README 固定链接
- 使用 `benchmark-publish-branch` 时授予 `contents: write`

---

## 本地试跑 demo

```bash
python3 scripts/bench_demo.py
python3 scripts/plot_demo.py
```

---

## 许可证

MIT
