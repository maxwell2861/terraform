#----------------------------------------------
# Network Resource
#----------------------------------------------
variable "prefix"           {default = "test"}
variable "region_id"        {default = "ap-northeast-2"} 

#----------------------------------------------
# SQS Variables
#----------------------------------------------

locals{

    user_support_service = {
        queue_name        = "test-1"
        dead_letter_queue = true
        fifo_queue        = false
    }
    
    flash-timer-notice = {
        queue_name        = "test-2"
        dead_letter_queue = true
        fifo_queue        = true
    }
    
    flash-subscription-notice = {
        queue_name        = "test-3"
        dead_letter_queue = true
        fifo_queue        = true
    }



}