from datetime import datetime, timezone


def generate_unique_filename(filename):
    ext = filename.split(".")[-1]
    name = datetime.now(tz=timezone.utc).strftime("%Y%m%d_%H%M%S_%f")
    return f"{name}.{ext}"
