#!/usr/bin/env bash
set -euo pipefail

bond=false
phone=false
ip4=""
ip6=""
gw=""

while [[ "${1:-}" != "" ]]; do
  case "$1" in
    -b|--bond)
      bond=true
      ;;
    -p|--phone)
      phone=true
      ;;
    -i4|--ip4)
      ip4="$2"
      shift
      ;;
    -i6|--ip6)
      ip6="$2"
      shift
      ;;
    -g|--gateway)
      gw="$2"
      shift
      ;;
    --)
      break
      ;;
    *)
      printf "Unknown Option %s\n" "$1"
      exit 1
      ;;
  esac
  shift
done

if [[ -z "$ip4" || -z "$gw" ]]; then
  echo "Usage: $0 -i4 <IPv4/CIDR> -g <gateway> [-i6 <IPv6/CIDR>] [--bond|--phone]"
  exit 1
fi

# ---- derive a valid MAC suffix from the IPv4 last octet ----
IPV4_NO_CIDR="${ip4%%/*}"
LAST_OCTET="$(awk -F. '{print $4}' <<< "$IPV4_NO_CIDR")"
HEX_SUFFIX="$(printf "%02x" "$LAST_OCTET")"

add_v6_if_set() {
  local dev="$1"
  if [[ -n "${ip6:-}" ]]; then
    ip -6 addr replace "$ip6" dev "$dev"
  fi
}

if $bond; then
  ip link set eth1 down 2>/dev/null || true
  ip link set eth2 down 2>/dev/null || true

  ip link add bond0 type bond mode 802.3ad 2>/dev/null || true
  ip link set eth1 master bond0
  ip link set eth2 master bond0

  ip link set dev bond0 address "c0:d6:82:00:00:${HEX_SUFFIX}"
  ip link set bond0 up

  ip addr replace "$ip4" dev bond0
  ip route replace 10.0.0.0/8 via "$gw" dev bond0
  ip route replace 224.0.0.0/4 via "$gw" dev bond0
  add_v6_if_set bond0

elif $phone; then
  ip link add name br0 type bridge 2>/dev/null || true
  ip link set br0 address "30:86:2d:00:00:${HEX_SUFFIX}"

  ip link set br0 type bridge stp_state 0
  ip link set br0 type bridge vlan_stats_per_port 1

  ip link set dev br0 up
  ip link set eth1 master br0
  ip link set eth2 master br0

  ip link set br0 type bridge mcast_stats_enabled 1

  ip addr replace "$ip4" dev br0
  ip route replace 10.0.0.0/8 via "$gw" dev br0
  ip route replace 224.0.0.0/4 via "$gw" dev br0
  add_v6_if_set br0

else
  ip link set dev eth1 address "94:8e:d3:00:00:${HEX_SUFFIX}"
  ip link set dev eth1 up

  ip addr replace "$ip4" dev eth1
  ip route replace 10.0.0.0/8 via "$gw" dev eth1
  ip route replace 224.0.0.0/4 via "$gw" dev eth1
  add_v6_if_set eth1
fi