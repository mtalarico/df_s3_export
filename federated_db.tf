data "mongodbatlas_cloud_provider_access" "all" {
  project_id = var.atlas.project_id
}

resource "mongodbatlas_federated_database_instance" "CSAuditTools" {
  project_id = var.atlas.project_id
  name       = "CSAuditTools"
  cloud_provider_config {
    aws {
      role_id        = data.mongodbatlas_cloud_provider_access.all.aws_iam_roles[0].role_id
      test_s3_bucket = var.atlas.s3.bucket
    }
  }
  storage_databases {
    name = "support-center"
    collections {
      name = "audit"
      // links the default clusters support-center.audit collection to this virtual namespace, support-center.audit
      data_sources {
        collection = var.atlas.cluster.coll_name
        database   = var.atlas.cluster.db_name
        store_name = "sourceStore"
      }
    }
  }

  // links default as a data source with secondary read preference
  storage_stores {
    name         = "sourceStore"
    cluster_name = var.atlas.cluster.name
    project_id   = var.atlas.project_id
    provider     = "atlas"
    read_preference {
      mode = "secondary"
    }
  }

  // links a S3 bucket to use for $out
  storage_stores {
    bucket   = var.atlas.s3.bucket
    name     = "destinationStore"
    provider = "s3"
    region   = var.atlas.s3.region
  }
}
