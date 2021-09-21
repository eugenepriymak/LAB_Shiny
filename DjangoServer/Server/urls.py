from django.urls import path
from Database.views import GetNames, GetAmountsAndDays

urlpatterns = [
    path('get_names/', GetNames.as_view()),
    path('get_amounts_and_days/<str:name>/<str:day_from>/<str:day_to>/', GetAmountsAndDays.as_view())
]
