import boto3
import json
import os

dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMODB_TABLE_NAME"]
table = dynamodb.Table(table_name)


def save_email(email):
    table.put_item(Item={
        "Email": email,
    })


def handler(event, context):
    body = json.loads(event["body"])
    email = body["email"]
    print(f"Attempting to save waitlist subscription for {email}")

    save_email(email)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Subscription received.",
        })
    }
