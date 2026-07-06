resource "yandex_mdb_mysql_cluster" "db" {
  name        = "project-mysql"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.main.id

  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 10
  }

  host {
    zone      = var.default_zone
    subnet_id = yandex_vpc_subnet.public.id
  }
}

resource "yandex_mdb_mysql_database" "app_db" {
  cluster_id = yandex_mdb_mysql_cluster.db.id
  name       = "webapp"
}

resource "yandex_mdb_mysql_user" "app_user" {
  cluster_id = yandex_mdb_mysql_cluster.db.id
  name       = "dbuser"
  password   = var.db_password
  permission {
    database_name = yandex_mdb_mysql_database.app_db.name
    roles         = ["ALL"]
  }
}
