# encoding: UTF-8
#
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

require 'spec_helper'
require 'template_helpers.rb'

describe SshAuthorizedKeysCookbook::TemplateHelpers, order: :random do
  let(:helpers_class) do
    klass = Class.new
    klass.send(:include, described_class)
    klass
  end
  let(:helpers) { helpers_class.new }

  context '#render_option_value' do
    option = 'option_name'
    {
      true => option,
      1 => %(#{option}="1"),
      'NAME=value 1' => %(#{option}="NAME=value 1"),
      'NAME="value"' => %(#{option}="NAME=\\"value\\""),
      'NAME="va\nlue"' => %(#{option}="NAME=\\"va\\\\nlue\\"")
    }.each do |value, result|
      it "returns #{result.inspect} for #{value.inspect}" do
        expect(helpers.render_option_value(option, value)).to eq(result)
      end
    end # each value, string
  end # context #render_keys

  context '#render_options' do
    let(:options) do
      {
        'no-agent-forwarding' => true,
        'environment' => 'DISPLAY=:0'
      }
    end
    it 'renders options correctly' do
      result = 'no-agent-forwarding,environment="DISPLAY=:0"'
      expect(helpers.render_options(options)).to eq(result)
    end
  end

  context '#render_keys' do
    it 'merges keytype, key and comment as a string' do
      expect(helpers.render_key('A', 'B', 'C')).to eq('A B C')
    end
  end # context #render_keys
end
