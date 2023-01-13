import boto3, uuid

client = boto3.resource('dynamodb')
table = client.Table("ecod-orders")

def lambda_handler(event, context):
  for record in event['Records']:
    print("Parsing order event")
    payload = record["body"]
    print(str(payload))
    table.put_item(Item= {'orderID': str(uuid.uuid4()),'order':  payload})
    print("Order successfully written to ecod-orders table")