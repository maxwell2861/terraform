#--------------------------------------------------------------
# Output Redis
#--------------------------------------------------------------

#Redis

output "dev_cache_w_endpoint"              { value = module.dev-test-redis.w_endpoint}
output "dev_cache_r_endpoint"              { value = module.dev-test-redis.r_endpoint}
