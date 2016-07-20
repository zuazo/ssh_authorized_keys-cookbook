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

describe 'ssh_authorized_keys_test::default', order: :random do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }

  it 'creates bob user' do
    expect(chef_run).to create_user('bob')
      .with_supports(manage_home: true)
      .with_home('/home/bob')
  end

  it 'creates bob group' do
    expect(chef_run).to create_group('bob')
      .with_members(%w(bob))
  end

  it 'creates bob2 user' do
    expect(chef_run).to create_user('bob2')
      .with_supports(manage_home: true)
      .with_home('/home/bob2')
  end

  it 'creates bob2 group' do
    expect(chef_run).to create_group('bob2')
      .with_members(%w(bob2))
  end

  it 'creates alice user' do
    expect(chef_run).to create_user('alice')
      .with_supports(manage_home: true)
      .with_home('/home/alice')
  end

  it 'creates alice group' do
    expect(chef_run).to create_group('alice')
      .with_members(%w(alice))
  end

  it 'creates ~bob/.ssh directory recursively' do
    expect(chef_run).to create_directory('/home/bob/.ssh')
      .with_recursive(true)
      .with_owner('bob')
      .with_group('bob')
      .with_mode('00700')
  end

  it 'creates ~bob/.ssh/authorized_keys file' do
    expect(chef_run).to create_template('/home/bob/.ssh/authorized_keys')
      .with_cookbook('ssh_authorized_keys')
      .with_source('authorized_keys.erb')
      .with_owner('bob')
      .with_group('bob')
      .with_mode('00600')
  end

  it 'authorizes bob@acme.com to login as bob' do
    expect(chef_run).to render_file('/home/bob/.ssh/authorized_keys')
      .with_content(%r{^ssh-rsa [A-Za-z0-9+/=]+ bob@acme\.com$})
  end

  it 'authorizes bob@home.com to login as bob' do
    expect(chef_run).to render_file('/home/bob/.ssh/authorized_keys')
      .with_content(%r{^ssh-rsa [A-Za-z0-9+/=]+ bob@home\.com comment$})
  end

  it 'creates ~bob2/.ssh directory recursively' do
    expect(chef_run).to create_directory('/home/bob2/.ssh')
      .with_recursive(true)
      .with_owner('bob2')
      .with_group('bob2')
      .with_mode('00700')
  end

  it 'creates ~bob2/.ssh/authorized_keys file' do
    expect(chef_run).to create_template('/home/bob2/.ssh/authorized_keys')
      .with_cookbook('ssh_authorized_keys')
      .with_source('authorized_keys.erb')
      .with_owner('bob2')
      .with_group('bob2')
      .with_mode('00600')
  end

  it 'authorizes bob@acme.com to login as bob2' do
    expect(chef_run).to render_file('/home/bob2/.ssh/authorized_keys')
      .with_content(%r{^ssh-rsa [A-Za-z0-9+/=]+ bob@acme\.com$})
  end

  it 'authorizes bob@home.com to login as bob2' do
    expect(chef_run).to render_file('/home/bob2/.ssh/authorized_keys')
      .with_content(%r{^ssh-rsa [A-Za-z0-9+/=]+ bob@home\.com comment$})
  end

  it 'writes bob2 keys in the same order as bob keys' do
    file1 = chef_run.template('/home/bob/.ssh/authorized_keys')
    content1 = ChefSpec::Renderer.new(chef_run, file1).content
    expect(chef_run).to render_file('/home/bob2/.ssh/authorized_keys')
      .with_content(content1)
  end

  it 'creates ~alice/.ssh directory recursively' do
    expect(chef_run).to create_directory('/home/alice/.ssh')
      .with_recursive(true)
      .with_owner('alice')
      .with_group('alice')
      .with_mode('00700')
  end

  it 'creates ~alice/.ssh/authorized_keys file' do
    expect(chef_run).to create_template('/home/alice/.ssh/authorized_keys')
      .with_cookbook('ssh_authorized_keys')
      .with_source('authorized_keys.erb')
      .with_owner('alice')
      .with_group('alice')
      .with_mode('00600')
  end

  it 'authorizes alice@acme.com to login as alice including options' do
    options =
      'no-port-forwarding,no-agent-forwarding,no-X11-forwarding,'\
      'command="echo \'Please login as the user \"bob\" rather than the user '\
      '\"alice\".\';echo;sleep 10"'
    expect(chef_run).to render_file('/home/alice/.ssh/authorized_keys')
      .with_content(
        %r{^#{Regexp.escape(options)} ssh-rsa [A-Za-z0-9+/=]+ alice@acme\.com$}
      )
  end

  it 'creates ~root/.ssh directory' do
    expect(chef_run).to create_directory('/root/.ssh')
      .with_mode('00700')
  end

  it 'creates ~root/.ssh/key2 file' do
    expect(chef_run).to create_file('/root/.ssh/key2')
      .with_mode('00600')
  end
end
