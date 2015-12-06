//
//  FilterControl.swift
//  Filterer
//
//  Created by dede.exe on 11/12/15.
//  Copyright © 2015 UofT. All rights reserved.
//


import UIKit

/**
 A Manager of filter to apply on an image. 
 FilterManager instantiate insternally all filters and use it to change image properties.
*/
public class FilterManager
{
    
    //MARK: - Properties

    private var _sourceImage : RGBAImage?
    private var _workSourceImage : RGBAImage?
    private var _workFilteredImage : RGBAImage?
    
    private var _smallSizeWidth : Int
    private var _smallSizeHeight : Int
    
    private var _currentFilter : Filter?
    
    private var _brigthnessFilter : BrightnessFilter?
    
    init(width:Int = 400, height:Int = 300)
    {
        self._smallSizeWidth = width
        self._smallSizeHeight = height
    }
    
    
    //Stored Attribute image
    public var image : UIImage?
    {
        set
        {
            guard let newImage = newValue else
            {
                self._sourceImage = nil
                return
            }
            
            self._sourceImage = RGBAImage(image: newImage)

            let imageResizer = ImageAspectRationResizer(image: newValue!, width: self._smallSizeWidth , height: self._smallSizeHeight)
            
            
            if let renderedImage = imageResizer.renderedImage {
                
                NSLog("renderedImage: %f, %f", renderedImage.size.width, renderedImage.size.height)
                
                self._workSourceImage = RGBAImage(image: renderedImage)
                self._workFilteredImage = self._workSourceImage
            }
        }
        
        get
        {
            return self._sourceImage?.toUIImage()
        }
    }
    
    
    //Stored Attribute image after been processed
    public var filteredImage : UIImage?
    {
        get
        {
            guard var retImage = self._sourceImage else
            {
                return nil
            }

            if let filterItem = self._currentFilter
            {
                retImage = (RGBAImage(rgbaImage: retImage)?.filter(filterItem))!
            }

            return retImage.toUIImage()
        }
    }
    
    
    public var imageThumb : UIImage?
    {
        
        get
        {
            guard let retImage = self._workSourceImage else
            {
                return nil
            }
            
            if let filterItem = self._currentFilter
            {
                self._workFilteredImage = (RGBAImage(rgbaImage: retImage)?.filter(filterItem))!
            }
            
            return self._workFilteredImage!.toUIImage()
        }
    }
    
    
    
    //MARK: Filters
    public var brigthnessFilter : BrightnessFilter
    {
        if let filter = self._brigthnessFilter
        {
            self._currentFilter = filter
            return filter
        }
        
        self._brigthnessFilter = BrightnessFilter()
        self._currentFilter = self._brigthnessFilter
        return self._brigthnessFilter!
    }
}
