require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AppSettings" do
  before(:each) do
    @settings = AppSettings.new(File.join(File.dirname(__FILE__), %w(.. example_config/example_for_rails.yml)))
  end
  
  describe '[]' do
    it "should support single keys" do
      @settings['domains/legacy'].should == 'www.AppSettings.com'
    end
  
    it "should support nested keys" do
      @settings[:items_per_page].should == 50
    end
    
    it "should not die on keys that don't exist" do
      lambda {
        @settings['a/b/c/d/e/f/g'].should be_nil
      }.should_not raise_error
    end
  end

  describe '.value' do
    it "should work" do
      @settings.domains['legacy'].should == 'www.AppSettings.com'
    end
  end
end
