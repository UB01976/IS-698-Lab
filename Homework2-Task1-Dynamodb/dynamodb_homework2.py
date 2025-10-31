import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('shashank-puppala-homework2-table')


table.put_item(
    Item={
        "UserID": "US001",
        "Timestamp": int(datetime.now().timestamp()),
        "Name": "Shaun",
        "Email": "shaun@gmail.com",
        "LastLogin": str(datetime.now().date())
    }
)

table.put_item(
    Item={
        "UserID": "US002",
        "Timestamp": int(datetime.now().timestamp()),
        "Name": "Larry",
        "Email": "larry23@gmail.com",
        "LastLogin": str(datetime.now().date())
    }
)


response = table.query(
    KeyConditionExpression=boto3.dynamodb.conditions.Key('UserID').eq('US002')
)

if 'Items' in response and len(response['Items']) > 0:
    item = response['Items'][0]
    print("Fetched User Record:", item)
else:
    print("No record found for UserID = US002")
