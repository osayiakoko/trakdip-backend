from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny

from account.models import User

from ..serializers import EmailSerializer


class EmailExistsView(GenericAPIView):

    serializer_class = EmailSerializer
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            email = serializer.data["email"]
            email_exist = User.objects.filter(email=email).exists()
            return Response(email_exist)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
