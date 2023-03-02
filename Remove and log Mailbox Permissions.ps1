#Remove and log Mailbox Permissions
$orgName="OrganisationName" # Where is this used? 

$acctName="First.Last@OrganisationName" # Admin account login email.

$credential = Get-Credential -UserName $acctName -Message "Fill out the password. Newbie!"

Connect-AzureAD -Credential $credential # Connect to Azure AD.
Connect-MsolService # Connect to Microsoft Online. 
Connect-ExchangeOnline # Connect to EoL 

Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails usermailbox | Export-CSV D:\CSV\UserMailboxes.csv # Get CSV file of all user mailboxes.
 
 $users = Import-CSV D:\CSV\UserMailboxes.csv # Import User mmailboxes from CSV. 
 
ForEach ($user in $users) {  # ForEach loop through each usermailbox to get mailbox permissions.

Get-MailboxPermission $user.UserPrincipalName | Export-CSV -Append -Path D:\CSV\UserMailboxPermissions.csv # Export CSV file of user mailbox permissions pre-change.
 
 $userswithpermission = Import-CSV D:\CSV\UserMailboxPermissions.csv # Import CSV to re-loop through to remove all permissions from the mailboxes

ForEach ($userwithpermission in $userswithpermission) { 


Remove-MailboxPermission -Identity $user.userprincipalname -User $userwithpermission.userprincipalname  # Remove mailbox permission
$auditlogdata = "I have removed $($userswithpermission.userprincipalname) 's permission from $($user.userprincipalname) 's mailbox!" # Create the audit-log to output.

Add-Content -Value $auditlogdata -Path D:\CSV\RemoveMailboxAuditLog.log  # Write the audit-log to a file.



}
}


 