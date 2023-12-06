variable "atlas" {
  type = object({
    public_key  = string
    private_key = string
    project_id  = string
    s3 = object({
      bucket : string
      region : string
    })
    cluster = object({
      name      = string
      db_name   = string
      coll_name = string
    })
  })
}
