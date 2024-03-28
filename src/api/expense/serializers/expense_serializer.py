from rest_framework import serializers
from expense.models import Expense


class ExpenseSerializer(serializers.ModelSerializer):
    category_id = serializers.IntegerField()

    class Meta:
        model = Expense
        exclude = [
            "user",
            "category",
        ]
