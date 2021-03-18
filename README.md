# LFUCache
This project includes the LFUCache class that will have the responsibility to handle in memory caching following the LFU(Least Frequently Used) algorithm

**Usage**

```
notification_cache = LFUCache.new(name: "notification", size: 3)
notification_cache.put(key: 1, value: 1)
notification_cache.put(key: 2, value: 2) 
notification_cache.put(key: 3, value: 3)
notification_cache.get(key: 2)
notification_cache.get(key: 1)
# To check the cache status; You should see all 3 keys are there in the cache
cache
# Insert one more key into the cache to check how the cache invalidation works for the key: 3 as it is the least recently used/accessed/written 
notification_cache.put(key: 4, value: 4)
# This is to show the basic functionality of how LFU algorithm works; Now play around with get and put method to explore all the corner use cases
```
