require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AppSettings" do
  describe '[]' do
    it "should support single keys" do
      AppSettings['domains/legacy'].should == 'www.AppSettings.com'
    end
  
    it "should support nested keys" do
      AppSettings[:items_per_page].should == 50
    end
    
    it "should not die on keys that don't exist" do
      lambda {
        AppSettings['a/b/c/d/e/f/g'].should be_nil
      }.should_not raise_error
    end
  end

  describe '.value' do
    it "should work" do
      AppSettings.domains['legacy'].should == 'www.AppSettings.com'
    end
  end
end
