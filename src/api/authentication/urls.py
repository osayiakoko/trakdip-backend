from django.urls import path
from .views import EmailExistsView, RegisterView


app_name = "authentication"


urlpatterns = [
    path("email-exists", EmailExistsView.as_view(), name="email-exists"),
    path("register", RegisterView.as_view(), name="register-user"),
]
