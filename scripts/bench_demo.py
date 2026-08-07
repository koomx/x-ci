#!/usr/bin/env python3
"""Generate random demo benchmark data (no C++ deps)."""
from __future__ import annotations

import json
import random
from pathlib import Path

OUT = Path("benchmark-results/raw/bench.json")


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    random.seed()
    labels = ["memcpy", "ostream", "printf", "snprintf"]
    data = {
        "title": "x-ci benchmark demo",
        "unit": "ns",
        "samples": [
            {"name": name, "value": round(random.uniform(50, 500), 2)}
            for name in labels
        ],
    }
    OUT.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
