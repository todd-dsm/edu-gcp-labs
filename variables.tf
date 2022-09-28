/*
  --------------------------------------------------------|-------------------------------------------------------------
                                                      NETWORKING
  ----------------------------------------------------------------------------------------------------------------------
*/
variable "cidr_range" {
  description = "VPC CIDR range; typically a /16 address space providing 65,536 addressable IPs."
  type        = string
}

/*
  -----------------------------------------------------------------------------
                          Initialize/Declare Variables
                                 PROJECT-LEVEL
  -----------------------------------------------------------------------------
*/
variable "build_env" {
  description = "Build Environment; from ENV; E.G.: envBuild=stage"
  type        = string
}

variable "project_id" {
  description = "Currently configured project ID; from ENV; E.G.: My First Project"
  type        = string
}

variable "min_dist_size" {
  description = "how wide will this distributed system go? Min=3; sweet-spot=4"
  type        = number
}

variable "region" {
  description = "Deployment Region; from ENV; E.G.: us-central1"
  type        = string
}
