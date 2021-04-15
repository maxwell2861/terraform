#--------------------------------------------------------------
# Output IOS ELB Resource
#--------------------------------------------------------------

#Game Cache
output "game_cache_endpoint"              { value = module.stg-game-cache.endpoint}

