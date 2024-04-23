from storages.backends.s3boto3 import S3Boto3Storage, S3StaticStorage


class StaticStorage(S3StaticStorage):
    location = "static"
    default_acl = None
    file_overwrite = True


class MediaStorage(S3Boto3Storage):
    location = "media"
    default_acl = None
    file_overwrite = False
