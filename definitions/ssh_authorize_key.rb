# encoding: UTF-8
#
# Cookbook Name:: ssh_authorized_keys
# Definition:: ssh_authorize_key
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

define :ssh_authorize_key do
  self.class.send(:include, ::SshAuthorizedKeysCookbook::ResourceHelpers)

  user = params[:user]
  assert_user(user)
  group = params[:group] || user_group(user)
  home = params[:home] || user_home(user)

  ssh_key = {
    options: params[:options],
    key: params[:key],
    validate_key: params[:validate_key],
    keytype: params[:keytype] || 'ssh-rsa',
    comment: params[:comment] || params[:name]
  }

  assert_key(ssh_key[:key]) unless params[:validate_key] == false
  assert_keytype(ssh_key[:keytype])
  assert_comment(ssh_key[:comment])

  path = ::File.join(home, '.ssh', 'authorized_keys')

  # Avoid CHEF-3694 warning for .ssh directory.
  dir = ::File.dirname(path)

  begin
    resources(directory: dir)
  rescue Chef::Exceptions::ResourceNotFound
    directory dir do
      recursive true
      owner user
      group group
      mode '00700'
    end
  end

  # Accumulator Pattern:
  # http://docs.chef.io/definitions.html#many-recipes-one-definition
  t =
    begin
      resources(template: path)
    rescue Chef::Exceptions::ResourceNotFound
      template path do
        variables keys: {}
      end
    end
  t.cookbook('ssh_authorized_keys')
  t.source('authorized_keys.erb')
  t.owner(user)
  t.group(group)
  t.mode('00600')
  t.variables[:keys][ssh_key[:comment]] = ssh_key
  # Sort file content by comment field: Calling the same ssh_authorized_keys in
  # different order produces the same result.
  t.variables[:keys] = Hash[t.variables[:keys].sort]

  # For notifications support (only works in Chef 12).
  # @example
  #   my_definition = ssh_authorize_key 'bob@acme.com' { ... }
  #   my_definition.notifies :run, 'execute[thing]'
  t
end
