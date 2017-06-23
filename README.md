# Poopmail

A Slack slash-command endpoint that:

1. Posts an emoji into a specified channel
2. Sets the user’s status
3. Sends an email to the user telling them what happened, and why

Rather than acting immediately, a message is displayed to the user _privately_ first, giving them the opportunity to undo the effects before they happen, so long as they enter the /flush command in the first 30 seconds after being pooped.
