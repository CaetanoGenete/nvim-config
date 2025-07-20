from importlib import metadata
from itertools import chain
import json
import sys
from typing import TypedDict


class EntryPoint(TypedDict):
    name: str
    group: str
    module: str
    attr: str


if __name__ == "__main__":
    if sys.version_info >= (3, 10):
        eps = metadata.entry_points()
    else:
        eps = chain(*metadata.entry_points().values())

    result = [
        EntryPoint(
            name=ep.name,
            group=ep.group,
            module=ep.value.split(":")[0],
            attr=ep.value.split(":")[1],
        )
        for ep in eps
    ]

    # Serialise output to compact json
    print(json.dumps(result, separators=(",", ":")))
