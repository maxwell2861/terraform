module "test-1" {
source = "../modules/application/sqs"
 env                       = var.env
 fifo_queue                = local.user_support_service["fifo_queue"]
 queue_name                = local.user_support_service["queue_name"]
 dead_letter_queue         = local.user_support_service["dead_letter_queue"]
}


module "beta-flash-timer-notice" {
source = "../modules/application/sqs"
 env                       = var.env
 fifo_queue                = local.flash-timer-notice["fifo_queue"]
 queue_name                = local.flash-timer-notice["queue_name"]
 dead_letter_queue         = local.flash-timer-notice["dead_letter_queue"]
}


module "beta-flash-subscription-notice" {
source = "../modules/application/sqs"
 env                       = var.env
 fifo_queue                = local.flash-subscription-notice["fifo_queue"]
 queue_name                = local.flash-subscription-notice["queue_name"]
 dead_letter_queue         = local.flash-subscription-notice["dead_letter_queue"]
}
