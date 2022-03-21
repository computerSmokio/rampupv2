#!/bin/bash
terraform -chdir=/home/mavargas/rampup-part-II/tf-setup-services destroy -auto-approve
terraform -chdir=/home/mavargas/rampup-part-II/tf-setup-fundation destroy -auto-approve
