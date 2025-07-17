from contextlib import suppress
from importlib import metadata
import inspect
from itertools import chain
import json
import sys
from typing import List, Optional, TypedDict


class Entrypoint(TypedDict):
    name: str
    group: str
    file_name: Optional[str]
    lineno: int


def entry_points(group: Optional[str] = None) -> List[Entrypoint]:
    eps: List[metadata.EntryPoint] = []
    if sys.version_info >= (3, 10):
        eps_object: metadata.EntryPoints
        if group is None:
            eps_object = metadata.entry_points()
        else:
            eps_object = metadata.entry_points(group=group)
        eps = list(eps_object)

    else:
        ep_by_group = metadata.entry_points()
        if group is None:
            eps = list(chain.from_iterable(ep_by_group.values()))
        else:
            eps = ep_by_group[group]

    result: list[Entrypoint] = []
    for ep in eps:
        # If an exception occurs, simply don't return the endpoint
        with suppress(Exception):
            ep_func = ep.load()
            result.append(
                Entrypoint(
                    name=ep.name,
                    group=ep.group,
                    file_name=inspect.getsourcefile(ep_func),
                    lineno=inspect.getsourcelines(ep_func)[1],
                )
            )

    return result


if __name__ == "__main__":
    eps = entry_points(group=sys.argv[1] if len(sys.argv) > 1 else None)
    # Serialise output to compact json
    print(json.dumps(eps, separators=(",", ":")))
