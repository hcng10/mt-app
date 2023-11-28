import numpy as np

from skimage.feature import hog


class FeaturesRGB:
    def __init__(self, hog_params):
        
        self.orientations = hog_params['orientations']
        self.pixels_per_cell = hog_params['pixels_per_cell']
        self.cells_per_block = hog_params['cells_per_block']
        self.block_norm = hog_params['block_norm']
        
        
    def cal_hog(self, img, channel):
        
        self.RGB_img = img
        self.img_dmns = img.shape
        
        self.R_image = img[:, :, 0]
        self.G_image = img[:, :, 1]
        self.B_image = img[:, :, 2]
        
        #(n_blocks_row, n_blocks_col, n_cells_row, n_cells_col, n_orient) 
        self.R_hogd, self.R_hog_image = hog(self.R_image,
                                            orientations = self.orientations,
                                            pixels_per_cell = self.pixels_per_cell,
                                            cells_per_block = self.cells_per_block,
                                            visualize = True)
        
        
        self.G_hogd, self.G_hog_image = hog(self.G_image,
                                            orientations = self.orientations,
                                            pixels_per_cell = self.pixels_per_cell,
                                            cells_per_block = self.cells_per_block,
                                            visualize = True)
        
                
        
        self.B_hogd, self.B_hog_image = hog(self.B_image,
                                            orientations = self.orientations,
                                            pixels_per_cell = self.pixels_per_cell,
                                            cells_per_block = self.cells_per_block,
                                            visualize = True)
        
        hog_flatten = np.hstack((self.R_hogd, self.G_hogd, self.B_hogd))
        
        
        #fig, ax = plt.subplots(1, 2, figsize=(5, 5))
        
        #ax[0].axis('off')
        #ax[0].title.set_text('Original')
        #R_hog_image_rescaled = exposure.rescale_intensity(self.R_hog_image, in_range=(0, 10))
        #ax[0].imshow(R_hog_image_rescaled, cmap=plt.cm.gray)
        #ax[0].imshow(self.RGB_img)
        
        #ax[1].axis('off')
        #ax[1].title.set_text('HOG (pixels_per_cell 8x8)')
        #R_hog_image_rescaled = exposure.rescale_intensity(self.R_hog_image, in_range=(0, 10))
        #ax[1].imshow(R_hog_image_rescaled, cmap=plt.cm.gray)
        
        #ax[2].axis('off')
        #B_hog_image_rescaled = exposure.rescale_intensity(self.B_hog_image, in_range=(0, 10))
        #ax[2].imshow(B_hog_image_rescaled, cmap=plt.cm.gray)  
        
        #print(self.R_hogd.shape)

        
        return hog_flatten