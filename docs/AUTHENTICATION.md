# Authentication
Monitor uses an email token based authentication system built on JWT tokens.

When the frontend requests project data from the API it provides the API key it has stored in its cookies, if an API key was not given or cannot be verified to have been signed with the key in the `HMAC_SECRET` environment variable the secured endpoint will return 401, causing the frontend to send the user to screen which allows them to request a token by entering their email.

The email is sent via [GovNotify](https://www.notifications.service.gov.uk/) and will contain a UUID (the 'token') that is stored in the APIs memory along with the user it pertains to, on clicking this link the frontend will use the token to request an API key that is valid for the user's projects.

Endpoints are protected by the `guard_access` helper function which checks the provided project id against the given API key.

Please note that sensitive data should not be stored in JWT tokens as these are not encrypted and merely serve to verify authenticity.
