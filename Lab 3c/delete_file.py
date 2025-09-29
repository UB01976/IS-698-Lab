import boto3

s3 = boto3.client('s3')
bucket_name = 'shashank-puppala-boto3-s3-bucket'
file_name = 'shashank-puppala-boto3-s3-test-file.txt'

s3.delete_object(Bucket=bucket_name, Key=file_name)
print(f'File {file_name} deleted successfully!')