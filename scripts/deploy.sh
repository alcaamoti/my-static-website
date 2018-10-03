echo "Deploying to S3"
docker run $(printenv | grep -E '^AWS' | sed 's/AWS_/-e /g' | sed 's/-e /-e AWS_/g') my-static-website