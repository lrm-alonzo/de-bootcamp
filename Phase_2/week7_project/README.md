# Week 7 Project: Deploying Scripts to the Cloud

# Goal
This project demonstrates deploying a serverless pipeline using AWS Lambda and S3. The pipeline is triggered when new data files are uploaded to the project folder in S3.

# Steps Completed
1. Upload processed data to S3
    - Used AWS CLI to copy top5_coins.csv from mini-lab-1 to week7/project/.
    - Verified with aws s3 ls.

2. Use IAM/service account safely
    - Attached AWSLambdaBasicExecutionRole for CloudWatch logging.
    - Created custom inline policy LambdaS3ProjectReadAccess
    - This ensures least privilege: Lambda can only read files in the project folder.

3. Deploy a small serverless function
    - Created Lambda function serverless-hello-pipeline.
    - Deployed updated code via Lambda console.

4. Add logs and cost notes
    - Logs: Lambda writes execution logs to CloudWatch Logs. Each run generates a log stream with START, END, and function output.
    - Cost Notes:
        - S3: Minimal storage and request costs (single CSV file).
        - Lambda: Free tier covers 1M requests/month and 400,000 GB‑seconds. Function runs in milliseconds, so cost is negligible.
        - CloudWatch Logs: Minimal ingestion/storage costs.
        - Overall: Effectively zero cost under free tier.

5. Update README with deployment steps
    - This document serves as the final README, detailing all steps, IAM setup, logging, and cost awareness.