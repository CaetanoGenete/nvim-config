from importlib import metadata
from itertools import chain
import json
import sys
from typing import List, TypedDict


class EntryPoint(TypedDict):
    name: str
    group: str
    value: List[str]


if __name__ == "__main__":
    group = sys.argv[1] if len(sys.argv) > 1 else None

    if sys.version_info >= (3, 10):
        eps = metadata.entry_points(group=group) if group else metadata.entry_points()
    else:
        if group:
            eps = metadata.entry_points().get(group, [])
        else:
            eps = chain(*metadata.entry_points().values())

    result = [
        EntryPoint(
            name=ep.name,
            group=ep.group,
            value=ep.value.split(":"),
        )
        for ep in eps
    ]

    # Serialise output to compact json
    print(json.dumps(result, separators=(",", ":")))
