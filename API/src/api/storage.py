import boto3
from botocore.exceptions import ClientError
from api.config import settings


def get_s3_client():
    return boto3.client(
        "s3",
        endpoint_url=settings.s3_endpoint_url,
        aws_access_key_id=settings.s3_access_key,
        aws_secret_access_key=settings.s3_secret_key,
        region_name=settings.s3_region,
    )


def ensure_bucket_exists(bucket_name: str = settings.s3_bucket) -> None:
    s3 = get_s3_client()
    try:
        s3.head_bucket(Bucket=bucket_name)
    except ClientError as exc:
        code = exc.response.get("Error", {}).get("Code", "")
        if code in ("404", "NoSuchBucket", "NotFound"):
            s3.create_bucket(Bucket=bucket_name)
        else:
            raise