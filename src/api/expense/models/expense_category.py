from django.db import models

from core.utils import generate_unique_filename


def _expense_category_image_location(instance, filename):
    return f"expense-category/{generate_unique_filename(filename)}"


class ExpenseCategory(models.Model):
    name = models.CharField(max_length=128)
    image = models.ImageField(upload_to=_expense_category_image_location)

    class meta:
        db_table = "expense_category"
        verbose_name_plural = "expense categories"

    def __str__(self):
        return self.name
