#------------------------------------------------------------------------------#
# summarize all data by participant
# created by Francesco Pupillo
#------------------------------------------------------------------------------#
rm(list=ls())
library(dplyr)
library(ggplot2)
library(CircStats)
library(lmerTest)
source("helper_functions/get_fixations.R")
source('helper_functions/sign_det.R')

cd<-getwd()

# loop throught the folders
agegroups<-list.files("data")

# create empty files
data_all_retrieval<-vector()
data_all_encoding<-vector()

group_data<-vector()

for (agegr in agegroups){
  
setwd(cd)
  
# check how many subs
subs<-list.files(paste0("data/", agegr, "/clean_data"))


#subs<-subs[5:length(subs)]

# exclude sub 109
subs<-subs[subs!="sub-109"]

setwd(paste0("data/", agegr))

for (sub in subs){
  
  dominant_eye<-"right"
  # sub<-subs[8]
  sub_n<-substr(sub, 5, 7)
  
  # encoding data
  data_encoding<-read.csv(paste0("clean_data/", sub, "/beh/", sub_n, "_encoding.csv"))
  
  # recognition data
  data_recog<-read.csv(paste0("clean_data/", sub, "/beh/", sub_n, "_recog.csv"))
  
  # get group data
  c_data<-sign_det(data_recog, sub_n)
  c_data$age_group<-agegr
  group_data<-rbind(group_data, c_data)
  
  # remove the duplicates in the recognition file
  images<-as.character(unique(data_recog$object))
  
  # remove empty values
  images<-images[nchar(images)>1]
  
  # create two datasets, one for recognition (first occurrence), one for location
  # (second occurrence)
  recog<-list()
  
  for (im in 1:length(images)){
    # subset the image
    curr_im<-data_recog[data_recog$object==images[im],]
    
    max<-nrow(curr_im)
    
    recog[[im]]<-curr_im[1,]
    # locat[[im]]<-curr_im[max,]
    
    
  }
  
  data_rec<-do.call(rbind, recog)
  
  # check that the images are repeated only ones
  old_im<-sort((unique(data_encoding$object[data_encoding$isFiller==0])))
  
  length(old_im)
  
  # check that all the old images were presented at recognition
  is_present<-vector()
  
  for (n in 1:length(old_im)){
    
    image<-old_im[n]
    
    image_rec<-data_rec$conf_resp.keys[data_rec$object==image][1] 
    
    is_present[n]<-ifelse(is.na(image_rec), 0, 1)
    
  }
  
  if (sum(is_present)==length(old_im)){
    print(paste0("all the images were presented at recognition for sub ",sub_n ))
  } else{
    print(paste0(sum(is_present) ," of old recognition images were present at encoding for sub ", sub_n))
  }
  
# we need to delete those images at recognition that were not present at encoding
 pre_im<-old_im[is_present==1]
  
 data_rec<-data_rec[data_rec$object %in% pre_im,] 
 
 # SAW data
  if (file.exists(paste0("clean_data/",sub, "/beh/",sub_n, "_SAW.csv"  ))){
    name<-paste0(sub, "/beh/", sub_n, "_SAW.csv")
    # read it
  data_SAW<-read.csv(paste0("clean_data/", sub, "/beh/", sub_n, "_SAW.csv"))
  # save it
  write.csv(data_SAW,paste0("all_data_SAW/", sub_n, "_SAW.csv"))
  }
  
  # remove nas
  data_encoding<-data_encoding[!is.na(data_encoding$radians),]
  
  # add the trial n by block
  # count how many first scenario
  lists<-unique(data_encoding$list)
  n_list1<-nrow(data_encoding[data_encoding$list==lists[1],])
  n_list2<-nrow(data_encoding[data_encoding$list==lists[2],])
  
  data_encoding$trial_n_block<-c(1:n_list1, 1:n_list2)
  
  #data_rec[data_rec]
  
  # check that all the old images were presented at recognition
  is_present<-vector()
  
  # check that all the old images at arecognition are present at encoding
  rec_im<-sort(data_rec$object[data_rec$old_new=="old"])
  is_present<-NA
  for (n in 1:length(rec_im)){
    
    image<-rec_im[n]
    
    image_enc<-data_encoding$radians[data_encoding$object==image][1] 
    
    is_present[n]<-ifelse(is.na(image_enc), 0, 1)
    
  }
  
  if (sum(is_present)==length(old_im)){
    print(paste0("all the images were presented at recognition for sub ",sub_n ))
  } else{
    print(paste0(sum(is_present), " of encoding images were present at recognition for sub ", sub_n))
  }
  
  # we need to delete the filler images presented at recognition (we can do it later on)
  filler_images<-unique(data_encoding$object[data_encoding$isFiller==1])
  
  data_rec<-data_rec[!data_rec$object %in% filler_images,]
  
  # check if we have eyetracking data
  if ( dir.exists(paste0("clean_data/",sub, "/et" ))){
    
    # get the data
    data_et<-read.csv(paste0("clean_data/",sub, "/et/", sub, "_eye-", dominant_eye, 
                             "_last-fixation_et.csv"))
    
    # get prediction and prediction error
    data_encoding<-get_fixations(data_encoding, data_et)
    
  } else{
    data_encoding$block<-NA
    data_encoding$trial_n<-NA
    data_encoding$x<-NA
    data_encoding$y<-NA
    data_encoding$fixations<-NA
    data_encoding$center_low<-NA
    data_encoding$fixation_error<-NA
    data_encoding$fixation_prediction<-NA
  }
  
  # 
  # # now we take the file presented at encoding (old, non-filler) and attach the subsequent memory
  # data_encoding_nonFill<-data_encoding[data_encoding$isFiller==0,]
  # data_encoding_nonFill$in_out_resp<-NA
  # data_encoding_nonFill$recog_acc<-NA
  # data_encoding_nonFill$location<-NA
  # 
  # # set the data_old to na
  # data_rec$old_new<-NA
  # for (n in 1:nrow(data_encoding_nonFill)){
  #   
  #   curr_im<-data_encoding_nonFill$stimulus[n]
  #   # check if it is present at recog
  #   if(any(data_rec$stimulus==curr_im)){
  #     
  #     resp_recog<-data_rec$conf_resp.keys[data_rec$stimulus==curr_im]
  #     data_encoding_nonFill$recog_acc[n]<-
  #    ifelse(data_rec$conf_resp.keys[n]>=4,1,0)
  #     
  #     # rename the old-new variable
  #     data_rec$old_new[data_rec$stimulus==curr_im]<-"old"
  #   } else{
  #     data_rec$old_new[data_rec$stimulus==curr_im]<-"new"
  #     
  #   }
  #   
  # }

# create accuracy  
  data_rec$recog_acc<-NA
  for (n in 1:nrow(data_rec)){
    if (!is.na(data_rec$old_new[n])){
    if (data_rec$old_new[n] == "old"){
      if (data_rec$conf_resp.keys[n]>=4){
        data_rec$recog_acc[n]<- 1 }else{   data_rec$recog_acc[n]<- 0}
    }else if(data_rec$old_new[n] == "new"){
      if (data_rec$conf_resp.keys[n]<4){
        data_rec$recog_acc[n]<- 1 }else{   data_rec$recog_acc[n]<- 0}
    }
    }
  }

  data_rec %>%
    group_by(old_new) %>%
    tally()
  
  
  # now attach at recognition the data that we find at encoding
  data_rec$in_out_resp<-NA
  data_rec$in_out_corr_resp<-NA
  data_rec$in_out_rt<-NA
  data_rec$fixation_prediction<-NA
  data_rec$fixation_error<-NA
  for (n in 1:nrow(data_rec)){
    
    if(data_rec$old_new[n]=="old"){

      # indoor-outdoor resp
      in_o_resp<-data_encoding$ind_out_resp.keys[data_encoding$object ==
                                                                data_rec$object[n]]
      
      data_rec$in_out_resp[n]<-ifelse(in_o_resp=="a", "outdoors", "indoors")
      
      # indoor/outdoor correct response
      data_rec$in_out_corr_resp[n]<-ifelse( data_rec$in_out_resp[n] == 
                                              data_rec$outdoors_response[n], 1, 0)
      
      # indoor/outdoor RT
      data_rec$in_out_rt[n]<-data_encoding$ind_out_resp.rt[data_encoding$object==
                                                             data_rec$object[n]]
      
      data_rec$fixation_prediction[n]<-data_encoding$fixation_prediction[data_encoding$object ==
                                                                         data_rec$object[n]]
      
      data_rec$fixation_error[n]<-data_encoding$fixation_error[data_encoding$object ==
                                                                           data_rec$object[n]]
      
      data_rec$trial_n[n]<-data_encoding$trial_n[data_encoding$object ==
                                                                 data_rec$object[n]]
      
      data_rec$trial_n_block[n]<-data_encoding$trial_n_block[data_encoding$object ==
                                                   data_rec$object[n]]
      data_rec$age[n]<-data_encoding$age[1]
      data_rec$gender[n]<-data_encoding$gender[1]
      data_rec$handedness[n]<-data_encoding$handedness[1]
      
      
    }
    
    # get location error
    # now calculate PE
    data_rec$location_error<-NA
    for (j in 1:nrow(data_rec)){
      # location presented in degrees
      presented<-as.numeric(data_rec$degrees[j])
      # response
      response<-data_rec$response[j]
      #radCent<-center*3.14/180
      firstdiff<- abs(presented-response)
      
      max_deg<-max(presented,response)
      min_deg<-min(presented, response)
      
      seconddiff<-abs(min_deg +(360-max_deg))
      data_rec$location_error[j]<-min((firstdiff), (seconddiff))
    }

  }
  
  # assign agegroup
  data_rec$age_group<-agegr
  data_encoding$age_group<-agegr
  
  # select only those
  # save it
  write.csv(data_rec, paste0("all_data/",sub_n, "_recognition_cleaned.csv"), row.names = F)
  
  data_all_retrieval<-rbind(data_all_retrieval, data_rec)
  
  data_all_encoding<-rbind(data_all_encoding, data_encoding)
  
}
}

setwd(cd)
# write group-data
write.csv(data_all_retrieval, "group_data/All_data_retrieval.csv")
write.csv(data_all_encoding, "group_data/All_data_encoding.csv")

group_data<-group_data[order(group_data$participant),]
write.csv(group_data, "group_data/wide_data.csv")
