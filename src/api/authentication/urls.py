from django.urls import path
from .views import EmailExistsView, LoginView, RegisterView


app_name = "authentication"


urlpatterns = [
    path("email-exists", EmailExistsView.as_view(), name="email-exists"),
    path("login", LoginView.as_view(), name="login"),
    path("register", RegisterView.as_view(), name="register-user"),
]
