# pylint: skip-file

DEBUG = True
CSRF_COOKIE_SECURE = False

STORAGES = {
    "default": {
        "BACKEND": "django.core.files.storage.FileSystemStorage",
    },
    "staticfiles": {
        "BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage",
    },
}

STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"  # noqa: F821 # type: ignore

MEDIA_URL = "media/"
MEDIA_ROOT = BASE_DIR / "media"  # noqa: F821 # type: ignore

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(days=1),  # noqa: F821 # type: ignore
}
