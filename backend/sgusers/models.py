from django.contrib.auth.models import AbstractBaseUser, AbstractUser, PermissionsMixin
from django.db import models
from django.utils import timezone
from django.utils.translation import gettext_lazy as _
from urllib.parse import quote

from .managers import SgUserManager

import datetime
import os

# Create your models here.
class SgUserModel (AbstractBaseUser, PermissionsMixin):

    username = None

    email = models.EmailField(_("email address"), unique=True)
    date_joined = models.DateTimeField(default=timezone.now)

    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)

    USERNAME_FIELD = "email"

    first_name = models.CharField("First name", max_length=255)
    last_name = models.CharField("Last name", max_length=255)


    REQUIRED_FIELDS = ["first_name", "last_name"]

    objects = SgUserManager()


    def __str__(self):
        return self.first_name



# lets us explicitly set upload path and filename
def upload_to(instance, filename):
    
    showtime = datetime.datetime.now().strftime("crop_%Y-%m-%d-%H%M%S")
    filename, file_extension = os.path.splitext(filename)
    
    file_str = showtime + "_" + instance.testInfo1 + "_" + instance.testInfo2 + file_extension

    return "{0}/{1}".format(quote(instance.user.email), file_str)

def upload_to_originals(instance, filename):

    showtime = datetime.datetime.now().strftime("original_%Y-%m-%d-%H%M%S")
    filename, file_extension = os.path.splitext(filename)

    file_str = showtime + "_" + instance.testInfo1 + "_" + instance.testInfo2 + file_extension
    print("Testing upload if work")
    #print(quote(instance.user.email))


    return "{0}/{1}".format(quote(instance.user.email), file_str)



class LftImgModel(models.Model):

    user = models.ForeignKey(
        SgUserModel, on_delete=models.CASCADE, related_name="lft_listings")

    original_lftimage = models.ImageField(upload_to=upload_to_originals, blank=True, null=True)
    crop_lftimage = models.ImageField(upload_to=upload_to, blank=True, null=True)

    cropX = models.IntegerField()
    cropY = models.IntegerField()

    cropWdith = models.IntegerField()
    cropHeight = models.IntegerField()

    phoneInfo = models.CharField(max_length = 2000)

    testInfo1 = models.CharField(max_length = 200)
    testInfo2 = models.CharField(max_length = 200)

    deviceTxt = models.CharField(max_length = 200)

    #latitude = models.DecimalField(max_digits=9, decimal_places=6)
    #longitude = models.DecimalField(max_digits=9, decimal_places=6)




    #def clean(self):
     #   self.longitude = round(self.longitude, 1)
      #  self.latitude = round(self.latitude, 1)


"""

    results = models.CharField(
        max_length=80, blank=False, null=True)

 type = models.CharField(
        max_length=100,
        blank=False,
        null=False
    )

    longitude = models.FloatField(
        help_text="Longitude, rounded to the closest 0.1 deg.",
        null=False,
        blank=False,
    )

    latitude = models.FloatField(
        help_text="Latitude, rounded to the closest 0.1 deg.",
        null=False,
        blank=False,
    )

    date = models.DateTimeField(
        help_text="Date/time, no round uo",
        blank=False,
    )
"""    



"""
class SgAdminUsers(AbstractUser):

    email = models.EmailField(_('email address'), unique = True)
    
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []
    #class Meta:
       # permissions = [("login_admin")]
"""