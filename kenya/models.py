from django.db import models

class County(models.Model):
    code=models.IntegerField(verbose_name='County Code',primary_key=True)
    name=models.CharField(max_length=21)
    def __str__(self):
        return self.name
    class Meta:
        _ordering=('name')
class SubCounty(models.Model):
    name=models.CharField(max_length=36)
    county=models.ForeignKey(County,on_delete=models.CASCADE)
    def __str__(self):
        return self.name
    class Meta:
        _ordering=('name')
class Constituency(models.Model):
    name=models.CharField(max_length=36)
    county=models.ForeignKey(County,on_delete=models.CASCADE)
    def __str__(self):
        return self.name
    class Meta:
        _ordering=('name')
