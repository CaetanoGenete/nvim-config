from importlib.metadata import entry_points
from sys import argv

eps = entry_points(name=argv[1], group=argv[2])
next(iter(eps)).load()()
