from Database.models import Cargo, FreightCar
from Database.serializers import CargoSerializer, AmountsAndDaysSerializer

from rest_framework.views import APIView
from rest_framework.response import Response

from urllib.parse import unquote


class GetNames(APIView):
    def get(self, request):
        query_set = Cargo.objects.all()
        serializer = CargoSerializer(instance=query_set, many=True)
        return Response(serializer.data)


class GetAmountsAndDays(APIView):
    def get(self, request, name, day_from, day_to):
        # TODO: can 'unquote' has errors?
        name = unquote(name)
        query_set = Cargo.objects.filter(name=name)

        if len(query_set) == 0:
            serializer = AmountsAndDaysSerializer(instance=[], many=True)
            return Response(serializer.data)

        # TODO: can 'unquote' has errors?
        # TODO: passed value isn't integer
        day_from = int(unquote(day_from))
        day_to = int(unquote(day_to))
        cargo_id = query_set[0].id
        query_set = FreightCar.objects.filter(cargo_id=cargo_id, day_number__gte=day_from, day_number__lte=day_to)
        serializer = AmountsAndDaysSerializer(instance=query_set, many=True)
        return Response(serializer.data)
