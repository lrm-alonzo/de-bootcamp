# Mini Lab: Serverless Hello Pipeline

import json
import os
from datetime import datetime

def lambda_handler(event, context):
    # Read environment variable (defaults if not set)
    pipeline_name = os.getenv("PIPELINE_NAME", "data-upload-pipeline")

    # Build structured message
    message = {
        "pipeline": pipeline_name,
        "run_at": datetime.utcnow().isoformat(timespec="seconds") + "Z",
        "event": event,
        "status": "ok",
    }

    # Log message to CloudWatch
    print(json.dumps(message))

    # Return HTTP-style response
    return {
        "statusCode": 200,
        "body": json.dumps(message)
    }
