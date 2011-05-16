require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tempfile'
require 'sqlite3'

describe "Chatterbot::DB" do
  before(:each) do
    @db_tmp = Tempfile.new("config.db")
    @db_uri = "sqlite://#{@db_tmp.path}"

    @bot = Chatterbot::Bot.new    
    @bot.config[:db_uri] = @db_uri
  end
  
  describe "table creation" do
    [:blacklist, :tweets, :config].each do |table|
      it "should create table #{table}" do
        @bot.db
        @tmp_conn = Sequel.connect(@db_uri)
        @tmp_conn.tables.include?(table).should == true
      end
    end      
  end

  describe "store_database_config" do
    it "doesn't fail" do
      @bot = Chatterbot::Bot.new    
      @bot.config[:db_uri] = @db_uri

      @bot.db      
      @bot.store_database_config.should == true
    end
  end

  describe "add_to_blacklist" do
    it "adds to the blacklist table" do
      @bot = Chatterbot::Bot.new    
      @bot.config[:db_uri] = @db_uri

      @bot.db      
      
      @bot.add_to_blacklist("tester")
    end

    it "doesn't add a double entry" do
      @bot = Chatterbot::Bot.new    
      @bot.config[:db_uri] = @db_uri

      @bot.db      
      
      @bot.add_to_blacklist("tester")
      @bot.add_to_blacklist("tester")      
    end
    
  end
end