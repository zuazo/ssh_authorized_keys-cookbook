# encoding: UTF-8
#
# Cookbook Name:: ssh_authorized_keys
# Library:: resource_helpers
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015-2016 Xabier de Zuazo
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

require 'etc'

# `ssh_authorized_keys` internal classes.
module SshAuthorizedKeysCookbook
  # Some helpers to use from `ssh_authorized_keys` cookbook resources and
  # definitions.
  #
  # @example
  #   self.class.send(:include, ::SshAuthorizedKeysCookbook::ResourceHelpers)
  #   user_home('vagrant') #=> "/home/vagrant"
  module ResourceHelpers
    unless defined?(::SshAuthorizedKeysCookbook::ResourceHelpers::SSH_KEY_REGEX)
      # Regular expression for SSH public keys in base64.
      SSH_KEY_REGEX = %r{
        ^(?:[A-Za-z0-9+\/]{4})*(?:
          [A-Za-z0-9+\/]{2}==
          |[A-Za-z0-9+\/]{3}=
          |[A-Za-z0-9+\/]{4}
        )$
      }x
    end

    # Asserts that the user name is correct.
    #
    # @param user [String] user name.
    # @raise [Chef::Exceptions::ValidationFailed] if the user name is wrong.
    # @return void
    def assert_user(user)
      return if user.is_a?(String) && !user.empty?
      raise Chef::Exceptions::ValidationFailed,
            'ssh_authorize_key: user parameter must be a valid system user! '\
            "You passed #{user.inspect}."
    end

    # Asserts that the SSH public key is correct.
    #
    # @param key [String] public key in base64.
    # @raise [Chef::Exceptions::ValidationFailed] if the key is wrong.
    # @return void
    def assert_key(key)
      return if key.is_a?(String) && !SSH_KEY_REGEX.match(key).nil?
      raise Chef::Exceptions::ValidationFailed,
            'ssh_authorize_key: key parameter must be a valid SSH public key! '\
            "You passed #{key.inspect}."
    end

    # Returns allowed SSH key types list.
    #
    # @return [Array<String>] key types list.
    # @example
    #   allowed_keytypes
    #   #=> ["ecdsa-sha2-nistp256", "ecdsa-sha2-nistp384",
    #   #    "ecdsa-sha2-nistp521", "ssh-ed25519", "ssh-dss", "ssh-rsa"]
    def allowed_keytypes
      node['ssh_authorized_keys']['keytypes']
    end

    # Asserts that the SSH key type is correct.
    #
    # @param keytype [String] key type. Supported types are `'ssh-rsa'`,
    #   `'ssh-dss'`, `'ssh-ed25519'`, `'ecdsa-sha2-nistp521'`,
    #   `'ecdsa-sha2-nistp384'` and `'ecdsa-sha2-nistp256'`.
    # @raise [Chef::Exceptions::ValidationFailed] if the keytype is wrong.
    # @return void
    def assert_keytype(keytype)
      return if allowed_keytypes.include?(keytype)
      raise Chef::Exceptions::ValidationFailed,
            'ssh_authorize_key: keytype parameter must be equal to one of: '\
            "#{allowed_keytypes.join(', ')}! You passed #{keytype.inspect}."
    end

    # Asserts that the key comment is correct.
    #
    # @param comment [String] key comment or description.
    # @raise [Chef::Exceptions::ValidationFailed] if the comment is wrong.
    # @return void
    def assert_comment(comment)
      if comment.is_a?(String) && !comment.empty? && !comment.include?("\n")
        return
      end
      raise Chef::Exceptions::ValidationFailed,
            'ssh_authorize_key: comment parameter must be valid! You passed '\
            "#{comment.inspect}."
    end

    # Returns the home directory of a system user.
    #
    # If the user does not exist, it returns `"/home/#{user}"` as the home
    # directory and emits a Chef warning.
    #
    # @param user [String] user name.
    # @return [String] home directory.
    # @example
    #   user_home('root') #=> "/root"
    #   user_home('mail') #=> "/var/mail"
    #   user_home('bob')
    #   #WARN: ssh_authorize_key: User bob not found at compile time, perhaps
    #   #you should specify a home path. I will use "/home/bob" for now.
    #   #=> "/home/bob"
    def user_home(user)
      Etc.getpwnam(user).dir
    rescue ArgumentError
      home = ::File.join('', 'home', user)
      Chef::Log.warn(
        "ssh_authorize_key: User #{user} not found at compile time, perhaps "\
        "you should specify a home path. I will use #{home.inspect} for now."
      )
      home
    end

    # Returns the group of a system user.
    #
    # @param user [String] user name.
    # @return [Integer] gid.
    # @example
    #   user_group('root') #=> 0
    def user_group(user)
      Etc.getpwnam(user).gid
    rescue ArgumentError
      Chef::Log.warn(
        "ssh_authorize_key: User #{user} not found at compile time, perhaps "\
        "you should specify a default group. I will use #{user} for now."
      )
      user
    end
  end
end
