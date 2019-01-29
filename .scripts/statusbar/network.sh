#!/bin/sh
# Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

INTERFACE="${BLOCK_INSTANCE:-enp3s0}"
echo $INTERFACE
state () {
  cat /sys/class/net/$INTERFACE/operstate
}

speed () {
  cat /sys/class/net/$INTERFACE/speed 2> /dev/null
}

ipv4 () {
  ip addr show $INTERFACE | perl -n -e '/inet ([^\/]+)/ && print $1'
}

ipv6 () {
  ip -6 addr show $INTERFACE | perl -n -e '/inet6 ([^\/]+)/ && print $1'
}

if [ "$(state)" != 'up' ]; then
  echo down # full text
  echo down # short text
  echo \#FF0000 # color
  exit 0
fi

# TODO eventually accept a -4 or -6 flag to force only one or the other
IPADDR=$(ipv6)
[ -z "$IPADDR" ] && IPADDR=$(ipv4)

if [ -z "$IPADDR" ]; then
  echo no addr # full text
  echo no addr # short text
  exit 0
fi

# full text
echo -n "$IPADDR"
SPEED=$(speed)
[ -n "$SPEED" ] && echo " ($SPEED Mbits/s)" || echo

# short text
echo "$IPADDR"
