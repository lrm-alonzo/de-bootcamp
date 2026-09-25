# Mini Lab: Upload Clean Data to Cloud

import boto3

bucket = "lynne-data-engineering-labs"
local_file = "top5_coins.csv"
key = "week7/mini-lab-1/top5_coins.csv"

s3 = boto3.client("s3")
s3.upload_file(local_file, bucket, key)

print(f"{local_file} is successfully uploaded to s3://{bucket}/{key}")