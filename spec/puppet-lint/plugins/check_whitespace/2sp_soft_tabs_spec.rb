require 'spec_helper'

describe '2sp_soft_tabs' do
  let(:msg) { 'two-space soft tabs not used' }

  context 'when a line is indented by 3 spaces' do
    let(:code) { "
file { 'foo':
   foo => bar,
}"
    }

    it 'should only detect a single problem' do
      expect(problems).to have(1).problem
    end

    it 'should create an error' do
      expect(problems).to contain_error(msg).on_line(3).in_column(1)
    end
  end
  
  context 'when a line is indented by 4 spaces' do
    let(:code) { "
class foo {
    $bar = 'Hello world',
}"
    }

    it 'should only detect a single problem' do
      expect(problems).to have(1).problem
    end

    it 'should create an error' do
      expect(problems).to contain_error(msg).on_line(2).in_column(1)
    end
  end
  
  context 'should not detect a problem with nested indents' do
    let(:code) { "
class {
  'foo_deep':
     param => 'bar',
}"
    }

    it 'should not detect any problem' do
      expect(problems).to have(0).problem
    end
  end

  context 'should not detect a problem when two indents are implemented on one line' do
    let(:code) { "
      class {'foo': bar => [
          'var1',
          'var2',
      ],
      }"
    }

    it 'should not detect any problem' do
      expect(problems).to have(0).problem
    end
  end
end
