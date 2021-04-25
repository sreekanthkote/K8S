identifier          = "v3-rds-postgres"
engine              = "postgres"
engine_version      = "10.6"
instance_class      = "db.t2.small"
allocated_storage   = 20
storage_encrypted   = true
port                = "5432"

multi_az            = false

# root DB username
username            = "rewardadmin"

# Database Deletion Protection
deletion_protection = true

iam_database_authentication_enabled = true

# DB subnet group
# subnet_ids =

# DB parameter group
family = "postgres10"

# DB option group
major_engine_version = "10.6"

# Snapshot name upon DB deletion
final_snapshot_identifier = "v3-rds-postgres-final"
copy_tags_to_snapshot = true
skip_final_snapshot = false

# Backups/Patching
maintenance_window = "Mon:00:00-Mon:03:00"
backup_window      = "03:00-06:00"


# Enhanced Monitoring - see example for details on how to create the role
# by yourself, in case you don't want to create it automatically
monitoring_interval = "30"
monitoring_role_name = "v3-rds-postgres"
create_monitoring_role = true
# enabled_cloudwatch_logs_exports = []


tags = {
    terraform     = "true"
    project_name  = "hydra"
    environment   = "sbx"
}

#---------------------------------------------------------
# demo environment
#---------------------------------------------------------
demo_identifier          = "v3-hydra-demo-postgres"


# Snapshot name upon DB deletion
demo_final_snapshot_identifier = "v3-hydra-demo-final"


# Enhanced Monitoring - see example for details on how to create the role
# by yourself, in case you don't want to create it automatically
demo_monitoring_role_name = "v3-hydra-demo"


demo_tags = {
    terraform     = "true"
    project_name  = "hydra"
    environment   = "demo"
}


#---------------------------------------------------------
# mmurray
#---------------------------------------------------------
mmurray_identifier          = "v3-hydra-mmurray-postgres"


# Snapshot name upon DB deletion
mmurray_final_snapshot_identifier = "v3-hydra-mmurray-final"


# Enhanced Monitoring - see example for details on how to create the role
# by yourself, in case you don't want to create it automatically
mmurray_monitoring_role_name = "v3-hydra-mmurray"


mmurray_tags = {
    terraform     = "true"
    project_name  = "hydra"
    environment   = "mmurray"
}


#---------------------------------------------------------
# istio environment
#---------------------------------------------------------
demo_identifier          = "v3-hydra-istio-postgres"


# Snapshot name upon DB deletion
demo_final_snapshot_identifier = "v3-hydra-istio-final"


# Enhanced Monitoring - see example for details on how to create the role
# by yourself, in case you don't want to create it automatically
demo_monitoring_role_name = "v3-hydra-istio"


demo_tags = {
    terraform     = "true"
    project_name  = "hydra"
    environment   = "istio"
}
