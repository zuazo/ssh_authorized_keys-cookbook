#!/usr/bin/env bats

@test "authenticate bob use with key2" {
  ssh \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -o BatchMode=yes \
    -i /root/.ssh/key2 \
    bob@127.0.0.1 true
}
