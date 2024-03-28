from django.urls import path
from rest_framework import routers

from expense.views import ExpenseCategoryView, ExpenseViewSet


app = "expense"

urlpatterns = [
    path("categories", ExpenseCategoryView.as_view(), name="expense-category"),
]

router = routers.SimpleRouter(trailing_slash=False)
router.register("expenses", ExpenseViewSet, basename="expenses")
urlpatterns += router.urls
