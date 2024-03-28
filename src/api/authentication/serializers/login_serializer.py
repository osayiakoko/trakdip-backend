from rest_framework import serializers


class LoginSerializer(serializers.Serializer):
    """'
    Login Serializer
    """

    email = serializers.EmailField()
    password = serializers.CharField()
