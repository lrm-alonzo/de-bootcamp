#!/usr/bin/env bash
# Replace BUCKET_NAME before running.

aws s3 cp top5_coins.csv s3://lynne-data-engineering-labs/week7/mini-lab-1/top5_coins.csv --region ap-southeast-2