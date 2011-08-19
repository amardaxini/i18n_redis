i18n_redis gem 
==================
Gem is use full migrate existing YAML based i18n solution to Redis based solution.

### Requirement
- redis server
- redis gem
- gem 'i18n_redis'

### Methods
- Connect to redis databse using redis gem 
   `I18nRedis.connect`

- Convert Existing YAML To Redis Database It can be use full for any YAML to Redis
	> I18nRedis.yaml_to_redis(yaml_file_path)
- Add new locale
	> I18nRedis.add_locale(name,value)
e.g
  - Add us locale
	> I18nRedis.add_locale("us")
  - Add us locale for id id may be user id company id etc.
	> I18nRedis.add_locale("23","us")

- Get all locale It will return locale hash
	> I18nRedis.get_locales
- Remove locale
	> I18nRedis.remove_locale("us")
- Add Key
	> I18nRedis.add(key,value,locale)
	> I18nRedis.create(key,value)
- 
- Remove Key
	> I18nRedis.remove(key,locale)
	> I18nRedis.destroy(key)	

- Find Key
	> I18nRedis.find(key)

- Find all for locale
   	> I18nRedis.find_all_for_locale(locale)
	> I18nRedis.find_all(key)

- Copy one locale to another locale
	> I18nRedis.copy_locale_to_other(src_locale,dest_locale)

- Clone data for all locale It will load master data to all present locale
   	> I18nRedis.clone_data_for_all_locale(i18n_key,master_locale="en")

- Search and Replace I18n Value 
	> I18nRedis.search_and_replace_word(search_value,replace_value,locale=nil)

If locale is nil it will replace all value otherwise it will replace for particular locale







 




