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
require 'resource_helpers.rb'

describe SshAuthorizedKeysCookbook::ResourceHelpers, order: :random do
  let(:helpers_class) do
    klass = Class.new
    klass.send(:include, described_class)
    klass
  end
  let(:helpers) { helpers_class.new }
  let(:node) do
    node = Chef::Node.new
    Dir.glob("#{::File.dirname(__FILE__)}/../../attributes/*.rb") do |f|
      node.from_file(f)
    end
    node
  end
  before { allow(helpers).to receive(:node).and_return(node) }

  context '#assert_user' do
    it 'does not raise an exception for valid strings' do
      expect { helpers.assert_user('bob') }.to_not raise_error
    end

    it 'raises an exception for empty string' do
      expect { helpers.assert_user('') }
        .to raise_error(/ssh_authorize_key: user parameter must be a valid/)
    end

    it 'raises an exception for wrong types' do
      expect { helpers.assert_user(Object.new) }
        .to raise_error(/ssh_authorize_key: user parameter must be a valid/)
    end
  end # context #assert_user

  context '#assert_key' do
    let(:key) do
      'AAAAB3NzaC1yc2EAAAADAQABAAABAQCsH9DvJxgTglpJtCzKzo+WcqLf5H+IR2Iv0ntBgxc'\
      'huMPpFJKSuzBjgLFzq16xqXkBuGh9hL18LjIbMNH1GXLCfgnuU7S6HF9w4FFDAYY+EUH/M8'\
      'n99jWiNyk/0K1ruvLzJJM0DBFzZ64fHtEx0YcOVl0pw0ZBz75nJuEh2o1VaABqmQA+FpjrR'\
      '+sId/OqXusVjqxdeV1fOf46RCL9Y4tO41k7F358UCywp2Zhnas51QaER+mh6imb/H7YwcfC'\
      'ZmJ/BB13G7iwvlmi5ANRCD/NNX1DBqWsG2UYVO06ZEg3LoRTF1pmLp2cuvObdz36AQgk8IJ'\
      'Uop9RlH/5vrofLF3p'
    end

    it 'does not raise an exception for valid keys' do
      expect { helpers.assert_key(key) }.to_not raise_error
    end

    it 'raises an exception for incomplete keys' do
      expect { helpers.assert_key(key[0..-2]) }
        .to raise_error(/ssh_authorize_key: key parameter must be a valid/)
    end

    it 'raises an exception for wrong types' do
      expect { helpers.assert_key(Object.new) }
        .to raise_error(/ssh_authorize_key: key parameter must be a valid/)
    end
  end # context #assert_key

  context '#assert_keytype' do
    %w(
      ecdsa-sha2-nistp256
      ecdsa-sha2-nistp384
      ecdsa-sha2-nistp521
      ssh-ed25519
      ssh-dss
      ssh-rsa
    ).each do |keytype|
      it "does not raise an exception for #{keytype.inspect}" do
        expect { helpers.assert_keytype(keytype) }.to_not raise_error
      end
    end # each keytype

    [
      nil,
      1,
      Object.new,
      'ssh-bad'
    ].each do |keytype|
      it "raises an exception for #{keytype.inspect}" do
        expect { helpers.assert_keytype(keytype) }
          .to raise_error(/^ssh_authorize_key: keytype parameter must be/)
      end
    end # each keytype
  end # context #assert_keytype

  context '#assert_comment' do
    it 'does not raise an exception for valid comments' do
      expect { helpers.assert_comment('bob@acme.com') }.to_not raise_error
    end

    it 'raises an exception for wrong comments with new lines' do
      expect { helpers.assert_comment("comment\n with new line") }
        .to raise_error(/^ssh_authorize_key: comment parameter must be/)
    end

    it 'raises an exception for wrong types' do
      expect { helpers.assert_comment(Object.new) }
        .to raise_error(/^ssh_authorize_key: comment parameter must be/)
    end
  end # context #assert_comment

  context '#user_home' do
    let(:home) { '/specialhome/bob' }
    let(:user) do
      require 'etc'
      Etc::Passwd.new('bob', 'x', 1000, 1000, 'bob,,,', home)
    end

    it 'returns system user home' do
      expect(Etc).to receive(:getpwnam).with('bob').and_return(user)
      expect(helpers.user_home('bob')).to eq(home)
    end

    context 'when user does not exist' do
      before do
        expect(Etc).to receive(:getpwnam).with('bob')
          .and_raise(ArgumentError.new)
        allow(Chef::Log).to receive(:warn)
      end

      it 'prints a Chef warning' do
        expect(Chef::Log).to receive(:warn)
          .with(/^ssh_authorize_key: User .* not found at compile time/).once
        helpers.user_home('bob')
      end

      it 'returns /home/${user} path' do
        expect(helpers.user_home('bob')).to eq('/home/bob')
      end
    end
  end

  context '#user_group' do
    let(:user) do
      require 'etc'
      Etc::Passwd.new('bob', 'x', 1000, 1000, 'bob,,,')
    end

    it 'returns system user group' do
      expect(Etc).to receive(:getpwnam).with('bob').and_return(user)
      expect(helpers.user_group('bob')).to eq(1000)
    end

    context 'when user does not exist' do
      before do
        expect(Etc).to receive(:getpwnam).with('bob')
          .and_raise(ArgumentError.new)
        allow(Chef::Log).to receive(:warn)
      end

      it 'prints a Chef warning' do
        expect(Chef::Log).to receive(:warn)
          .with(/^ssh_authorize_key: User .* not found at compile time/).once
        helpers.user_group('bob')
      end

      it 'returns ${user}' do
        expect(helpers.user_group('bob')).to eq('bob')
      end
    end
  end
end
