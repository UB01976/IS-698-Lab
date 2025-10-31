from datetime import datetime, timedelta
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('shashank-puppala-homework2-table')

seven_days_ago = int((datetime.now() - timedelta(days=7)).timestamp())

response = table.scan(
    FilterExpression="#ts >= :ts",
    ExpressionAttributeNames={"#ts": "Timestamp"},
    ExpressionAttributeValues={":ts": seven_days_ago}
)

users = response['Items']

print("Users logged in within last 7 days:")
for user in users:
    print(user)
