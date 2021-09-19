from django.db import models


class Cargo(models.Model):
    name = models.CharField(max_length=100)


class FreightCar(models.Model):
    cargo = models.ForeignKey(Cargo, on_delete=models.CASCADE)
    cargo_amount = models.FloatField()
    day_number = models.IntegerField()
