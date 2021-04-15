#--------------------------------------------------------------
# Output Redis
#--------------------------------------------------------------

#Redis

output "prod_cache_w_endpoint"              { value = module.prod-test-redis.w_endpoint}
output "prod_cache_r_endpoint"              { value = module.prod-test-redis.r_endpoint}
