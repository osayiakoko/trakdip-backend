import pytest
from rest_framework import status
from rest_framework.test import APIClient

from core.tests.constant import TEST_USER_PASSWORD


def _get_access_token(api_client, user):
    url = "/v1/auth/login"
    data = {
        "email": str(user.email),
        "password": TEST_USER_PASSWORD,
    }
    response = api_client.post(url, data, format="json")
    assert response.status_code == status.HTTP_200_OK, "Login failed during test setup"
    return response.data["token"]["access"]


@pytest.fixture
def api_client(api_key) -> APIClient:
    api_client = APIClient()
    api_client.credentials(HTTP_API_KEY=api_key)
    return api_client


@pytest.fixture
def api_client_jwt(api_client, api_key, user) -> APIClient:
    token = _get_access_token(api_client, user)
    api_client.credentials(HTTP_AUTHORIZATION=f"Bearer {token}", HTTP_API_KEY=api_key)
    return api_client
