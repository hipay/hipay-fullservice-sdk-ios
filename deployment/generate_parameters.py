import plistlib, sys, os

parameters = dict(
    hipay=dict(
        username = os.environ.get('HIPAY_FULLSERVICE_API_USERNAME', 'xxxxxx'),
        password = os.environ.get('HIPAY_FULLSERVICE_API_PASSWORD', 'xxxxxx')
    ),
    hockeyapp=dict(
        app_identifier = os.environ.get('HOCKEY_APP_IDENTIFIER', 'xxxxxx'),
    )
)

filename = "Example/HiPayFullservice/Resources/Parameters/parameters.plist"
path =  "../" + filename

# Merge with current parameters
if os.path.isfile(path):
	currentParameters = plistlib.readPlist(path)
	parameters["hipay"].update(currentParameters["hipay"])
	parameters["hockeyapp"].update(currentParameters["hockeyapp"])

# Save file
plistlib.writePlist(parameters, path)

sys.stdout.write("\n\nA new parameters file was created at:\n")
sys.stdout.write(filename + "\n")
sys.stdout.write("You need add your HiPay parameters in it.\n\n\n")
