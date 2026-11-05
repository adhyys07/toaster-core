# Toaster core server

This repository is a static HTTPS download server for Toaster Libretro cores.
It is designed for deployment as a Dockerfile application in Coolify.

## Important licensing rule

Only add core binaries that you are legally permitted to redistribute under
their applicable licenses. Do not add PlayStation BIOS files or game images.
BIOS files must be imported locally from hardware owned by the user.

## Files expected by Toaster

Place permitted Windows x64 core DLLs in `cores/` using these exact names:

```text
cores/swanstation_libretro.dll
cores/ppsspp_libretro.dll
cores/pcsx2_libretro.dll
```

The current checkout intentionally contains no binary files. The locally
downloaded DLLs were not uploaded because their redistribution permissions were
not verified.

## cores/manifest.txt

Toaster loads cores as native code, so it checks every download against
`cores/manifest.txt` and refuses to install a core that does not match. Without
this file the installer reports that the server has no manifest and stops.

Regenerate it whenever a DLL in `cores/` changes, or the stale checksums will
reject the new file:

```bash
cd cores && sha256sum -t *.dll > manifest.txt
```

The `-t` matters. `sha256sum` defaults to binary mode on Windows and writes
`<hash> *name`; the asterisk is then read as part of the filename, so the
manifest parses but matches nothing.

Verify before deploying:

```bash
cd cores && sha256sum -c manifest.txt
```

## Coolify deployment

1. Create a Coolify application from this repository.
2. Select **Dockerfile** as the build pack.
3. Use port `80`.
4. Assign a domain and enable HTTPS with Let's Encrypt.
5. Deploy the application.

After deployment, verify:

```text
https://your-domain.example/cores/swanstation_libretro.dll
https://your-domain.example/cores/ppsspp_libretro.dll
https://your-domain.example/cores/pcsx2_libretro.dll
```

The URLs return `404` until the corresponding permitted DLL is added to
`cores/` and redeployed.

## Toaster configuration

Start Toaster with the deployed directory URL:

```text
build/emu.exe --core-server https://your-domain.example/cores
```

The Game Library's **Install Cores** button downloads the three exact filenames
from that URL into the local `cores` directory.
