# Goldblum

![Ian Malcolm](http://goldblum.herokuapp.com/avatars/ianmalcolm/004.jpg)

> Your scientists were so preoccupied with whether or not they could, they didn't stop to think if they should.

A Slack integration to turn your security-lax colleagues (temporarily) into Jeff Goldblum. If you find a colleague’s computer unlocked, typing the `/goldblum` command (and following the prompt) will:

1. Change their name to a random Jeff Goldblum character
2. Set their bio to a random Jeff Goldblum quote
3. Set their avatar to a random Jeff Goldblum photo
4. Post a message in `#general` announcing that they’ve been transformed
5. Send an email to the user telling them what happened, and why

### TODO:

* Keep a log of who’s been goldblummed

### Permission Scopes and API methods

This integration requires various Slack permission scopes in order to work:

```
chat:write:bot      - chat.update
chat:write:bot      - chat.delete
chat:write:bot      - chat.postMessage
users.profile:read  - users.profile.get
users.profile:write - users.setPhoto
users.profile:write - users.profile.set
```
