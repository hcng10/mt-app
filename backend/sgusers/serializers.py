from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.serializers import PasswordResetSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework.authtoken.models import Token

from rest_framework import serializers
from .models import LftImgModel
from .forms import CustomAllAuthPasswordResetForm

import sys


class MyPasswordResetSerializer(PasswordResetSerializer):

    def validate_email(self, value):
        # use the custom reset form
        self.reset_form = CustomAllAuthPasswordResetForm(data=self.initial_data)
        if not self.reset_form.is_valid():
            raise serializers.ValidationError(self.reset_form.errors)

        return value
    

class SgRegisterSerializer(RegisterSerializer):
    #print("SGREG1", file=sys.stderr)
    first_name = serializers.CharField()
    last_name = serializers.CharField()

    def custom_signup(self, request, user):
        user.first_name = request.data['first_name']
        user.last_name  = request.data['last_name']
        user.save()
    
    

class SgLoginSerializer(LoginSerializer):
    #email = serializers.EmailField(required=False)
    pass

class TokenSerializer(serializers.ModelSerializer):

    class Meta:
        model = Token
        fields = ('key', 'user')



class LftImgSerializer(serializers.ModelSerializer):
    class Meta:
        model = LftImgModel
        fields = ('user', 'original_lftimage', 'crop_lftimage', 'cropX', \
                    'cropY', 'cropWdith', 'cropHeight', 'phoneInfo', \
                    'testInfo1', 'testInfo2', 'deviceTxt')
        #fields = "__all__"
