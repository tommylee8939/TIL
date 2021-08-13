from django.urls import path, include
from blogApp  import views

urlpatterns = [
    path('index/',          views.index ),
    path('register/',       views.register ),
    path('list/',            views.list ),
    path('search/',            views.search ),
]


