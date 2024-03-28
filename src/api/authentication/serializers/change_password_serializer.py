from rest_framework import serializers
from account.models.user import User
from core.exceptions import APIException


class ChangePasswordSerializer(serializers.Serializer):
    """
    Serializer for password change endpoint.
    """

    old_password = serializers.CharField()
    new_password = serializers.CharField()

    def validate(self, attrs):
        old_password = attrs["old_password"]
        new_password = attrs["new_password"]

        # Check old password
        user: User = self.context["request"].user
        if not user.check_password(old_password):
            raise APIException(detail="Invalid old password")

        # check if passwords are different
        if old_password == new_password:
            raise APIException(detail="New password same as old")

        return super().validate(attrs)
