locals {
  # Convert CSV to list of maps
  users = csvdecode(file("users.csv"))
}