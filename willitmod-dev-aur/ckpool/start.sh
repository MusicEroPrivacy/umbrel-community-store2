#!/bin/bash
set -e

CONF="/tmp/ckpool.conf"
LOGDIR="/ckpool-logs"

mkdir -p "$LOGDIR"

# Write ckpool config from environment variables
cat > "$CONF" <<EOF
{
  "btcd": [
    {
      "url": "${RPC_HOST:-auroracoind}:${RPC_PORT:-12341}",
      "auth": "${RPC_USER:-umbrel}",
      "pass": "${RPC_PASSWORD:-x}",
      "notify": true
    }
  ],
  "btcaddress": "${AUR_ADDRESS:-AQmCPJ6TUcAqghaucodQ42mEVu6jQxx588}",
  "btcsig": "/mined by umbrel-aur/",
  "blockpoll": 500,
  "nonce1length": 4,
  "nonce2length": 8,
  "update_interval": 30,
  "logdir": "/ckpool-logs"
}
EOF

echo "[ckpool] Config written."
echo "[ckpool] Waiting for auroracoind RPC at ${RPC_HOST:-auroracoind}:${RPC_PORT:-12341}..."

until curl -sf \
  --user "${RPC_USER:-umbrel}:${RPC_PASSWORD:-x}" \
  --data-binary '{"jsonrpc":"1.0","id":"ping","method":"getblockchaininfo","params":[]}' \
  -H 'content-type: text/plain;' \
  "http://${RPC_HOST:-auroracoind}:${RPC_PORT:-12341}/" > /dev/null 2>&1; do
  echo "[ckpool] auroracoind not ready yet, retrying in 15s..."
  sleep 15
done

echo "[ckpool] auroracoind is ready. Starting ckpool solo stratum on :3333"
exec ckpool -c "$CONF" -s -L
