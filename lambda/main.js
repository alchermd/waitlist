import {DynamoDBClient} from "@aws-sdk/client-dynamodb";
import {DynamoDBDocumentClient, PutCommand,} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);

const tableName = process.env.DYNAMODB_TABLE_NAME;

const saveEmail = async (email) => {
  await dynamo.send(
    new PutCommand({
      TableName: tableName,
      Item: {
        Email: email,
      },
    })
  );
}

export const handler = async (event, context) => {
  let body = JSON.parse(event.body);
  const email = body.email;
  console.log(`Attempting to save waitlist subscription for ${email}`)
  await saveEmail(email);

  return {
    statusCode: 200,
    body: JSON.stringify({"message": "Subscription received."}),
  };
};
