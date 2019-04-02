#!/usr/bin/env python
from kenya.models import County, SubCounty, Constituency
from kenya import Kenya
def main():
    """Populate Counties First code,name"""
    for c in range(1,48):
        ob=County(code=c,name=Kenya.Kenya.get_county_by_code(c))
        ob.save()
        for sob in Kenya.Kenya.get_subcounties_by_county_code(c):
            scob=SubCounty(name=sob,county=ob)
            scob.save()
        for cob in Kenya.Kenya.get_constituencies_by_county_code(c):
            cyob=Constituency(name=cob,county=ob)
            cyob.save()
    County.objects.all()

