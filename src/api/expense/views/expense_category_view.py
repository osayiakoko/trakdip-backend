from rest_framework.generics import ListAPIView

from expense.models import ExpenseCategory
from expense.serializers import ExpenseCategorySerializer


class ExpenseCategoryView(ListAPIView):
    queryset = ExpenseCategory.objects.all()
    serializer_class = ExpenseCategorySerializer
