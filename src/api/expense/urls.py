from django.urls import path

from expense.views import ExpenseCategoryView

app = "expense"

urlpatterns = [
    path("categories", ExpenseCategoryView.as_view(), name="expense-category"),
]
