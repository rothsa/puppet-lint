require 'spec_helper'

describe 'title_whitespace' do
  let(:msg) { 'incorrect title spacing found' }

  context 'with fix disabled' do
    context 'resource with space between title and colon' do
      let(:code) { "file { '/tmp/bad1' : ensure => file; }" }

      it 'should only detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should create a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(4)
      end
    end

    context 'resource with wrong number of spaces between title and bracket' do
      let(:code) { "
        file{'/tmp/bad2': ensure => file; }
        file {'/tmp/bad3': ensure => file; }
        file {   '/tmp/bad6': ensure => file; }"
      }

      it 'should detect three problems' do
        expect(problems).to have(3).problem
      end

      it 'should create three warnings' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(1)
        expect(problems).to contain_warning(msg).on_line(2).in_column(1)
        expect(problems).to contain_warning(msg).on_line(3).in_column(1)
      end
    end

   context 'resource with wrong number of spaces between resource name and bracket' do
      let(:code) { "
        file{'/tmp/bad2': ensure => file; }
        file   { '/tmp/bad5': ensure => file; }"
      }

      it 'should detect two problems' do
        expect(problems).to have(3).problem
      end

      it 'should create two warnings' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(1)
        expect(problems).to contain_warning(msg).on_line(2.in_column(1)
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

    context 'resource with space between title and colon' do
      let(:code) { "file { '/tmp/bad1' : ensure => file; }" }

      it 'should only detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the manifest' do
        expect(problems).to contain_fixed(msg).on_line(1).in_column(4)
      end

      it 'should remove the title whitespace' do
        expect(manifest).to eq("file { '/tmp/good': ensure => file; }")
      end
    end

    context 'resource with wrong number of spaces between title and bracket' do
      let(:code) { "
        file{'/tmp/bad2': ensure => file; }
        file {'/tmp/bad3': ensure => file; }
        file {   '/tmp/bad6': ensure => file; }"
      }

      it 'should detect three problems' do
        expect(problems).to have(3).problem
      end

      it 'should fix the manifest' do
        expect(problems).to contain_fixed(msg).on_line(1).in_column(4)
        expect(problems).to contain_fixed(msg).on_line(1).in_column(4)
        expect(problems).to contain_fixed(msg).on_line(1).in_column(4)
      end

      it 'should remove the title whitespace' do
        
      end
    end

    context 'resource with wrong number of spaces between resource name and bracket' do
      let(:code) { "
        file{'/tmp/bad2': ensure => file; }
        file   { '/tmp/bad5': ensure => file; }"
      }
      let(:fixed) { "
        file { '/tmp/bad2': ensure => file; }
        file { '/tmp/bad5': ensure => file; }"
      }
      it 'should only detect a single problem' do
        expect(problems).to have(2).problem
      end

      it 'should create title warning' do
        expect(problems).to contain_fixed(msg).on_line(3).in_column(1)
        expect(problems).to contain_fixed(msg).on_line(3).in_column(1)
      end

      it 'should remove incorrect title whitespace' do
        expect(manifest).to eq(fixed)
      end
    end
  end
end
