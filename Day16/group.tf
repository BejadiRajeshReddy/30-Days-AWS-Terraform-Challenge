# ========================================
# IAM GROUPS
# ========================================

resource "aws_iam_group" "education" {
  name = "Education"
  path = "/groups/"
}

resource "aws_iam_group" "engineering" {
  name = "Engineering"
  path = "/groups/"
}

resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

resource "aws_iam_group" "hr" {
  name = "HR"
  path = "/groups/"
}

resource "aws_iam_group" "sales" {
  name = "Sales"
  path = "/groups/"
}

resource "aws_iam_group" "accounting" {
  name = "Accounting"
  path = "/groups/"
}



# ========================================
# GROUP MEMBERSHIPS - EDUCATION
# ========================================

resource "aws_iam_group_membership" "education_members" {
  name  = "education-group-membership"
  group = aws_iam_group.education.name
  
  users = [
    for user in aws_iam_user.users :
    user.name
    if user.tags.Department == "Education"
  ]
}

# ========================================
# GROUP MEMBERSHIPS - SALES
# ========================================

resource "aws_iam_group_membership" "sales_members" {
  name  = "sales-group-membership"
  group = aws_iam_group.sales.name
  
  users = [
    for user in aws_iam_user.users :
    user.name
    if user.tags.Department == "Sales"
  ]
}

# ========================================
# GROUP MEMBERSHIPS - ACCOUNTING
# ========================================

resource "aws_iam_group_membership" "accounting_members" {
  name  = "accounting-group-membership"
  group = aws_iam_group.accounting.name
  
  users = [
    for user in aws_iam_user.users :
    user.name
    if user.tags.Department == "Accounting"
  ]
}

# ========================================
# GROUP MEMBERSHIPS - HR
# ========================================

resource "aws_iam_group_membership" "hr_members" {
  name  = "hr-group-membership"
  group = aws_iam_group.hr.name
  
  users = [
    for user in aws_iam_user.users :
    user.name
    if user.tags.Department == "HR"
  ]
}

# ========================================
# GROUP MEMBERSHIPS - MANAGERS
# (Anyone with "Manager" or "CEO" in job title)
# ========================================

resource "aws_iam_group_membership" "managers_members" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name
  
  users = [
    for user in aws_iam_user.users :
    user.name
    if can(regex("(?i)(manager|ceo)", user.tags.JobTitle)) 
  ]
}