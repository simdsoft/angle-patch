# angle-patch

## build step
### windows
1. Add **depot_tools** to PATH
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

## angleproject
https://github.com/google/angle

## About win7 compatible

- Use newer glfw, refer to: https://github.com/glfw/glfw/issues/1718
  ```cpp
    #if !defined(ANGLE_ENABLE_WINDOWS_UWP)
  #    if !ANGLE_SKIP_DXGI_1_2_CHECK
      {
          ANGLE_TRACE_EVENT0("gpu.angle", "Renderer11::initialize (DXGICheck)");
          // In order to create a swap chain for an HWND owned by another process, DXGI 1.2 is
          // required.
          // The easiest way to check is to query for a IDXGIDevice2.
          bool requireDXGI1_2 = false;
          HWND hwnd           = WindowFromDC(mDisplay->getNativeDisplayId());
          if (hwnd)
          {
              DWORD currentProcessId = GetCurrentProcessId();
              DWORD wndProcessId;
              GetWindowThreadProcessId(hwnd, &wndProcessId);
              requireDXGI1_2 = (currentProcessId != wndProcessId);
          }
          else
          {
              requireDXGI1_2 = true;
          }

          if (requireDXGI1_2)
          {
              IDXGIDevice2 *dxgiDevice2 = nullptr;
              result = mDevice->QueryInterface(__uuidof(IDXGIDevice2), (void **)&dxgiDevice2);
              if (FAILED(result))
              {
                  return egl::EglNotInitialized(D3D11_INIT_INCOMPATIBLE_DXGI)
                         << "DXGI 1.2 required to present to HWNDs owned by another process.";
              }
              SafeRelease(dxgiDevice2);
          }
      }
  #    endif
  #endif
  ```
- Fallback to software render
  ```cpp
  if (result == E_INVALIDARG && mAvailableFeatureLevels.size() > 1u &&
                mAvailableFeatureLevels[0] == D3D_FEATURE_LEVEL_11_1)
  {
      // On older Windows platforms, D3D11.1 is not supported which returns E_INVALIDARG.
      // Try again without passing D3D_FEATURE_LEVEL_11_1 in case we have other feature
      // levels to fall back on.
      mAvailableFeatureLevels.erase(mAvailableFeatureLevels.begin());
      if (createD3D11on12Device)
      {
          result =
              callD3D11On12CreateDevice(D3D12CreateDevice, D3D11On12CreateDevice, false);
      }
      else
      {
          result = callD3D11CreateDevice(D3D11CreateDevice, false);
      }

      // x-studio spec, fallback to software render driver and try again
      if (result == DXGI_ERROR_UNSUPPORTED)
      { 
          mRequestedDriverType = D3D_DRIVER_TYPE_WARP;
          result               = callD3D11CreateDevice(D3D11CreateDevice, false);
      }
  }
  ```
