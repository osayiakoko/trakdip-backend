from rest_framework import status
from rest_framework.test import APIClient

from core.tests.constant import TEST_USER_EMAIL


def _make_request(data: dict, api_client: APIClient):
    url = "/v1/auth/email-exists"
    return api_client.post(url, data)


def test_email_exists_true(api_client: APIClient):
    data = {"email": TEST_USER_EMAIL}
    res = _make_request(data, api_client)

    assert res.status_code == status.HTTP_200_OK
    assert res.data is True


def test_email_exists_false(api_client: APIClient):
    data = {"email": "random@domain.com"}
    res = _make_request(data, api_client)

    assert res.status_code == status.HTTP_200_OK
    assert res.data is False
