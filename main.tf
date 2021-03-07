locals {
  shared_labels = map(
    "name", "${var.teamid}-${var.prjid}",
    "team", var.teamid,
    "project", var.prjid
  )
}
