from django.shortcuts import render,get_object_or_404

from kenya.models import *

# Create your views here.
def counties(request):
    item_list=County.objects.all()
    return render(request,"counties.html",{'item_list':item_list})
def county_details(request,item_code):
    item=get_object_or_404(County,code=item_code)
    subcounties=SubCounty.objects.filter(county=item)
    constituencies=Constituency.objects.filter(county=item)
    return render(request,'county_details.html',{'item':item,'subcounties':subcounties,'constituencies':constituencies})

