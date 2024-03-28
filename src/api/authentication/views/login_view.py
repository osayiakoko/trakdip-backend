from django.contrib import auth
from django.contrib.auth.models import update_last_login
from drf_spectacular.utils import extend_schema
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny

from authentication.serializers import LoginSerializer, UserTokenSerializer


class LoginView(GenericAPIView):
    """
    An endpoint for user login.
    """

    serializer_class = LoginSerializer
    permission_classes = [AllowAny]

    @extend_schema(responses={200: UserTokenSerializer})
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        username = serializer.data.get("email")
        password = serializer.data.get("password")
        user = auth.authenticate(username=str(username), password=password)

        if user and user.is_active:
            serializer = UserTokenSerializer(user)
            update_last_login(None, user)
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response("Invalid credentials", status=status.HTTP_401_UNAUTHORIZED)
