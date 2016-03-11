import plistlib, sys, os

filename = "Example/HiPayFullservice/HiPayFullservice-Info.plist"
path =  "../" + filename

info = plistlib.readPlist(path)

info["CFBundleVersion"] = os.environ.get('CIRCLE_BUILD_NUM', '1')

plistlib.writePlist(info, path)
