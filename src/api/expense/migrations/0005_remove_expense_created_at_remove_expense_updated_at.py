# Generated by Django 5.0.3 on 2024-03-28 15:26

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("expense", "0004_expense_created_at_expense_updated_at"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="expense",
            name="created_at",
        ),
        migrations.RemoveField(
            model_name="expense",
            name="updated_at",
        ),
    ]