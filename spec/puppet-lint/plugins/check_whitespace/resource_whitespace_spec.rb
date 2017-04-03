require 'spec_helper'

describe 'resource_whitespace' do
  let(:msg) { 'incorrect resource declaration spacing found' }

   context 'resource with wrong number of spaces between resource type declaration and bracket' do
      let(:code) { "
        file{ '/tmp/bad2': ensure => file; }
        file   { '/tmp/bad5': ensure => file; }"
      }

      it 'should detect two problems' do
        expect(problems).to have(2).problem
      end

      it 'should create two warnings' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(14)
        expect(problems).to contain_warning(msg).on_line(2).in_column(14)
      end
    end
  end

  context 'with fix enabled' do
    before do
      PuppetLint.configuration.fix = true
    end

    after do
      PuppetLint.configuration.fix = false
    end

  context 'resource with wrong number of spaces between resource type declaration and bracket' do
    let(:code) { "
      file{ '/tmp/bad2': ensure => file; }
      file   { '/tmp/bad5': ensure => file; }"
    }
    
    let(:fixed) { "
      file { '/tmp/bad2': ensure => file; }
      file { '/tmp/bad5': ensure => file; }"
    }
      
    it 'should detect two problems' do
      expect(problems).to have(2).problem
    end

    it 'should create two resource type declaration warnings' do
      expect(problems).to contain_fixed(msg).on_line(1).in_column(13)
      expect(problems).to contain_fixed(msg).on_line(2).in_column(14)
    end

    it 'should adjust incorrect resource whitespace' do
      expect(manifest).to eq(fixed)
    end
  end
end
