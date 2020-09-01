get-mailbox -RecipientTypeDetails Sharedmailbox | Set-Mailbox -MessageCopyForSentAsEnabled $True
get-mailbox -RecipientTypeDetails Sharedmailbox | Set-Mailbox -MessageCopyForSendOnBehalfEnabled $True
