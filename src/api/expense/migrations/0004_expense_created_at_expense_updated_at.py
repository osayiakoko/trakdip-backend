# Generated by Django 5.0.3 on 2024-03-28 15:25

import django.utils.timezone
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("expense", "0003_alter_expense_timestamp"),
    ]

    operations = [
        migrations.AddField(
            model_name="expense",
            name="created_at",
            field=models.DateTimeField(
                auto_now_add=True, default=django.utils.timezone.now
            ),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name="expense",
            name="updated_at",
            field=models.DateTimeField(auto_now=True, null=True),
        ),
    ]
