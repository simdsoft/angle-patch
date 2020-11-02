# angle-patch

1. Add depot_tools to PATH
2. IMPORTANT: Set DEPOT_TOOLS_WIN_TOOLCHAIN=0 in your environment if you are not a Googler.
2. Setup command
```sh
git clone https://chromium.googlesource.com/angle/angle
cd angle
python scripts/bootstrap.py
gclient sync
git checkout master
```
