# Lambda Layer Builder
This project provides a rough framework for automating the AWS Lambda layer build process.

## Requirements
This project requires
* AWS Account with an S3 bucket for temporary ZIP storage
* [AWS CLI](https://aws.amazon.com/cli/) (with access keys configured for your AWS account)
* [Docker](https://docker.com)
* Python >= 2.7,3.5

## How-To
1. After cloning the repo, copy the `vars.txt.example` file to `vars.txt`
2. Edit `vars.txt` to provide an S3 bucket name
3. Optionally provide a custom default layer name
4. Optionally provide `pip` arguments for layers (based on layer name)
5. Create files under `requirements` for each layer you wish to build (e.g. `requirements/boto3.txt` may list `boto3`)
6. Run `make` then `make publish` to build your default layer
7. Run `LAYER_NAME=other-layer make` or (`export LAYER_NAME=other-layer` then `make`) to build additional layers, and publish as desired
8. Verify that your new Lambda layer is available via the console, or by running `aws lambda list-layers`

