import json
import os
import sys
import platform
import subprocess


def function_handler(event, context):
    print('Received event: ' + json.dumps(event, indent=2))
    return 'hi!'

    print(os.getcwd())
    print(sys.platform)
    print(platform.platform())
    print('setting uri package')

    print('install gcloud client')
    #install_client = subprocess.run(["google-cloud-sdk-app-engine-python"])
    process = subprocess.Popen(['google-cloud-sdk-app-engine-python'],
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    print('The exit code was: %d' % stdout)
    print('The response: %d' % stderr)

    print('initialize')
    # init_client = subprocess.run(["gcloud", "init"])
    # print("The exit code was: %d" % init_client.returncode)
