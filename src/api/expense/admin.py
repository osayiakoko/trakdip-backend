from django.contrib import admin
from expense.models import Expense, ExpenseCategory


admin.register(Expense)
admin.register(ExpenseCategory)
