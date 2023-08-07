get_fixations_2nd<-function(df){
  #----------------------------------------------------------------------------#
  # Function to get the fixation error and prediction from the eye tracing data
  # INPUT: df - dataframe with the location of the 2nd track (pos_2) and 
  #             fixations
  # OUTPUT: the same dataframe with in addition the difference in fixations from
  #         the location of the second truck
  #----------------------------------------------------------------------------#
  
  # get the angle given x and y coordinates
  # the x coordinate is the adjacent while the y is the opposite
  # tan(angle) = opposite (y) / adjacent (x)
  # angle = tan-1(opposite/adjacent)

  # get the angle (in radians) and convert it into degrees
  # however, the opposite is given in + and -

  new_y<-ifelse(df$y<=540, (540-df$y), -(df$y-540 ))
  new_x<-ifelse(df$x<=960, -(960-df$x), (df$x-960))
  
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
  df$fixations<-x_deg
  
  # get the two centers
  lists<-unique(df$list)
  #lists<-substr(lists,nchar(lists[1])-4, nchar(lists[1])-4 )
  
  first_center<-df$center[df$list==lists[1] &
                                          df$type == "low"][1]
  # second_center<-df$center[df$list==lists[2] &
  #                                          df$type == "low"][1]
  # 
  # # get the listwise center
  # df$pos_2<-ifelse(df$list == lists[1], first_center, 
  #                                     second_center)
  
  #   # calculate distance
  df$fix_diff_second_truck<-NA
  for (j in 1:nrow(df)){
    
    # # presented position of the third truck in degrees
    # presented<-as.numeric(df$degrees[j])
    # 
    # # location center in degrees 
    # center<-as.numeric(df$center_low[j])
    
    # fixation
    fixation<-df$fixations[j]
    
    # # do it for error 
    # #radCent<-center*3.14/180
    # firstdiff<- abs(presented-fixation)
    # 
    # max_deg<-max(presented,fixation)
    # min_deg<-min(presented, fixation)
    # 
    # seconddiff<-abs(min_deg +(360-max_deg))
    # 
    # # fixation error
    # data_encoding_et$fixation_error[j]<-min((firstdiff), (seconddiff))
    # 
    # # do it for prediction
    # firstdiff2<- abs(center-fixation)
    # 
    # max_deg2<-max(center,fixation)
    # min_deg2<-min(center, fixation)
    # 
    # seconddiff2<-abs(min_deg2 +(360-max_deg2))
    # 
    # # fixation strength
    # #data_encoding_et$fixation_prediction[j]<-180-  data_encoding_et$fixation_error[j]
    # data_encoding_et$fixation_prediction[j]<-min(firstdiff2, seconddiff2)
    # 
    # do it for second truck
    pos_2<-df$pos_2[j]
    
    firstdiff3<-abs(pos_2- fixation)
    
    max_deg3<-max(pos_2,fixation)
    min_deg3<-min(pos_2, fixation)
    

    seconddiff3<-abs(min_deg3 +(360-max_deg3))
    
    df$fix_diff_second_truck[j]<-min(firstdiff3, seconddiff3)
    
    
  }

  return(df)
  
  #
}