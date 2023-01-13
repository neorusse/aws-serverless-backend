## Architecting Solutions
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

### Proof of Concept for a Serverless Backend Solution in AWS Cloud.

Ecod Services sells cleaning supplies and often sees spikes in demand for their website, necessitating the need for a decoupled serverless architecture that can easily scale in and out as demand changes.


#### AWS Infrastructure Diagram

![Alt text](https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/DEV-AWS-MO-Architecting/images/exercise-1.png)

The above architectural diagram shows the flow for a well decoupled serverless backend solution hosted on AWS.

In this architecture, we use a REST API to place a database entry in the Amazon SQS queue. Amazon SQS will then invoke the first Lambda function, which inserts the entry into a DynamoDB table. After that, DynamoDB Streams will capture a record of the new entry in a database and invoke a second Lambda function. The function will pass the database entry to Amazon SNS. After Amazon SNS processes the new record, it will send you a notification through a specified email address.

### AWS Services provision
* AWS APIGateway
* AWS SQS
* AWS Lambda
* AWS DynamoDB
* AWS SNS 
* AWS IAM

These services were deployed to eu-central-1 Frankfurt Region and they spans three Availability Zones, making it highly available.


### License

[MIT](https://opensource.org/licenses/MIT)

### Author

[Russell Nyorere](https://neorusse.github.io/)