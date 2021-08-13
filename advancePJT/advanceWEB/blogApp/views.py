from django.shortcuts import render
from .models import *

# Create your views here.

def index(request) :
    print('blog index~')
    return render(request , 'blog/index.html')

# SQL : insert into WebBlog values(title, regDate, body)
# mapping : model(attr = value , attr = value , attr = value )
#           model.save() - insert
# CRUD
def register(request) :
    if request.method == 'POST':
        title = request.POST['title']
        regDate = request.POST['regDate']
        body = request.POST['body']
        print('param ~ ' , title , regDate , body)
        blog = WebBlog(title = title , regDate = regDate , body = body)
        blog.save()
    return render(request , 'blog/result.html')

# SQL : select * from WebBlog ;
# mapping : model.objects.all()


def list(request) :
    blogs = WebBlog.objects.all()
    print('blogs - ' , type(blogs) , blogs)
    for obj in blogs :
        print('for - ', obj.title)
    context = { 'blogs' : blogs }
    return render(request , 'blog/list.html' , context)

# SQL : select * from WebBlog where title = XXXXX ;
# mapping : model.objects.get(title = XXXX )
def search(request) :
    title = request.POST['title']
    print('blog search - ' , title )
    blog = WebBlog.objects.get(title = title)
    print('blog search result - ' , blog.title , blog.regDate , blog.body)
    context = { 'blog' : blog }
    return render(request, 'blog/search.html' , context)





