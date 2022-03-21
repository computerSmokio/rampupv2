resource "aws_lb" "load_balancers" {
  name               = var.loadb_description.name
  internal           = var.loadb_description.isInternal
  load_balancer_type = var.loadb_description.type
  subnets            = var.loadb_description.subnets

  enable_deletion_protection = false
  tags = var.loadb_description.tags
}

resource "aws_lb_target_group" "target_group" {
  name        = var.target_description.name
  port        = var.target_description.port
  protocol    = var.target_description.protocol
  target_type = var.target_description.type
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "target_group" {
  count = length(var.target_description.targets)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.target_description.targets[count.index].ip
  port             = var.target_description.targets[count.index].port
}

resource "aws_lb_listener" "cluster_listener" {
   load_balancer_arn    = aws_lb.load_balancers.arn
   port                 = "80"
   protocol             = "TCP"
   default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}