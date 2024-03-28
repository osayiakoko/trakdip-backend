import pytest
from model_bakery import baker
from core.tests.constant import (
    TEST_USER_EMAIL,
    TEST_USER_PASSWORD,
)


@pytest.fixture(autouse=True)
def user(db):
    user = baker.make("account.User", email=TEST_USER_EMAIL)
    user.set_password(TEST_USER_PASSWORD)
    user.save()
    return user
