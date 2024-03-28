from django.urls import path
from .views import ChangePasswordView, EmailExistsView, LoginView, RegisterView


app_name = "authentication"


urlpatterns = [
    path("change-password", ChangePasswordView.as_view(), name="change-password"),
    path("email-exists", EmailExistsView.as_view(), name="email-exists"),
    path("login", LoginView.as_view(), name="login"),
    path("register", RegisterView.as_view(), name="register-user"),
]
