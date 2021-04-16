#----------------------------------------------
# Network Resource
#----------------------------------------------
variable "env"                    {default = "prod"}

#------------------------------------------------
# EKS Create Variables
#------------------------------------------------
locals {
    common_info     = {
        prefix              = data.terraform_remote_state.common.outputs.prefix
        ssh_key             = data.terraform_remote_state.common.outputs.ssh_key
    }
    network_info   = {
        vpc_id              =  data.terraform_remote_state.common.outputs.prod_vpc_id
        vpc_cidr            =  data.terraform_remote_state.common.outputs.prod_vpc_cidr
        igw_id              =  data.terraform_remote_state.common.outputs.prod_igw_id
    }
    ip_info        = {
        test              = data.terraform_remote_state.common.outputs.test_office_ip
        test2              = data.terraform_remote_state.common.outputs.test2_office_ip
        open_vpn            = data.terraform_remote_state.common.outputs.open_vpn_ip
        rancher_ip          = data.terraform_remote_state.common.outputs.rancher_ip
    }

    cluster_info = {
    
        efk = {
            eks_cluster_name    = "${var.env}-${local.common_info.prefix}-efk"
            eks_cluster_version = "1.17"
            eks_node_type       = "c5.2xlarge"
            eks_cluster_role    = data.terraform_remote_state.common.outputs.eks_cluster_role
            eks_node_role       = data.terraform_remote_state.common.outputs.eks_node_role
            user_data           = file("./userdata/userdata.sh")
            desired_size        = "3"
            min_size            = "3"
            max_size            = "5"
        }

    }

    cluster_names = [for s in local.cluster_info : s.eks_cluster_name]

    #---------------------------------------------
    # Security Groups |Common|Service LB | HQ LB
    #---------------------------------------------
    sg_info  = {
    
        #common Rules
        common = {
                name        = "common"
                desc        = "test prod Network Common Rules"
                inbound_set = {
                    ssh = {
                        port        = 22
                        protocol    = "tcp"
                        desc = "prod-ssh-gateway"
                        cidr_block  = ["10.30.100.77/32"]
                    }
                    rancher = {
                        port        =  0
                        protocol    = -1
                        desc        = "Rancher Server"
                        cidr_block  = local.ip_info.rancher_ip
                    }
                    old_infra_network = {
                        port        = 0
                        protocol    = -1
                        desc        = "Old-Infra Network"
                        cidr_block  = ["10.30.0.0/16"]
                    }
                    prod_network = {
                        port        = 0
                        protocol    = -1
                        desc        = "prod Network"
                        cidr_block  = [local.network_info.vpc_cidr]
                    }
                }
        }

        service_lb = {
                name        = "service-lb"
                desc        = "test prod Network Service LB Rules"
                inbound_set = {
                    http = {
                        port        = 80
                        protocol    = "TCP"
                        desc = "HTTP Inbounds"
                        cidr_block  = ["0.0.0.0/0"]
                    }
                    https = {
                        port        = 443
                        protocol    = "TCP"
                        desc = "HTTPS Inbounds"
                        cidr_block  = ["0.0.0.0/0"]
                    }   
                }
        }
    
        hq_lb = {
                name        = "hq-lb"
                desc        = "test prod Network HQ LB Rules"
                inbound_set = {
                    http_test2 = {
                        port        = 80
                        protocol    = "TCP"
                        desc = "HTTP Inbounds test2 Office"
                        cidr_block  = local.ip_info.test2
                    }
                    https_test2 = {
                        port        = 443
                        protocol    = "TCP"
                        desc = "HTTPS Inbounds test2 Office"
                        cidr_block  = local.ip_info.test2
                    }
                    http_test = {
                        port        = 80
                        protocol    = "TCP"
                        desc = "HTTP Inbounds test Office"
                        cidr_block  = local.ip_info.test
                    }
                    https_open_vpn = {
                        port        = 443
                        protocol    = "TCP"
                        desc = "HTTPS Inbounds open_vpn "
                        cidr_block  = local.ip_info.open_vpn
                    }      
                    http_open_vpn = {
                        port        = 80
                        protocol    = "TCP"
                        desc = "HTTP Inbounds open_vpn "
                        cidr_block  = local.ip_info.open_vpn
                    }
                    https_open_vpn = {
                        port        = 443
                        protocol    = "TCP"
                        desc = "HTTPS Inbounds open_vpn "
                        cidr_block  = local.ip_info.open_vpn
                    }     
                }
        }

        redis = {
                name        = "redis"
                desc        = "test prod Network Redis Rules"
                inbound_set = {
                    redis = {
                        port        = 6379
                        protocol    = "TCP"
                        desc = "Inbounds Redis"
                        cidr_block  = [local.network_info.vpc_cidr]
                    }
                }
        }

        rds = {
                name        = "rds"
                desc        = "test prod Network RDS Rules"
                inbound_set = {
                    redis = {
                        port        = 3306
                        protocol    = "TCP"
                        desc = "Inbounds RDS"
                        cidr_block  = [local.network_info.vpc_cidr]
                    }
                }
        }
    }  
    /*
    #---------------------------------------------
    # Security Group Rules 
    #---------------------------------------------    
    sg_rule = {
        common = {
                    sg_id            =          module.prod-common-sg.sg_id
                    rules ={
                        old_prod_gitlab = {
                            port                     = 0
                            protocol                 = -1
                            desc                     = "Old-prod Gitlab"
                            source_sg_id             = "sg-01220bc70af5ba645"
                     
                        }
                        old_prod_lb = {
                            port                     = 0
                            protocol                 = -1
                            desc                     = "Old-prod LB"
                            source_sg_id             = "sg-02c955d27a5ef834b" 
                        }
                        old_prod_ngrinder = {
                            port                     = 0
                            protocol                 = -1
                            desc                     = "Old-prod Ngrinder"
                            source_sg_id             = "sg-0c891cb5c72fe295e" 
                        }
                    }
        }
    }
    */




}
