module "test-1" {
source = "../modules/application/sqs"
 env                       = var.env
 fifo_queue                = local.test-1["fifo_queue"]
 queue_name                = local.test-1["queue_name"]
 dead_letter_queue         = local.test-1["dead_letter_queue"]
}


module "test-2" {
source = "../modules/application/sqs"
 env                       = var.env
 fifo_queue                = local.test-2["fifo_queue"]
 queue_name                = local.test-2["queue_name"]
 dead_letter_queue         = local.test-2["dead_letter_queue"]
}


module "test-3" {
source = "../modules/application/sqs"
 env                       = var.env
 fifo_queue                = ltest-3["fifo_queue"]
 queue_name                = ltest-3["queue_name"]
 dead_letter_queue         = ltest-3["dead_letter_queue"]
}
