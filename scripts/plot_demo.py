#!/usr/bin/env python3
"""Plot demo benchmark JSON with matplotlib."""
from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

IN = Path("benchmark-results/raw/bench.json")
OUT = Path("benchmark-results/plots/summary.png")
VENDOR = Path(".bench-py")


def ensure_matplotlib() -> None:
    try:
        import matplotlib  # noqa: F401
        return
    except ImportError:
        pass
    VENDOR.mkdir(exist_ok=True)
    subprocess.check_call(
        [
            sys.executable,
            "-m",
            "pip",
            "install",
            "-q",
            "--target",
            str(VENDOR),
            "matplotlib",
        ]
    )
    sys.path.insert(0, str(VENDOR))


def main() -> None:
    ensure_matplotlib()
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    data = json.loads(IN.read_text(encoding="utf-8"))
    names = [s["name"] for s in data["samples"]]
    values = [s["value"] for s in data["samples"]]

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig, ax = plt.subplots(figsize=(7, 4))
    ax.bar(names, values, color="#3b82f6")
    ax.set_title(data.get("title", "benchmark"))
    ax.set_ylabel(data.get("unit", ""))
    fig.tight_layout()
    fig.savefig(OUT, dpi=120)
    plt.close(fig)
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
