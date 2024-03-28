from rest_framework import status
from rest_framework.test import APIClient

from core.tests.constant import TEST_USER_EMAIL, TEST_USER_PASSWORD


def _make_request(data: dict, api_client: APIClient):
    url = "/v1/auth/login"
    return api_client.post(url, data)


def test_login_view_success(api_client: APIClient):
    data = {"email": TEST_USER_EMAIL, "password": TEST_USER_PASSWORD}
    res = _make_request(data, api_client)
    assert res.status_code == status.HTTP_200_OK

    expected_keys = [
        "id",
        "first_name",
        "last_name",
        "email",
        "token",
    ]
    assert all(key in res.data for key in expected_keys)

    expected_keys = ["access", "refresh"]
    assert all(key in res.data["token"] for key in expected_keys)


def test_login_view_unauthorized(api_client: APIClient):
    data = {"email": "random@domain.com", "password": "randomPass"}
    res = _make_request(data, api_client)
    assert res.status_code == status.HTTP_401_UNAUTHORIZED
