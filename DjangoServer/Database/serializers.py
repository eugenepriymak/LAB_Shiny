from rest_framework import serializers


class CargoSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=100)


class AmountsAndDaysSerializer(serializers.Serializer):
    amount = serializers.FloatField(source="cargo_amount")
    day = serializers.IntegerField(source="day_number")
