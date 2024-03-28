from django_filters import rest_framework as filters
from expense.models import Expense


class ExpenseFilter(filters.FilterSet):
    category_id = filters.NumberFilter(field_name="category_id")
    timestamp_from = filters.IsoDateTimeFilter(
        field_name="timestamp", lookup_expr="gte"
    )
    timestamp_to = filters.IsoDateTimeFilter(field_name="timestamp", lookup_expr="lte")

    class Meta:
        model = Expense
        fields = [
            "category_id",
            "timestamp_from",
            "timestamp_to",
        ]
