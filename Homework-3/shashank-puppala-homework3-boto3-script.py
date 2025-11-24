import boto3
from botocore.exceptions import ClientError


s3_bucket_name = 'shashank-puppala-s3-triggerlambda-bucket'
dynamodb_table_name = 'shashank-puppala-TestTable2'


#1. List all files in a specified S3 bucket

s3 = boto3.client('s3')

print(f"\nListing files in S3 bucket '{s3_bucket_name}':")
try:
    response = s3.list_objects_v2(Bucket=s3_bucket_name)
    if 'Contents' in response:
        for obj in response['Contents']:
            print(f"- {obj['Key']}")
    else:
        print("No files found in the bucket.")
except ClientError as e:
    print(f"Error accessing S3 bucket: {e}")


#2. Creating a DynamoDB table

dynamodb_client = boto3.client('dynamodb')
try:
    print(f"\nCreating DynamoDB table '{dynamodb_table_name}'...")
    dynamodb_client.create_table(
        TableName=dynamodb_table_name,
        KeySchema=[
            {'AttributeName': 'id', 'KeyType': 'HASH'}
        ],
        AttributeDefinitions=[
            {'AttributeName': 'id', 'AttributeType': 'S'}
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    )

    # Wait until table exists
    waiter = dynamodb_client.get_waiter('table_exists')
    waiter.wait(TableName=dynamodb_table_name)
    print(f"Table '{dynamodb_table_name}' is ready.")
except dynamodb_client.exceptions.ResourceInUseException:
    print(f"Table '{dynamodb_table_name}' already exists.")


#3. Inserting an item into the DynamoDB table
dynamodb_resource = boto3.resource('dynamodb')
table = dynamodb_resource.Table(dynamodb_table_name)

item = {
    'id': '1',
    'name': 'Shashank2',
    'course': 'IS6982'
}

try:
    table.put_item(Item=item)
    print(f"\nInserted item into '{dynamodb_table_name}': {item}")
except ClientError as e:
    print(f"Error inserting item: {e}")
