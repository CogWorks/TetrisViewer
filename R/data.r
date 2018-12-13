#' Gaze and board data from a SMI RED 500 eyetracker at 500 Hz.
#' Data obtained from Meta-T. Excludes identifiers and most "features" typically collected, but otherwise unaltered.
#'
#'
#' \itemize{
#'  \item Samplerate was 500hz.
#'  \item Screen resolution was 1680 x 1050 (px).
#'  \item Screen size was 473.76 x 296.1 (mm).
#' }
#'
#' @docType data
#' @keywords datasets
#' @name MetaT
#' @usage data(MetaT)
#'
#' @format
#' \describe{
#'   \item{ts}{game timestamp}
#'   \item{event_type}{event type of "GAME_EVENT", "EYE_SAMP", etc.}
#'   \item{game_number}{the current game number for the row}
#'   \item{episode_number}{the current episode number for the row}
#'   \item{level}{the current level for the row}
#'   \item{score}{the current score for the row}
#'   \item{lines_cleared}{the lines_cleared for the row}
#'   \item{completed}{was the game completed, only prints for last row of the game}
#'   \item{game_duration}{game duration, only prints for the last row of the game}
#'   \item{avg_ep_duration}{average episode duration, only prints for the last row of the game}
#'   \item{zoid_sequence}{zoid sequence, the sequence of zoid over the course of a game, only prints for the last row of the game}
#'   \item{evt_id}{first part of a three-part event-identfication. Determines type of event for "GAME_EVENT" events}
#'   \item{evt_data1}{clarification for the evt_id column}
#'   \item{evt_data2}{clarification for the evt_data1 column}
#'   \item{curr_zoid}{the current zoid for the row}
#'   \item{next_zoid}{the current zoid in the "next box" for the current row}
#'   \item{board_rep}{board representation the the current time, only prints when the representation changes}
#'   \item{zoid_rep}{zoid representation the the current time, only prints when the representation changes}
#'   \item{smi_ts}{sample time}
#'   \item{smi_eyes}{blink information}
#'   \item{smi_samp_x_l}{horizontal gaze location of left eye}
#'   \item{smi_samp_x_r}{horizontal gaze location of right eye}
#'   \item{smi_samp_y_l}{vertical gaze location of left eye}
#'   \item{smi_samp_y_r}{vertical gaze location of right eye}
#'   \item{smi_diam_x_l}{width of left pupil}
#'   \item{smi_diam_x_r}{width of right pupil}
#'   \item{smi_diam_y_l}{height of left pupil}
#'   \item{smi_diam_y_r}{height of right pupil}
#'   \item{smi_eye_x_l}{horizontal offset of the left eye relative to the center of the screen}
#'   \item{smi_eye_x_r}{horizontal offset of the right eye relative to the center of the screen}
#'   \item{smi_eye_y_l}{vertical offset of the left eye relative to the center of the screen}
#'   \item{smi_eye_y_r}{vertical offset of the right eye relative to the center of the screen}
#'   \item{smi_eye_z_l}{distance of the left eye to the center of the screen}
#'   \item{smi_eye_z_r}{distance of the right eye to the center of the screen}
#' }
#'
#' @examples
#' data(MetaT)
#' MetaT
#'
"MetaT"
# MetaT <- MetaT[,list(ts,event_type,game_number,episode_number,level,score,lines_cleared,completed, game_duration, avg_ep_duration, zoid_sequence, evt_id,evt_data1,evt_data2,curr_zoid,next_zoid,board_rep,zoid_rep,
#                      smi_ts,smi_eyes,smi_samp_x_l,smi_samp_x_r, smi_samp_y_l,smi_samp_y_r,smi_diam_x_l,smi_diam_x_r,smi_diam_y_l,smi_diam_y_r,smi_eye_x_l,
#                      smi_eye_x_r,smi_eye_y_l,smi_eye_y_r,smi_eye_z_l,smi_eye_z_r)]
# devtools::use_data(MetaT,compress = "gzip", overwrite=T)



#' Board and gameplay data obtained from Meta-TWO, unaltered, meaning that there are no meaningful headers.
#' However, V3, V4, V5, V6 have been removed as they identify the subject
#'
#'
#' @docType data
#' @keywords datasets
#' @name MetaTWO
#' @usage data(MetaTWO)
#'
#' @format
#' \describe{


#'   \item{V1}{game timestamp}
#'   \item{V2}{event type of "GAME_EVENT", "EYE_SAMP", etc.}
#'   \item{V7}{the current game number for the row}
#'   \item{V8}{the current episode number for the row}
#'   \item{V9}{the current level for the row}
#'   \item{V10}{the current score for the row}
#'   \item{V11}{the lines_cleared for the row}
#'   \item{V12}{was the game completed, only prints for last row of the game}
#'   \item{V13}{game duration, only prints for the last row of the game}
#'   \item{V14}{average episode duration, only prints for the last row of the game}
#'   \item{V15}{zoid sequence, the sequence of zoid over the course of a game, only prints for the last row of the game}
#'   \item{V16}{first part of a three-part event-identfication. Determines type of event for "GAME_EVENT" events}
#'   \item{V17}{clarification for the evt_id column}
#'   \item{V18}{clarification for the evt_data1 column}
#'   \item{V19}{the current zoid for the row}
#'   \item{V20}{the current zoid in the "next box" for the current row}
#'   \item{V21}{ARE, referred to as "entry delay" }
#'   \item{V22}{DAS, a.k.a. "delayed auto-shift" count.}
#'   \item{V23}{softdrop count}
#'   \item{V24}{board representation the the current time, only prints when the representation changes}
#'   \item{V25}{zoid representation the the current time, only prints when the representation changes}
#'
#'
#' }
#'
#' @examples
#' data(MetaTWO)
#' MetaTWO
#'
"MetaTWO"




#### For own reference, store object and then use devtools::use_data(MetaTWO,compress = "gzip") to save correctly--so that it exports
# MetaTWO <- MetaTWO[,-c("V3","V4","V5","V6"),with=F]
# devtools::use_data(MetaTWO,compress = "gzip", overwrite=T)

