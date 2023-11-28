from django.shortcuts import render
from django.http import HttpResponse


from rest_framework import serializers
from rest_framework import generics, permissions
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser

from .models import LftImgModel
from .serializers import LftImgSerializer


from pathlib import Path
import shutil
import requests
import zipfile
import os


BASE_DIR = Path(__file__).resolve().parent
ADDED_PORT = "8000"
ADDED_PORT_PRETXT = "/media"


# Create your views here.
class UploadLftImg(generics.CreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [TokenAuthentication]

    # Parses multipart HTML form content, which supports file uploads. 
    # Both request.data will be populated with a QueryDict.
    # You will typically want to use both FormParser and 
    # MultiPartParser together in order to fully support HTML form data.
    parser_classes = [MultiPartParser, FormParser]
    serializer_class = LftImgSerializer

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            print("Serializer valid! Yes")
            self.perform_create(serializer)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            print("Serializer not valid! NO.........")

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    


def zip_directory(directory, zip_file_path):

    try:
        with zipfile.ZipFile(zip_file_path, 'w', zipfile.ZIP_DEFLATED) as zipf:      
            for root, dirs, files in os.walk(directory):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, directory)

                    zipf.write(file_path, arcname)

        return True
    
    except Exception as e:
        print("zip_directory error" + e)
        # Handle any errors that occur during the zip creation
        # TODO: need to identify the error
        return False
    

def add_port_to_url(image_url, port_no, pre_port_txt):

    if port_no in image_url:
        return image_url
    else:
        idx = image_url.find(pre_port_txt)
        if idx == -1:
            return image_url
        else:
            new_image_url = image_url[:idx] + ":" + port_no + image_url[idx:]
            return new_image_url
            
    

def download_image(image_url, directory):

    print("Testing the encoding2")
    print(image_url)
    print(directory)

    try:
        response = requests.get(image_url, stream=True, verify=False)
        response.raise_for_status()

        downloaded_filename = image_url.split("/")[-1]
        # Create the full path for the image file
        image_path = os.path.join(directory, downloaded_filename)

        with open(image_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)


        return True
    
    except requests.exceptions.RequestException as e:
        # Handle any errors that occur during the image download
        # TODO: need to identify the error
        print("download_image error" + e)
        return False



class DownloadLftImgs(generics.RetrieveAPIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [TokenAuthentication]

    serializer_class = LftImgSerializer

    def get(self, request, *args, **kwargs):

        user = request.user
        #email = request.user.email
        #print(user, user.id)

        lftImgData = LftImgModel.objects.filter(user=user)

        # Serialize the image URLs
        serializer = self.get_serializer(lftImgData, many=True)
        serialized_data = serializer.data

        print(serialized_data)

        if bool(serialized_data):

            # Create a temporary directory to store the image files
            temp_directory = os.path.join(os.path.dirname(BASE_DIR), 'lft_media_tmp/' + str(user.id) + '/images')
            os.makedirs(temp_directory, exist_ok=True)


            for i, data in enumerate(serialized_data):
                
                #print(data)
                #print(data['lftimage'])

                # Hack: just mix the photos together
                image_url_crop = data['crop_lftimage']
                image_url_crop = add_port_to_url(image_url_crop, ADDED_PORT, ADDED_PORT_PRETXT)
                download_image(image_url_crop, temp_directory)


                image_url_original = data['original_lftimage']
                image_url_original = add_port_to_url(image_url_original, ADDED_PORT, ADDED_PORT_PRETXT)
                download_image(image_url_original, temp_directory)

            # Zip the images
            zip_file_path = os.path.join(os.path.dirname(BASE_DIR), 'lft_media_tmp/' + str(user.id) + '/lft_images.zip')
            zip_directory(temp_directory, zip_file_path)

            # Delete the temporary directory
            shutil.rmtree(temp_directory)


            # Prepare the zip file for download
            with open(zip_file_path, 'rb') as f:
                response = HttpResponse(f.read(), content_type='application/zip', status=status.HTTP_200_OK)
                response['Content-Disposition'] = 'attachment; filename="lft_images.zip"'
                
                print("DownloadLftImgs: Zip file done and send")

            # Delete the zip file after download
            os.remove(zip_file_path)

            return response
        
        else:
            return Response("No content", status=status.HTTP_204_NO_CONTENT)


