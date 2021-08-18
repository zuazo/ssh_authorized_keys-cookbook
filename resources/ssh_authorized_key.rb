# encoding: UTF-8
#
# Cookbook:: ssh_authorized_keys
# Resource:: ssh_authorize_key
# Author:: Ben Hughes
# Author:: Corey Hemminger
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

unified_mode true
provides :ssh_authorize_key
resource_name :ssh_authorize_key
default_action :create

description 'Manages ssh keys in users authorized_keys file'

property :instance_name, String,
         name_property: true,
         description: 'Resource name'

property :user, [Integer, String],
         required: true,
         description: 'System user **(required)**'

property :group, [Integer, String],
         description: 'System group'

property :home, String,
         description: 'System user home path'

property :key, String,
         required: true,
         description: 'SSH public key in base64 **(required)**'

property :keytype, String,
         default: 'ssh-rsa',
         description: 'SSH key type'

property :comment, String,
         name_property: true,
         description: 'SSH key comment'

property :options, Hash,
         description: 'SSH key options as a hash'

property :validate_key, [true, false],
         default: true,
         description: 'Enable/Disable assert_key'

action :create do
  assert_user(new_resource.user)
  new_resource.comment ||= new_resource.instance_name
  new_resource.group ||= user_group(new_resource.user)
  new_resource.home ||= user_home(new_resource.user)

  ssh_key = {
    options: new_resource.options,
    key: new_resource.key,
    validate_key: new_resource.validate_key,
    keytype: new_resource.keytype,
    comment: new_resource.comment,
  }

  assert_key(ssh_key[:key]) if new_resource.validate_key
  assert_keytype(ssh_key[:keytype])
  assert_comment(ssh_key[:comment])

  path = ::File.join(new_resource.home, '.ssh', 'authorized_keys')

  # Avoid CHEF-3694 warning for .ssh directory.
  dir = ::File.dirname(path)

  directory dir do
    recursive true
    owner new_resource.user
    group new_resource.group
    mode '00700'
  end

  # Accumulator Pattern:
  # https://blog.dnsimple.com/2017/10/chef-accumulators/
  with_run_context :root do
    edit_resource(:template, path) do
      cookbook 'ssh_authorized_keys'
      source 'authorized_keys.erb'
      owner new_resource.user
      group new_resource.group
      mode '00600'
      variables['keys'] ||= {}
      variables['keys'][ssh_key[:comment]] = ssh_key
      variables['keys'] = variables['keys'].sort.to_h
      action :nothing
      delayed_action :create
    end
  end
end

action :remove do
  description 'Remove ssh keys from users authorized_keys file'
  # TODO: Create remove logic
end

action_class do
  include SshAuthorizedKeysCookbook::TemplateHelpers
  include SshAuthorizedKeysCookbook::ResourceHelpers
end
