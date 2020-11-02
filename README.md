# angle-patch

1. Add depot_tools to PATH
2. IMPORTANT: Set **DEPOT_TOOLS_WIN_TOOLCHAIN=0** in your environment if you are not a Googler.
3. Ensure your system only contains vc142 toolset, multi toolset will cause gn error: Can't find User32.lib
4. Setup command
```sh
git clone https://chromium.googlesource.com/angle/angle
cd angle
python scripts/bootstrap.py
gclient sync
git checkout master
```
