import json
import httplib, urllib
import os, sys

environment=sys.argv[1]
public_identifier = None;
bundle_identifier = "com.hipay.fullservice.demo." + os.environ.get('CIRCLE_BRANCH') + "." + environment

log_file = open(os.environ.get('CIRCLE_ARTIFACTS') + '/get_app_identifer.log', 'w');

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
        log_file.write("Found app public identifier:\n" + str(public_identifier) + "\n\n\n")

# Create app if it doesn't exist
if public_identifier is None:

    params = urllib.urlencode({
			"title": "HiPay Demo (" + os.environ.get('CIRCLE_BRANCH') + "-" + environment +")",
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

# Return identifier
log_file.write("Public identifier to be used:\n" + str(public_identifier) + "\n\n\n")
sys.stdout.write(public_identifier)
