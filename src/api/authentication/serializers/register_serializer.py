from django.contrib.auth.models import update_last_login
from rest_framework import serializers

from account.models import User

from ..serializers import JwtTokenSerializer


class RegisterSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    first_name = serializers.CharField(max_length=150)
    last_name = serializers.CharField(max_length=150)
    email = serializers.EmailField()
    password = serializers.CharField(max_length=128, write_only=True)
    token = JwtTokenSerializer(read_only=True)

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        update_last_login(None, user)
        return user
