import pytest
from datetime import datetime, timezone
from rest_framework import status
from model_bakery import baker


_sample_expense_data = {
    "amount": "1000000",
    "description": "test case expenses",
    "timestamp": datetime(2024, 1, 1, 12, 00, 00, 00).astimezone(timezone.utc),
}


@pytest.mark.django_db
def test_expenses_create_success(api_client_jwt):
    url = "/v1/expense/expenses"

    category = baker.make("expense.ExpenseCategory")
    data = {**_sample_expense_data, "category_id": category.id}

    res = api_client_jwt.post(url, data)
    assert res.status_code == status.HTTP_201_CREATED

    expected_keys = ["id", "category_id", "amount", "description", "timestamp"]
    assert all(key in res.data for key in expected_keys)


@pytest.mark.django_db
def test_expenses_all_success(user, api_client_jwt):
    category = baker.make("expense.ExpenseCategory")
    baker.make("expense.Expense", user=user, category=category, _quantity=2)

    url = "/v1/expense/expenses"
    res = api_client_jwt.get(url)

    assert res.status_code == status.HTTP_200_OK
    assert len(res.data) == 2

    expected_keys = ["id", "category_id", "amount", "description", "timestamp"]
    assert all(key in res.data[0] for key in expected_keys)


@pytest.mark.django_db
def test_expenses_update_success(api_client_jwt, user):
    url = "/v1/expense/expenses"

    category = baker.make("expense.ExpenseCategory")
    sample_expense = {**_sample_expense_data, "user": user, "category": category}
    expense = baker.make("expense.Expense", **sample_expense)

    new_category = baker.make("expense.ExpenseCategory")
    data = {
        "category_id": new_category.id,
        "amount": "100000.00",
        "description": "new test case expenses",
        "timestamp": datetime(2024, 2, 1, 12, 00, 00, 00).astimezone(timezone.utc),
    }

    res = api_client_jwt.patch(f"{url}/{expense.id}", data)
    assert res.status_code == status.HTTP_200_OK

    res = api_client_jwt.put(f"{url}/{expense.id}", data)
    assert res.status_code == status.HTTP_200_OK


@pytest.mark.django_db
def test_expenses_delete_success(api_client_jwt, user):
    url = "/v1/expense/expenses"

    category = baker.make("expense.ExpenseCategory")
    sample_expense = {**_sample_expense_data, "user": user, "category": category}
    expense = baker.make("expense.Expense", **sample_expense)

    res = api_client_jwt.delete(f"{url}/{expense.id}")
    assert res.status_code == status.HTTP_204_NO_CONTENT
