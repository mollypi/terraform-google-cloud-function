locals {

  shared_labels = tomap(
    {
      "name"    = "${var.teamid}-${var.prjid}",
      "team"    = var.teamid,
      "project" = var.prjid
    }
  )
}
