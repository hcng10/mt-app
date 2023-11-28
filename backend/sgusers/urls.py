#from django.contrib import admin
#from django.urls import path, include



from django.urls import path, re_path, include
from dj_rest_auth.registration.views import RegisterView, VerifyEmailView, ConfirmEmailView
from dj_rest_auth.views import LoginView, LogoutView, PasswordResetView ,PasswordResetConfirmView

from django.contrib.auth.views import PasswordResetCompleteView#,PasswordResetConfirmView

from .views import UploadLftImg, DownloadLftImgs


urlpatterns = [
    path('auth/', include('dj_rest_auth.urls')),
    path('auth/registration/', include('dj_rest_auth.registration.urls')),

    path('auth/password/reset/', PasswordResetView.as_view(), name='rest_password_reset'),

    path('user/password/reset/confirm/<uidb64>/<token>/', 
         PasswordResetConfirmView.as_view(),
         name='password_reset_confirm'),
    #path('user/password/reset/confirm/<uidb64>/<token>/', 
         #PasswordResetConfirmView.as_view(template_name = 'account/password_reset_confirm.html'),
         #name='password_reset_confirm'),
    path('user/password/reset/complete/',
          PasswordResetCompleteView.as_view(template_name = 'account/password_reset_complete.html'),
          name='password_reset_complete'),

    path('images/upload/', UploadLftImg.as_view(), name="lftimage_upload"),
    path('images/downloads/', DownloadLftImgs.as_view(), name="lftimage_downloads"),

    #path('account-confirm-email/<str:key>/', ConfirmEmailView.as_view()),
    #path('register/', RegisterView.as_view()),
    #path('login/', LoginView.as_view()),
    #path('logout/', LogoutView.as_view()),

    #path('verify-email/',
         #VerifyEmailView.as_view(), name='rest_verify_email'),
    #path('account-confirm-email/',
         #VerifyEmailView.as_view(), name='account_email_verification_sent'),
    #re_path(r'^account-confirm-email/(?P<key>[-:\w]+)/$',
        # VerifyEmailView.as_view(), name='account_confirm_email'),
]