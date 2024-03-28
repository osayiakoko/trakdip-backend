from django.urls import path
from .views import EmailExistsView


app_name = "authentication"


urlpatterns = [
    path("email-exists", EmailExistsView.as_view(), name="email-exists"),
]
