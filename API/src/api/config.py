from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    database_url: str
    s3_endpoint_url: str = "http://minio:9000"
    s3_access_key: str
    s3_secret_key: str
    s3_bucket: str = "bone-photos"
    s3_region: str = "us-east-1"

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


settings = Settings()

