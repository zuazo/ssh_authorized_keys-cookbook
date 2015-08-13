# encoding: UTF-8
#
# Cookbook Name:: ssh_authorized_keys
# Library:: template_helpers
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

# `ssh_authorized_keys` internal classes.
module SshAuthorizedKeysCookbook
  # Some helpers to use from `ssh_authorized_keys` cookbook templates.
  #
  # @example
  #   self.class.send(:include, ::SshAuthorizedKeysCookbook::TemplateHelpers)
  #   render_key('ssh-rsa', 'AAA...', 'sysadmin')
  #   #=> "ssh-rsa AAA... sysadmin"
  module TemplateHelpers
    # Returns the SSH key option properly escaped.
    #
    # @param name [String] option name.
    # @param value [String, true] option value. Use `true` for option flags.
    # @return [String] string representation of the SSH key option.
    # @example
    #   render_option_value('environment', 'NAME=value')
    #   #=> "environment=\"NAME=value\""
    def render_option_value(name, value)
      return name.to_s if value == true
      value_escaped = value.to_s.gsub('\\', '\\\\\\\\').gsub('"', '\\"')
      %(#{name}="#{value_escaped}")
    end

    # Returns the SSH key option list properly formated.
    #
    # @param options [Hash] the option list as key value hash.
    # @return [String] string representation of the option list properly
    #   escaped.
    # @example
    #   options = {
    #     'no-agent-forwarding' => true,
    #     'environment' => 'DISPLAY=:0'
    #   }
    #   render_options(options)
    #   #=> "no-agent-forwarding,environment=\"DISPLAY=:0\""
    def render_options(options)
      options.map { |name, value| render_option_value(name, value) }.join(',')
    end

    # Returns a rendered key line for the *authorized_keys* file.
    #
    # @param keytype [String] SSH key type.
    # @param key [String] SSH public key in base64.
    # @param comment [String] key comment or description.
    # @return [String] the *authorized_keys* file line.
    # @example
    #   render_key('ssh-rsa', 'AAA...', 'sysadmin')
    #   #=> "ssh-rsa AAA... sysadmin"
    def render_key(keytype, key, comment)
      "#{keytype} #{key} #{comment}"
    end
  end
end
