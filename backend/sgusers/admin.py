from django.contrib import admin

# Register your models here.
from django.contrib.auth.admin import UserAdmin
from .models import SgUserModel, LftImgModel


class LftImgModelAdmin(admin.ModelAdmin):
    pass

admin.site.register(SgUserModel)
admin.site.register(LftImgModel, LftImgModelAdmin)