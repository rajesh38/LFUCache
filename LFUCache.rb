class LFUCache
  def initialize(name:, size:)
    @cache_name = name
    @cache_limit = size
    @cache_count = 0
    @cache_store = {}
    @cache_count_keys_map = {}
    @least_hit_count = 1
  end
  
  def put(key:, value:)
    delete_least_used_key
    set_counters_for_key(key: key)
    @cache_store[key] = {
      value: value,
      hit_count: 1
    }
  end
  
  def get(key:)
    increment_hit_count(key: key)
    @cache_store[key] && @cache_store[key][:value]
  end
  
  private
  
  def increment_hit_count(key:)
    if @cache_store.key?(key)
      current_hit_count = @cache_store[key][:hit_count]
      new_hit_count = current_hit_count + 1
      @cache_store[key][:hit_count] = new_hit_count
      current_index = @cache_count_keys_map[current_hit_count].index(key)
      @cache_count_keys_map[current_hit_count].delete_at(current_index)
      @cache_count_keys_map.delete(current_hit_count) if @cache_count_keys_map[current_hit_count].size == 0
      @cache_count_keys_map[new_hit_count] ||= []
      @cache_count_keys_map[new_hit_count] << key
      if !@cache_count_keys_map.key?(@least_hit_count) || new_hit_count < @least_hit_count
        @least_hit_count = new_hit_count
      end
    end
  end
  
  def set_counters_for_key(key:)
    if @cache_store.key?(key)
      existing_hit_count = @cache_store[key][:hit_count]
      if @cache_count_keys_map.key?(existing_hit_count)
        key_index = @cache_count_keys_map[existing_hit_count].index(key)
        if key_index
          @cache_count_keys_map[existing_hit_count].delete_at(key_index)
          if @cache_count_keys_map[existing_hit_count].size == 0
            @cache_count_keys_map.delete(existing_hit_count)
          end
          @cache_count -= 1
        end
      end
    end
    @cache_count_keys_map[1] ||= []
    @cache_count_keys_map[1] << key
    @cache_count += 1
  end
  
  def delete_least_used_key
    return if @cache_limit > @cache_count
    key_to_delete = @cache_count_keys_map[@least_hit_count][0]
    @cache_store.delete(key_to_delete)
    @cache_count_keys_map[@least_hit_count].delete_at(0)
    @cache_count -= 1
    if @cache_count_keys_map[@least_hit_count].size == 0
      @cache_count_keys_map.delete(@least_hit_count)
    end
  end
end