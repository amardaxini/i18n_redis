require 'rubygems'
require 'redis'
require_relative "i18n_redis/version"


module I18nRedis

# Connect To Redis
 def self.connect(args={})
   $i18n_redis = Redis.new(args)
 end

  # YAML TO REDIS
  # yaml to redis for i18n
  # file name is "/abc/en.yml"
  def self.yaml_to_redis(file_name)

    if File.exist?(file_name)
      yaml_hash = YAML::load(File.open(file_name))
      yaml_hash.each do |k,v|
        #have to force key to_string because of some funny keys (eg. true/false)
        k = k.to_s
      # if yaml data  contain further nested then create nestedkey or add key to redis
        self.add_value_to_redis(yaml_hash[k],k)
      end
    end
  end

  # en.
  #  errors:
  #    template:
  #      header: "%{count} errors prohibited this %{model} from being saved"
  # This method generates following key and set its respective value
  # en.errors.template.header="%{count} errors prohibited this %{model} from being saved"
  def self.add_value_to_redis(yaml_hash,yaml_key)
    if yaml_hash.is_a?(Hash)
      yaml_hash.each do |key,value|
        key = key.to_s
        value = value.to_s
        if value == ""
          value = "MISSING_TRANSLATION"
        end
       if yaml_hash[key].is_a?(Hash)
         add_value_to_redis(yaml_hash[key],yaml_key+"."+key)
       else
         create(yaml_key+"."+key,value)
       end
      end
    else
      yaml_hash = yaml_hash.to_s
      if yaml_hash == ""
        yaml_hash = "MISSING_TRANSLATION"
      end
      create(yaml_key,yaml_hash)
    end
  end


  # Add to en(master) it will add to all company
  # locale is a redis hash which contain default key and value as locale name
  # or it can be user id company id etc
  # any data is added to master it will find all the respective company and add data
  # key can be en.label_text

  def self.add_to_all_locale(key,val)
    locale_array = $i18n_redis.hgetall("locale")
    locale_array.each do |lkey,lvalue|
      create("#{lvalue}.#{key}",val)
    end
  end

  # for removing data from all locale
  def self.remove_from_all_locale(key)
    # key abc.xyz
    locale_array = $i18n_redis.hgetall("locale")
    locale_array.each do |ckey,cvalue|
      destroy("#{cvalue}.#{key}")
    end
  end



  #This contain name = "user name or id",value en_20
  def self.add_locale(name,value)
    value = value ? value : name
    $i18n_redis.hset("locale",name,value)
  end

  #This contain name = "company name or id"
  def self.remove_locale(name)
    $i18n_redis.hdel("locale",name)
  end

  # find out word and replace it throughout all locale
  def self.search_and_replace_word(search_value,replace_value,locale=nil)
    i18n_keys = find_all("#{locale}*")
    i18n_keys.each do |i18n_key|
     value = $i18n_redis.get(i18n_key)
     value.gsub!(/\b#{search_value}\b/,replace_value)
     create(i18n_key,value)
    end
  end

  # copy one locale data to all present locale
  def self.clone_data_for_all_locale(i18n_key,master_locale="en")
   # find out all master keys i.e en
    master_keys= find_all("#{master_locale}.*")
    master_keys.each do |key|
      clone_key = "#{i18n_key}.#{key.split('.').drop(1).join(".")}"
      create(clone_key,$i18n_redis.get(key))
    end
  end

  # Copy One Locale to Other
  # en to us

  def self.copy_locale_to_other(src_locale,dest_locale)
    src_keys= find_all("#{src_locale}.*")
    src_keys.each do |key|
      clone_key = "#{dest_locale}.#{key.split('.').drop(1).join(".")}"
      create(clone_key,$i18n_redis.get(key))
    end
  end

  # Clone only the keys that are missing from one locale to another
  # Example:
  # you have en.roles.administrator: administrator it copies empty string to the
  # desired language like:
  # es.roles.administrator: ""

  def self.create_missing_keys_for_locale(src_locale="en",dest_locale, key_value)
    # first we get all the keys for src locale and omit the locale
    src_keys = self.find_all_for_locale(src_locale).map {|k| k.split('.').drop(1).join('.')}
    dst_keys = self.find_all_for_locale(dest_locale).map {|k| k.split('.').drop(1).join('.')}
    diff_keys = src_keys - dst_keys
    diff_keys.each do |k|
      self.add(k, key_value, dest_locale)
    end
  end
  def self.find_all_for_locale(locale)
    self.find_all("#{locale}.*")
  end

  def self.find_all(key)
    $i18n_redis.keys(key)
  end

  # get all locale hashes
  def self.get_locales
    $i18n_redis.hgetall("locale")
  end

 # add key
  def self.add(key,value,locale)
    key = "#{locale}.#{key}" if locale
    self.create(key,value)
  end
  # add to redis
  def self.create(key,value)
     $i18n_redis.set(key,value)
  end

  # remove from redis
  #  remove("text_label","us")
  def remove(key,locale)
    key = "#{locale}.#{key}" if locale
    self.destroy(key)
  end

  # remove from redis
  def self.destroy(key)
    $i18n_redis.del(key)
  end

  # get data from redis
  def self.find(key)
    $i18n_redis.get(key)
  end

end

