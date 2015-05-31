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

	context 'Should compile with no arguments' do
		let(:pre_condition) { 'Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }' }
		it { should compile }
	end
end
