# WillItMod Umbrel Community Store — Auroracoin (AUR)

Pruned Auroracoin full node + ckpool SHA256d solo stratum server for Umbrel.

## Add to Umbrel

In your Umbrel dashboard go to **App Store → Community App Stores** and add:

```
https://github.com/YOUR_GITHUB_USERNAME/umbrel-community-store
```

Then install **Auroracoin Node** from the store.

## Ports

| Service  | Port  | Description           |
|----------|-------|-----------------------|
| P2P      | 12340 | AUR peer network      |
| RPC      | 12341 | auroracoind JSON-RPC  |
| Stratum  | 3333  | ckpool solo stratum   |

## Point your miner at it

Once the app is running and the node is synced:

```
stratum+tcp://<your-umbrel-ip>:3333
Username: AQmCPJ6TUcAqghaucodQ42mEVu6jQxx588
Password: x
```

## First install timing

- **auroracoind** compiles from source on first `docker build` — allow 20–60 min
- **ckpool** compiles from source on first `docker build` — allow ~5 min
- Node sync time depends on AUR network peer availability (seed nodes are offline; known IPs are pre-configured via `addnode`)

## Repo structure

```
umbrel-community-store/
├── umbrel-app-store.yml          # Store manifest (required by Umbrel)
└── willitmod-dev-aur/
    ├── umbrel-app.yml            # App metadata + icon
    ├── docker-compose.yml        # Two services: auroracoind + ckpool
    ├── Dockerfile                # Builds auroracoind from source
    ├── entrypoint.sh             # Writes auroracoin.conf, starts daemon
    ├── assets/
    │   └── 1.jpg                 # App icon shown in Umbrel UI
    └── ckpool/
        ├── Dockerfile            # Builds ckpool from source
        └── start.sh              # Writes ckpool.conf from env, starts stratum
```
