require 'spec_helper'

describe 'vault' do
  RSpec.configure do |c|
    c.default_facts = {
      :architecture    => 'x86_64',
      :operatingsystem => 'Ubuntu',
      :lsbdistrelease  => '10.04',
      :kernel          => 'Linux',
    }
  end

  let(:pre_condition) { 'Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }' }
  context 'Should compile with no arguments' do
    it { should compile }
  end

  context 'properly escaped shellwords debian' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'debian',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init.d/vault').with_content(%r{^DAEMON_ARGS=\( server -config /etc/vault foo bar baz\\ baz\\ baz \)})}
  end

  context 'properly escaped shellwords sles' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'sles',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init.d/vault').with_content(%r{server -config "\$CONFIG_DIR" foo bar baz\\ baz\\ baz})}
  end

  context 'properly escaped shellwords systemd' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'systemd',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/lib/systemd/system/vault.service').with_content(%r{-config /etc/vault foo bar baz\\ baz\\ baz})}
  end

  context 'properly escaped shellwords launchd' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz <baz> baz'],
      :init_style    => 'launchd',
      :backend       => {},
      :listener      => {},
    }}
    it {
      should contain_file('/Library/LaunchDaemons/io.vaultproject.daemon.plist') \
        .with_content(%r{<string>foo</string>\n\s*<string>bar</string>\n\s*<string>baz &lt;baz&gt; baz</string>})
    }
  end

  context 'properly escaped shellwords sysv' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'sysv',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init.d/vault').with_content(%r{server -config "\$CONFIG" foo bar baz\\ baz\\ baz})}
  end

  context 'properly escaped shellwords upstart' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'upstart',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init/vault.conf').with_content(%r{server -config "\$CONFIG" foo bar baz\\ baz\\ baz})}
  end
end
