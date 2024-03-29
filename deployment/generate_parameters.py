import plistlib, sys, os

parameters = dict(
    hipayStage=dict(
        username = os.environ.get('HIPAY_FULLSERVICE_API_STAGE_USERNAME', 'xxxxxx'),
        password = os.environ.get('HIPAY_FULLSERVICE_API_STAGE_PASSWORD', 'xxxxxx'),
        secretPassphrase = os.environ.get('HIPAY_FULLSERVICE_STAGE_SECRET_PASSPHRASE', 'xxxxxx'),
        applePayPrivateKeyPassword = os.environ.get('HIPAY_STAGE_APPLE_PAY_PRIVATE_KEY_PASSWORD', 'xxxxxx'),
        applePayMerchantIdentifier = os.environ.get('HIPAY_STAGE_APPLE_PAY_MERCHANT_IDENTIFIER', 'xxxxxx'),
        applePayUsername = os.environ.get('HIPAY_STAGE_APPLE_PAY_USERNAME', 'xxxxxx'),
    ),
    hipayProduction=dict(
        username = os.environ.get('HIPAY_FULLSERVICE_API_PRODUCTION_USERNAME', 'xxxxxx'),
        password = os.environ.get('HIPAY_FULLSERVICE_API_PRODUCTION_PASSWORD', 'xxxxxx'),
        secretPassphrase = os.environ.get('HIPAY_FULLSERVICE_PRODUCTION_SECRET_PASSPHRASE', 'xxxxxx'),
        applePayPrivateKeyPassword = os.environ.get('HIPAY_PRODUCTION_APPLE_PAY_PRIVATE_KEY_PASSWORD', 'xxxxxx'),
        applePayMerchantIdentifier = os.environ.get('HIPAY_PRODUCTION_APPLE_PAY_MERCHANT_IDENTIFIER', 'xxxxxx'),
        applePayUsername = os.environ.get('HIPAY_PRODUCTION_APPLE_PAY_USERNAME', 'xxxxxx'),
    ),
    appURLscheme= 'hipayexample'
)

filename = "parameters.plist"
path = "Example/HiPayFullservice/Resources/Parameters/" + filename

# Save file
with open(path, "wb") as f:
    plistlib.dump(parameters, f)

sys.stdout.write("\n\nA new parameters file was created at:\n")
sys.stdout.write(filename + "\n")
sys.stdout.write("You need add your HiPay parameters in it.\n\n\n")
