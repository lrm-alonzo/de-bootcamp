# Deployment Steps

# AWS path
1. Create an S3 bucket
    - s3://lynne-data-engineering-labs/week7/project/
2. Copy data into project folder
    - aws s3 cp s3://lynne-data-engineering-labs/week7/mini-lab-1/top5_coins.csv s3://lynne-data-engineering-labs/week7/project/top5_coins.csv
3. Configure IAM role
    - Keep AWSLambdaBasicExecutionRole.
    - Add inline policy LambdaS3ProjectReadAccess with s3:GetObject scoped to project folder.
4. Deploy Lambda
5. Add S3 trigger
6. Verify logs
    - Check CloudWatch Logs for Lambda execution output.

# Cost Awareness
- S3: negligible for small files
- Lambda: negligible under free tier
- CloudWatch Logs: negligible for small log streams
- Total: effectively zero for this project