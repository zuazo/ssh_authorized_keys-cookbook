# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
#
# Author:: Corey Hemminger
# Cookbook:: ssh_authorized_keys
# Resource:: ssh_authorized_keys
#
# Copyright:: Copyright (c) 2020 Onddo Labs, SL.
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

provides :ssh_authorized_keys
resource_name :ssh_authorized_keys

description 'Manages ssh keys in users authorized_keys file'

property :user, String,
         required: true
         description: 'System user **(required)**'

property :group, String,
         default: lazy {
           user
         },
         description: 'System group'

property :home, String,
         description: 'System user home path'

property :key, String,
         required: true
         description: 'SSH public key in base64 **(required)**'

property :keytype, String,
         default: 'ssh-rsa',
         description: 'SSH key type'

property :comment, String,
         name_property: true,
         description: 'SSH key comment'

property :options, Hash,
         description: 'SSH key options as a hash'

property :validate_key, [True, False],
         default: true,
         description: 'Enable/Disable assert_key'

action :install do
  description 'Add ssh keys to users authorized_keys file'

  user = new_resource.user
  assert_user(user)
  group = new_resource.group || user_group(user)
  home = new_resource.home || user_home(user)

  ssh_key = Mash.new(
    options:  new_resource.options,
    key: new_resouce.key,
    validate_key: new_resource.validate_key,
    keytype: new_resource.keytype,
    comment: new_resouce.comment,
  )

  assert_key(ssh_key['key']) unless params['validate_key'] == false
  assert_keytype(ssh_key['keytype'])
  assert_comment(ssh_key['comment'])

  path = ::File.join(home, '.ssh', 'authorized_keys')

  directory path do
    recursive true
    user user
    group group
    mode '00700'
  end

  # Accumulator Pattern:
  # https://blog.dnsimple.com/2017/10/chef-accumulators/
  with_run_context :root do
    edit_resource(:template, path) do |new_resource|
      cookbook_name 'ssh_authorized_keys'
      source 'authorized_keys.erb'
      owner user
      group group
      mode '00600'
      variables['keys'][ssh_key['comment']] = ssh_key
      variables['keys'] = Hash[variables['keys'].sort]
      action :nothing
      delayed_action :create
    end
  end
  # t = template path do
  #       variables keys: {}
  #     end
  # t.cookbook('ssh_authorized_keys')
  # t.source('authorized_keys.erb')
  # t.owner(user)
  # t.group(group)
  # t.mode('00600')
  # t.variables[:keys][ssh_key['comment']] = ssh_key
  # # Sort file content by comment field: Calling the same ssh_authorized_keys in
  # # different order produces the same result.
  # t.variables[:keys] = Hash[t.variables[:keys].sort]
  #
  # # For notifications support (only works in Chef 12).
  # # @example
  # #   my_definition = ssh_authorize_key 'bob@acme.com' { ... }
  # #   my_definition.notifies :run, 'execute[thing]'
  # t
end

action :remove do
  description 'Remove ssh keys from users authorized_keys file'
  # TODO: Create remove logic
end

action_class do
  include SshAuthorizedKeysCookbook::ResourceHelpers
end
