import json
import httplib, urllib
import os, sys
import re

circle_branch_cleaned = re.sub('[^A-Za-z0-9]+', '', os.environ.get('CIRCLE_BRANCH'))
public_identifier = None;
bundle_identifier = "com.hipay.fullservice.demo." + circle_branch_cleaned

hockeyConnection = httplib.HTTPSConnection("rink.hockeyapp.net")
hockeyConnection.request("GET", "/api/2/apps", None, {"X-HockeyAppToken": os.environ.get('HOCKEY_APP_TOKEN')})
response = hockeyConnection.getresponse()

if response.status != 200:
    raise Exception('Failed to fetch apps')

appsResponse = json.loads(response.read().decode('utf-8'))

# Check if app exists
for app in appsResponse["apps"]:
    if app["bundle_identifier"] == bundle_identifier:
        public_identifier = app["public_identifier"]

# Create app if it doesn't exist
if public_identifier is None:

    params = urllib.urlencode({
    "title": "HiPay Demo (" + circle_branch_cleaned + ")",
    "bundle_identifier": bundle_identifier,
    "platform": "iOS",
    "release_type": "2"
    })

    hockeyConnection.request("POST", "/api/2/apps/new", params, {
    "X-HockeyAppToken": os.environ.get('HOCKEY_APP_TOKEN')
    })

    response = hockeyConnection.getresponse()
    app = json.loads(response.read().decode('utf-8'))

    if response.status != 200 and response.status != 201:
        raise Exception('Failed to create app')

    public_identifier = app["public_identifier"]

# Add team to app
hockeyConnection.request("PUT", "/api/2/apps/" + public_identifier + "/app_teams/54248", None, {
"X-HockeyAppToken": os.environ.get('HOCKEY_APP_TOKEN')
})

sys.stdout.write(public_identifier)
