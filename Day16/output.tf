# User Information
output "created_users" {
  description = "List of created IAM users"
  value = [
    for user in aws_iam_user.users :
    {
      username    = user.name
      display_name = user.tags.DisplayName
      department  = user.tags.Department
      job_title   = user.tags.JobTitle
    }
  ]
}

output "user_count" {
  description = "Total number of users created"
  value       = length(aws_iam_user.users)
}

# Group Information
output "group_memberships" {
  description = "Users assigned to each group"
  value = {
    education  = aws_iam_group_membership.education_members.users
    sales      = aws_iam_group_membership.sales_members.users
    accounting = aws_iam_group_membership.accounting_members.users
    hr         = aws_iam_group_membership.hr_members.users
    managers   = aws_iam_group_membership.managers_members.users
  }
}





