# devtools::use_build_ignore("R/data-objects.R")
# MetaTWO <- fread("/Volumes/USB20FD/eyedatastuff/gazepoint/data_2017-10-21_13-47-44.txt")
# MetaTWO <- MetaTWO[,-c("V3","V4","V5","V6"),with=F]
# devtools::use_data(MetaTWO,compress = "gzip", overwrite=T)
#
#
#
#
# MetaT <- fread("../../NewROIs/Raw/3117_2015-2-18_9-37-56/complete_3117_2015-2-18_9-37-56.tsv")
# MetaT <- MetaT[,list(ts,event_type,game_number,episode_number,level,score,lines_cleared,completed, game_duration, avg_ep_duration, zoid_sequence, evt_id,evt_data1,evt_data2,curr_zoid,next_zoid,board_rep,zoid_rep,
#                      smi_ts,smi_eyes,smi_samp_x_l,smi_samp_x_r, smi_samp_y_l,smi_samp_y_r,smi_diam_x_l,smi_diam_x_r,smi_diam_y_l,smi_diam_y_r,smi_eye_x_l,
#                      smi_eye_x_r,smi_eye_y_l,smi_eye_y_r,smi_eye_z_l,smi_eye_z_r)]
# devtools::use_data(MetaT,compress = "gzip", overwrite=T)
