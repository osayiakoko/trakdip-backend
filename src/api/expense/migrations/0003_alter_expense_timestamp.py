# Generated by Django 5.0.3 on 2024-03-28 15:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("expense", "0002_alter_expense_timestamp"),
    ]

    operations = [
        migrations.AlterField(
            model_name="expense",
            name="timestamp",
            field=models.DateTimeField(),
        ),
    ]
