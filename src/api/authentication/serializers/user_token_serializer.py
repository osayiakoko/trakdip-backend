from django.contrib.auth import get_user_model

from rest_framework import serializers
from authentication.serializers import JwtTokenSerializer


User = get_user_model()


class UserTokenSerializer(serializers.ModelSerializer):
    token = JwtTokenSerializer(read_only=True)

    class Meta:
        model = User

        read_only_fields = ["id", "token"]

        fields = [
            "id",
            "first_name",
            "last_name",
            "email",
            "token",
        ]
