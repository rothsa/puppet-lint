require 'spec_helper'

describe 'right_lbrace_whitespace' do
  let(:msg) { 'space needed on right side of opening bracket' }

  context 'with fix disabled' do
    context 'resource with wrong number of spaces between title and bracket' do
      let(:code) { "
        file {'/tmp/bad3': ensure => file; }"
      }

      it 'should only detect one problem' do
        expect(problems).to have(1).problem
      end

      it 'should create two warnings' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(15)
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

    context 'resource with wrong number of spaces between title and bracket' do
      let(:code) { "
        file {'/tmp/bad3': ensure => file; }"
      }
      let(:fixed) { "
        file { '/tmp/bad3': ensure => file; }"
      }

      it 'should only detect one problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the manifest' do
        expect(problems).to contain_fixed(msg).on_line(1).in_column(15)
      end

      it 'should adjust the title whitespace' do
        expect(manifest).to eq(fixed) 
      end
    end
  end
end
