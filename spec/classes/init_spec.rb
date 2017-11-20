require 'spec_helper'
describe 'limp' do
  context 'with default values for all parameters' do
    it { should contain_class('limp') }
  end
end
