module "vpc" {
  source                   = "../../modules/vpc"
  purpose_tag              = var.purpose_tag
  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = var.availability_zones_count
}

##################################################################################
# APP
##################################################################################

module "app" {
  source                = "../../modules/resources"
  vpc_id                = module.vpc.vpc_id
  available_zone_names  = module.vpc.available_zone_names
  s3_bucket_region_name = var.region_name
  public_subnets_ids    = module.vpc.public_subnets_ids
  private_subnets_ids   = module.vpc.private_subnets_ids
  instance_count        = var.instance_count
  instance_type_web     = var.instance_type
  instance_type_db      = var.instance_type
  purpose_tag           = var.purpose_tag
  owner_tag             = var.owner_tag
}