
resource "aws_sqs_queue" "queue" {
  name                      = var.fifo_queue == true ? "${var.env}-${var.queue_name}.fifo" : "${var.env}-${var.queue_name}-queue"
  fifo_queue                = var.fifo_queue
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
  redrive_policy = var.dead_letter_queue == true ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue[0].arn
    maxReceiveCount     = 3
  }):0

  tags = {
    env  = var.env
    Name = "${var.env}-${var.queue_name}-queue"
  }
}


resource "aws_sqs_queue" "dead_letter_queue" {
  count                     = var.dead_letter_queue == true ? 1:0
  fifo_queue                = var.fifo_queue
  name                      = var.fifo_queue == true ? "${var.env}-${var.queue_name}-dead-letter.fifo" : "${var.env}-${var.queue_name}-dead-letter-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0

  tags = {
    env  = var.env
    Name = "${var.env}-${var.queue_name}-dead-letter-queue" 
    }
}
