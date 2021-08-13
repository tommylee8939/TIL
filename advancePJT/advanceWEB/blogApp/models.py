from django.db import models

# Create your models here.

# ORM(Object Releationship Mapping)
# class - instance - table
# create table WebBlog(title varchar2(100) , regDate Date , body varchar2(100) )
class WebBlog(models.Model) :
    title   = models.CharField(max_length=100)
    regDate = models.DateField()
    body    = models.TextField()







