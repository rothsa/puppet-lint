require 'spec_helper'

describe 'user_instead_of_owner' do
  let(:msg) {'file resource does not use user field; use owner instead'}  
  
  before do
    PuppetLint.configuration.send("enable_file_owner")
  end
  context 'user field should cause a warning' do
    let(:code) { "file { 'foo': user => :root }" }

    it 'should only detect a single problem' do
      expect(problems).to have(1).problem
    end

    it 'should create a warning' do
      expect(problems).to contain_warning(msg).on_line(1).in_column(15)
    end
  end

  context 'owner field should not cause a problem' do
    let(:code) { "file { 'foo': owner => :root }" }
    
    it 'should not detect any problems' do
         expect(problems).to have(0).problem
    end
  end

  context 'user and owner should still cause a warning' do
    let(:code) { "file { 'foo': user => :root, owner => :root }" }
    
    it 'should only detect a single problem' do
      expect(problems).to have(1).problem
    end

    it 'should create a warning' do
      expect(problems).to contain_warning(msg).on_line(1).in_column(15)
    end
  end
end
