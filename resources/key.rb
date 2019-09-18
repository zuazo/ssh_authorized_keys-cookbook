# encoding: UTF-8
#
# Cookbook:: ssh_authorized_keys
# Resource:: key
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

resource_name :ssh_authorize_key
default_action :create

property :instance_name, String, name_property: true
property :user, [Integer, String]
property :group, [Integer, String]
property :home, String
property :key, String
property :keytype, String, default: 'ssh-rsa'
property :comment, String
property :options, Hash
property :validate_key, [true, false], default: true

include SshAuthorizedKeysCookbook::TemplateHelpers
include SshAuthorizedKeysCookbook::ResourceHelpers

action :create do
  new_resource.comment ||= new_resource.instance_name
  new_resource.group ||= user_group(new_resource.user)
  new_resource.home ||= user_home(new_resource.user)
  assert_user(new_resource.user)

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
