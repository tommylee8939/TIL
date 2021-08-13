from django.shortcuts import render


def index(request) :
    return render(request , 'index.html')

# request - response
def login(request) :
    if request.method == 'POST' :
        id  = request.POST['id']
        pwd = request.POST['pwd']
        context = { 'msg' : 'request post'}
        return render(request , 'result.html' , context)
    elif request.method == 'GET' :
        id = request.GET['id']
        pwd = request.GET['pwd']
        context = {'msg': 'request get'}
        return render(request, 'result.html', context)

def param(request) :
    print('web param ~')
    id = request.GET['id']
    pwd = request.GET['pwd']
    print('param ~ ' , id , pwd )
    context = {'msg': 'a tag param'}
    return render(request, 'result.html', context)

