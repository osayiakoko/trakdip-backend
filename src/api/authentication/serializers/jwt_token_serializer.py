from rest_framework import serializers


class JwtTokenSerializer(serializers.Serializer):
    access = serializers.CharField(read_only=True)
    refresh = serializers.CharField()
