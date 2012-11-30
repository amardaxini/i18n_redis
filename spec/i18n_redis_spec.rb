require File.expand_path('spec/spec_helper')
require File.expand_path('lib/i18n_redis')

describe I18nRedis do
  before do
    # should probably mock this somehow
    @redis = I18nRedis.connect(db: 4)
    @it = I18nRedis
  end
  after do
    # we are going to flush the database after testing
    @redis.flushdb
  end
  describe "before inserting" do
    it "should have no keys inside" do
      @redis.keys.count.must_equal 0
    end
  end
  describe "locales" do
    before do
      @it.add_locale("test", "test")
    end
    it "should contain the inserted key within the locale" do
      @redis.hget("locale","test").must_equal "test"
    end
    it "should remove the locale with remove_locale" do
      @it.remove_locale("test")
      @redis.hget("locale","test").must_be_nil
    end
  end
end
