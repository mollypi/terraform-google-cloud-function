import json


def function_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    return "hi!"
