from rest_framework import status
from rest_framework.generics import GenericAPIView
from drf_spectacular.utils import extend_schema
from rest_framework.response import Response

from authentication.serializers import ChangePasswordSerializer


class ChangePasswordView(GenericAPIView):
    """
    An endpoint for changing password.
    """

    serializer_class = ChangePasswordSerializer

    @extend_schema(responses={200: str})
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(
            data=request.data, context={"request": request}
        )
        serializer.is_valid(raise_exception=True)

        # set_password also hashes the password that the user will get
        user = request.user
        user.set_password(serializer.data.get("new_password"))
        user.save()

        return Response("Password updated successfully", status=status.HTTP_200_OK)
