get_fixations<-function(data_encoding, data_et){
  #----------------------------------------------------------------------------#
  # Function to get the fixation error and prediction from the eye tracing data
  # INPUT: encoding_data - data at encoding
  #        et_data - eyetracking data
  # OUTPUT: encoding data pluse fixation_prediction (how close participants fixate
  #         at the point of low PE) and fixation error (distance between the 
  #         location of the presentation of the third truck and participants' 
  #         fixations). Fixation prediction is 180-fixation error
  #----------------------------------------------------------------------------#
  
  # attach to the encoding dataset
  data_encoding_et<-cbind(data_encoding, data_et)
  
  # get the angle given x and y coordinates
  # the x coordinate is the adjacent while the y is the opposite
  # tan(angle) = opposite (y) / adjacent (x)
  # angle = tan-1(opposite/adjacent)

  # get the angle (in radians) and convert it into degrees
  # however, the opposite is given in + and -

  new_y<-ifelse(data_encoding_et$y<=540, (540-data_encoding_et$y), -(data_encoding_et$y-540 ))
  new_x<-ifelse(data_encoding_et$x<=960, -(960-data_encoding_et$x), (data_encoding_et$x-960))
  
  # get the quadrant
  quadrant<-NA
  tanx<-NA
  x_rad<-NA
  x_deg<-NA
   for (n in 1:length(new_y)){
      if (!is.na(new_y[n])){
    if (new_x[n]>0 & new_y[n]>0){
      quadrant[n]<-1
      tanx[n]<-(new_y[n])/(new_x[n])
      x_rad[n]<-atan(tanx[n])
      x_deg[n]<-x_rad[n]*180/pi
    }else if(new_y[n]>0 & new_x[n]<0){
      quadrant[n]<-2
      tanx[n]<-(new_y[n])/(new_x[n])
      x_rad[n]<-atan(tanx[n])
      x_deg[n]<-(x_rad[n]*180/pi)+180
    } else if(new_y[n]<0 & new_x[n]<0){
    quadrant[n]<-3
    tanx[n]<-(new_y[n])/(new_x[n])
    x_rad[n]<-atan(tanx[n])
    x_deg[n]<-(x_rad[n]*180/pi)+180
    } else{
    quadrant[n]<-4
    tanx[n]<-(new_y[n])/(new_x[n])
    x_rad[n]<-atan(tanx[n])
    x_deg[n]<-(x_rad[n]*180/pi)+360
    }
      }else{
        x_deg[n]<-NA
      }
    }
  
  # get the degree of the fixation
  data_encoding_et$fixations<-x_deg
  
  # get the two centers
  lists<-unique(data_encoding_et$list)
  #lists<-substr(lists,nchar(lists[1])-4, nchar(lists[1])-4 )
  
  first_center<-data_encoding_et$center[data_encoding_et$list==lists[1] &
                                          data_encoding_et$type == "low"][1]
  second_center<-data_encoding_et$center[data_encoding_et$list==lists[2] &
                                           data_encoding_et$type == "low"][1]
  
  # get the listwise center
  data_encoding_et$center_low<-ifelse(data_encoding_et$list == lists[1], first_center, 
                                      second_center)
  
  #   # calculate distance
  data_encoding_et$fixation_error<-NA
  data_encoding_et$fixation_prediction<-NA
  data_encoding_et$fix_diff_second_truck<-NA
  for (j in 1:nrow(data_encoding_et)){
    
    # presented position of the third truck in degrees
    presented<-as.numeric(data_encoding_et$degrees[j])
    
    # location center in degrees 
    center<-as.numeric(data_encoding_et$center_low[j])
    
    # fixation
    fixation<-data_encoding_et$fixations[j]
    
    # do it for error 
    #radCent<-center*3.14/180
    firstdiff<- abs(presented-fixation)

    max_deg<-max(presented,fixation)
    min_deg<-min(presented, fixation)

    seconddiff<-abs(min_deg +(360-max_deg))
    
    # fixation error
    data_encoding_et$fixation_error[j]<-min((firstdiff), (seconddiff))
    
    # do it for prediction
    firstdiff2<- abs(center-fixation)
    
    max_deg2<-max(center,fixation)
    min_deg2<-min(center, fixation)
    
    seconddiff2<-abs(min_deg2 +(360-max_deg2))
    
    # fixation strength
    #data_encoding_et$fixation_prediction[j]<-180-  data_encoding_et$fixation_error[j]
    data_encoding_et$fixation_prediction[j]<-min(firstdiff2, seconddiff2)
    
    # do it for second truck
    firstdiff3<-max(pos_2, fixation)
    
    max_deg3<-max(pos_2,fixation)
    min_deg3<-min(pos_2, fixation)
    
    firstdiff3<-max(pos_2, fixation)
    
    seconddiff3<-abs(min_deg3 +(360-max_deg3))
    
    data_encoding_et$fix_diff_second_truck[j]<-min(firstdiff3, seconddiff3)
    
    
  }

  return(data_encoding_et)
  
  #
}