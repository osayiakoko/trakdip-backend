from django.db import models
from django.contrib.auth import get_user_model


User = get_user_model()


class Expense(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="expenses")
    category = models.ForeignKey(
        "expense.ExpenseCategory",
        on_delete=models.SET_NULL,
        null=True,
        related_name="expenses",
    )
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    description = models.CharField()
    timestamp = models.DateTimeField()

    class meta:
        db_table = "expense"

    def __str__(self):
        return self.amount
