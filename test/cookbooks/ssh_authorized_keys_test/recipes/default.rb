# encoding: UTF-8
#
# Cookbook Name:: ssh_authorized_keys_test
# Recipe:: default
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Onddo Labs, SL.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

key1 =
  'AAAAB3NzaC1yc2EAAAADAQABAAABAQCctNyRouVDhzjiP+u3R2+C0nD4VgsRgN9rOizD2ePBrf8'\
  '508VR5envsmEY5oF+TM3k/wb2xBY45KXOu9yQjQi9RcCYvrCAu3wPTrx07vRetkDIvs/O383zQQ'\
  'anrHMGckNzh83uwDU4JcJqBP2EwkTMUqlk6xyrGuQyjmWFKWjjUUkmHFII5azAh+9bp4OjULE9h'\
  '9fy4Y3ZOxHMrHuC5AjkWhvy88ItmGBf0sj0iW0893UVrzdfB20dz+G9pM2lE5NK/b/zfF7UlIjg'\
  'I9oR9w2+YaNZE/fmuHpH94Gx/Ptlwxb2tmdEReA8DPsnHMIML3ltcpJrwgVdTJEAAz1JnARx'

key2 =
  'AAAAB3NzaC1yc2EAAAADAQABAAABAQCySLKbpFRGCrKU/N6jNVB8vZLzexKbkq2bXPRKUakmf8q'\
  'rSQI9Bl1C8+6//uKpe909DrZzEkJzPC9BgpNnWtJ25SxHogKb1SybAk0OFc61X7wl1knoo+OcuW'\
  '6Moi0vpNiUGy2VnM0nyecLoQxggvnj1392uoMdS4VY71PGdcBac7p9IwAwYxlsuFEKRcfKisJAH'\
  'DEblgSFyC9lLMMjTSxxKn8s5AaR1h+Lb3Kwibd7ikvIgYRybTbD12FtQRxuWZBVm39CM3539gT6'\
  '514IaYyYVDyIEFDyGjK2UV27ah56jMaRFGX4IIh2gH5P2XaV7As5p8RPYoWwf+pCz19mrPd/'

key2_priv = [
  '-----BEGIN RSA PRIVATE KEY-----',
  'MIIEpAIBAAKCAQEAskiym6RURgqylPzeozVQfL2S83sSm5Ktm1z0SlGpJn/Kq0kC',
  'PQZdQvPuv/7iqXvdPQ62cxJCczwvQYKTZ1rSduUsR6ICm9UsmwJNDhXOtV+8JdZJ',
  '6KPjnLlujKItL6TYlBstlZzNJ8nnC6EMYIL549d/drqDHUuFWO9TxnXAWnO6fSMA',
  'MGMZbLhRCkXHyorCQBwxG5YEhcgvZSzDI00scSp/LOQGkdYfi29ysIm3e4pLyIGE',
  'cm02w9dhbUEcblmQVZt/QjN+d/YE+udeCGmMmFQ8iBBQ8hoytlFdu2oeeozGkRRl',
  '+CCIdoB+T9l2lewLOafET2KFsH/qQs9fZqz3fwIDAQABAoIBAE/QAb1xrJSKl3Xh',
  'Wl4gMP8W8yFzGFpzKKsjyu02b44fqYBSt+DP55Jgl6J2HcyX+ewqmP0c0Ii8Cb+/',
  'D/Q2EYBOiisrWRWgMk7Wkd5bXuWNjTI3I3E1ZWE1Fkt5EteAacCsBhUzVBia54cq',
  'Ots951bbk2F4j9fehjzRL2TqNAmJhEjIuPcTsUsLoireGVWuynG/sUOMqp59kf5x',
  'JyOBr/00h5jFvAdjaptLVDFWrn9lwtyoSrLvbU+gK8Gjk2843vL4G04C++fdEfjs',
  'WXj3pEPv/EluXOVJ8oMGPSKAY/H6dKfqeVtjK9Ncxwww/MTxseU4N0OudOMn7OLI',
  'j9IOvjkCgYEA2C7xxHxE8TP0tfB2EEod518CiM0P8Pg3z/Wnz07MncjfjmwN9T0S',
  'dIrolJUNe7By4t8SmF+aKgIeIsm7eVmpnlixkhPtgypgO7Z/rub32W8wNDHtEbuj',
  'jTV3Z8yLoXD801M/hFkJ0tG2U0qYQ8ROBQa+Ihae8j3okY+I1Lq4XcMCgYEA0x7L',
  'fIBlP/4VzI2WwSC9RNaO+0jy3ZM74y7jPHBMjqHUznNJ/SXTVJhYCHtRyzKZz7sD',
  'BvSAfHYTyWmC7Dhu8Cpqz0tqEAuM0VajgNaw5+2RqKyaQtY/bsbVMfMvBY3+6qk5',
  'lvUyaVM3uRLHbuvXpAK2JgOOyji1EMKnpLrIt5UCgYEAqCo8X3/bkVW9MhpPfPRq',
  'tqStsAT0NZqgr+CEHTtK6CJt5LghU3eid43mxk38Iw9rDxg/utADeFIVZzJN52Pc',
  'EhUkbGGcDMBWA50/TarVegqIENIVfAnee+XvcIsowvjFcw37BtTMU3ZWwgvwziZS',
  'Go7YMGQwWHfYBgMFiZWF/UkCgYB5CLqYEfP6D+znbHT1G5Pmlys5nMS/it1WjVbx',
  'G2CIlPavtSDB5KGXag9uLWTjHYtYsFo37oyKzhbh7X+FdYUEYw0A8rdHo5eDnCv4',
  'fRzGmkhbbzixAKs1EwC+tjBK+vEeDw5ZIRFZmL/ldoKncMYb3QIYIQoHnSMRDMeX',
  'hQ31UQKBgQCgfC3GjleXWYBVzQihvVdCToM6CGOljzXNcWhqroBhkKACwFXMTvGB',
  'Dx7Mn9rpvnJysHHaAzZVgGan3Bd1qDyDWchZXD5vERgzy84xV6oAPriuvMzOTCDD',
  'miAKI9hX5GxD4lWMFvxEsNv0KEL7O2TA7xFRPY4u5HD+pyF/oYLXgA==',
  '-----END RSA PRIVATE KEY-----'
].join("\n")

user 'bob' do
  supports manage_home: true
  home '/home/bob'
end

group 'bob' do
  members %w(bob)
end

user 'bob2' do
  supports manage_home: true
  home '/home/bob2'
end

group 'bob2' do
  members %w(bob2)
end

user 'alice' do
  supports manage_home: true
  home '/home/alice'
end

group 'alice' do
  members %w(alice)
end

ssh_authorize_key 'bob@acme.com' do
  keytype 'ssh-rsa'
  key key1
  user 'bob'
end

ssh_authorize_key 'bob@home.com' do
  key key2
  comment 'bob@home.com comment'
  user 'bob'
end

# bob2: Same as bob but keys in reverse order

ssh_authorize_key 'bob@home.com' do
  key key2
  comment 'bob@home.com comment'
  user 'bob2'
end

ssh_authorize_key 'bob@acme.com' do
  keytype 'ssh-rsa'
  key key1
  user 'bob2'
end

ssh_authorize_key 'alice@acme.com' do
  key key2
  user 'alice'
  options(
    'no-port-forwarding' => true,
    'no-agent-forwarding' => true,
    'no-X11-forwarding' => true,
    command:
      'echo \'Please login as the user "bob" rather than the user "alice".\''\
      ';echo;sleep 10'
  )
end

directory '/root/.ssh' do
  mode '00700'
end

file '/root/.ssh/key2' do
  mode '00600'
  content key2_priv
  sensitive true
end
