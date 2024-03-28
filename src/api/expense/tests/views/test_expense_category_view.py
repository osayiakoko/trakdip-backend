import pytest
from rest_framework import status
from model_bakery import baker


@pytest.mark.django_db
def test_expense_category_view(api_client_jwt):
    baker.make("expense.ExpenseCategory", _quantity=2)

    url = "/v1/expense/categories"
    res = api_client_jwt.get(url)

    assert res.status_code == status.HTTP_200_OK
    assert len(res.data) == 2

    expected_keys = ["id", "name", "image"]
    assert all(key in res.data[0] for key in expected_keys)
