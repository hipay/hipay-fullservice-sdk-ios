import plistlib, sys, os

parameters = dict(
    hipayStage=dict(
        username = os.environ.get('HIPAY_FULLSERVICE_API_STAGE_USERNAME', 'xxxxxx'),
        password = os.environ.get('HIPAY_FULLSERVICE_API_STAGE_PASSWORD', 'xxxxxx')
    ),
    hipayProduction=dict(
        username = os.environ.get('HIPAY_FULLSERVICE_API_PRODUCTION_USERNAME', 'xxxxxx'),
        password = os.environ.get('HIPAY_FULLSERVICE_API_PRODUCTION_PASSWORD', 'xxxxxx')
    ),
    appURLscheme= 'hipayexample'
)

filename = "parameters.plist"
path = ""

if os.environ.get('CI'):
    path = "Example/HiPayFullservice/Resources/Parameters/" + filename
else:
    path = "../Example/HiPayFullservice/Resources/Parameters/" + filename

print path

# Save file
plistlib.writePlist(parameters, path)

sys.stdout.write("\n\nA new parameters file was created at:\n")
sys.stdout.write(filename + "\n")
sys.stdout.write("You need add your HiPay parameters in it.\n\n\n")
