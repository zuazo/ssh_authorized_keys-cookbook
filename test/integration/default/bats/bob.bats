#!/usr/bin/env bats

@test "authenticates bob user with key2" {
  ssh \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -o BatchMode=yes \
    -i /root/.ssh/key2 \
    bob@127.0.0.1 true
}

@test "authenticates bob2 user with key2" {
  ssh \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -o BatchMode=yes \
    -i /root/.ssh/key2 \
    bob2@127.0.0.1 true
}
