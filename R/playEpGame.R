# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'



######################################################################################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################
#################################################### FUNCTION CODE ###################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################

#' Generate either a widget or video to view zoid behavior over the course of a game.
#'
#' @param g A data object or string location. Used to form an object of class \code{"data.table"} that holds zoid_rep and board_rep information.
#' @param game A numeric. Used to select which game you are interested in.
#' @param episode.col A string. Used to designate the name of the column from the object \code{g} that contains Episode Numbers.
#' @param game.col A string. Used to designate the name of the column from the object \code{g} that contains Game Numbers.
#' @param board_rep.col A string. Used to designate the name of the column from the object \code{g} that contains Board Representations.
#' @param zoid_rep.col A string. Used to designate the name of the column from the object \code{g} that contains Zoid Representations.
#' @param time.col A string. Used to designate the name of the column from the object \code{g} that contains Time stamp information. Setting this alters the behavior of the manipulate version of the function, uses time instead of "frame" as the second slider.
#' @param justTime A boolean. Used in conjunction with \code{time.col} such that when \code{time.col} is provided changes manipulate widget functionality to only use one slider for time.
#' @param video Baoolean (default \code{FALSE}). Used to determine whether the output will be a widget or a video.
#' @param suffix A string used if \code{video} is \code{TRUE}. The suffix is added to the end of the video file name for clarity. Defaults to \code{NULL}, and if \code{NULL} the suffix will be the current datestamp.
#' @param .interval A numeric set to determine the duration of a frame for video playback (when \code{video} is \code{TRUE}). Defaults to 0.1. When \code{time.col} is provided, and \code{video} is False, sets the increment the slider will move at.
#'
#' @import data.table
#' @import ggplot2
#' @import manipulateWidget
#' @import jsonlite
#' @import plotly
#' @import bit64
#' @import stringr
#'
#' @return Either a Shiny widget or Video depending on the designation of \code{video} (and whether the \code{"animation"} package loads).
#' @examples
#'
#' rda <- fread("data.txt") ## load in the file, or use sample data
#' data(MetaTWO)
#' rda <- MetaTWO
#'
#' #option one, do not include "time.col". This has episodes as the top slider, and frames as the bottom slider.
#' playEpGame(g=rda, game = 3,game.col="V7",episode.col="V8",board_rep.col = "V24",zoid_rep.col="V25")
#'
#' #option two, do include "time.col", justTime default to F. This has episodes as the top slider, and time in the episode as the bottom slider. .interval defaults to 0.1
#' playEpGame(g=rda, game = 3,game.col="V7",episode.col="V8",board_rep.col = "V24",zoid_rep.col="V25", time.col ="V1")
#'
#' #option three, do include "time.col", set justTime to T. This has only one slider which is time.  .interval defaults to 0.1
#' playEpGame(g=rda, game = 3,game.col="V7",episode.col="V8",board_rep.col = "V24",zoid_rep.col="V25", time.col ="V1", justTime = T, .interval = .1)
#'
#' ## The following results in a video. However, it requires the Animation package (and will download it if it is not installed).
#' ##      Further, requires that you externally install FFmpeg (not an R package) as that is the software animation requires to create a video
#' ##      using the function install.ffmpeg() will provide steps on how to do so.  Note that creating a video takes a long time
#' ##      about as long as the game would've taken in realtime. Also note that the interval refers to how long each frame should stay on, which means that
#' ##      you're not actually getting the actual time between each frame.
#' playEpGame(g=rda, game = 3,game.col="V7",episode.col="V8",board_rep.col = "V24",zoid_rep.col="V25", time.col ="V1", video=T, suffix= "003", .interval = 0.1)
#'
#' # Additional Example with Built-in Data
#' data(MetaT) ## loads in example Meta-T complete file, unaltered
#' playEpGame(g=MetaT, game = 2, game.col = "game_number", episode.col = "episode_number",
#'            board_rep.col = "board_rep", zoid_rep.col = "zoid_rep")
#'
#' data(MetaTWO) ## loads in example Meta-TWO game data file, unaltered
#' playEpGame(g=MetaTWO, game = 2, game.col = "V7", episode.col = "V8",
#'            board_rep.col = "V24", zoid_rep.col = "V25")
#'
#' @export

playEpGame <- function(g, game, episode.col, game.col, board_rep.col, zoid_rep.col, time.col=NULL, video=F, suffix=NULL, .interval = .1, justTime=F){
  if(video){
    req.load("animation")
  }
  if("character" %in% class(g)){
    g <- fread(g)
    if(!"data.table" %in% class(g)){
      stop("Failed to read in file.")
    }
  }
  if(class(justTime)=="character"){
    if(tolower(justTime)=="true"){
      justTime=T
    }else{justTime=F}
  }
  if(class(video)=="character"){
    if(tolower(video)=="true"){
      video=T
    }else{video=F}
  }
  if(class(.interval)=="character"){
  .interval = as.numeric(.interval)
  }

  if(video==T & !is.null(time.col)){
    warning("Currently the video output will not use the actual time of the game, time.col is set but will not be used.")
  }
  if(.interval > 1){
    warning(".interval is used to determine the length a frame is displayed, a value greater than 1 will create an extraordinarily long video.")
  }

  getBlocks <- function(board_rep) {

    .x <- 0
    .y <- 0
    .w <- 500 / ncol(board_rep)

    blocks <- data.table()
    for (r in 1:nrow(board_rep)) {
      for (c in 1:ncol(board_rep)) {
        if (board_rep[r,c]!=0) {
          bl <- .x + (c-1) * .w
          br <- bl + .w
          bb <- .y + (20-r) * .w
          bt <- bb + .w
          blocks <- rbindlist(list(blocks, list(c=c,r=r,v=board_rep[r,c],x=list(c(bl,br,br,bl,bl)),y=list(c(bb,bb,bt,bt,bb)))))
        }
      }
    }

    blocks
  }
  gg_color_hue <- function(n) {
    hues = seq(15, 375, length = n + 1)
    hcl(h = hues, l = 65, c = 100)[1:n]
  }

  zcol <- c(gg_color_hue(9))
  names(zcol) <- c("1", "2", "3", "4", "5", "6", "7", "8","9")
  if(is.null(time.col)){
    reps = unique(g[get(game.col)==game,list(board_rep = get(board_rep.col), zoid_rep = get(zoid_rep.col), episode_number=as.numeric(get(episode.col)), game_number=as.numeric(get(game.col)) )])[zoid_rep!=""]
  }else{
    reps = unique(g[get(game.col)==game,list(time = as.numeric(get(time.col)), board_rep = get(board_rep.col), zoid_rep = get(zoid_rep.col), episode_number=as.numeric(get(episode.col)), game_number=as.numeric(get(game.col)) )])[zoid_rep!=""]
  }
  breps <- lapply(lapply(str_replace_all(unique(reps$board_rep),"'",""), fromJSON), getBlocks)
  zrep <- lapply(lapply(str_replace_all(unique(reps$zoid_rep),"'",""), fromJSON), getBlocks)
  b.id <- data.table(board_rep = unique(reps$board_rep), b_id= c(1:NROW(breps)))
  z.id <- data.table(zoid_rep = unique(reps$zoid_rep), z_id= c(1:NROW(zrep)))
  rep.dt <- copy(reps)[z.id, z_id := z_id, on=(zoid_rep="zoid_rep")][b.id, b_id := b_id, on=(board_rep="board_rep")][, c("frame_id") := list(1:.N) , by=episode_number]


  get.zbr <- function(episode, frame){
    cur.frame<-rep.dt[episode_number==episode & frame_id==frame]
    rbindlist(list(breps[[cur.frame$b_id]], zrep[[cur.frame$z_id]]))[, id:= 1:.N][, list(x=as.numeric(unlist(x)),y=as.numeric(unlist(y)), zoid = v), by = id]
  }

  if(!video || !requireNamespace("animation", quietly = TRUE)){

    if(is.null(time.col)){
      manipulateWidget(
        ggplotly(
          ggplot(data= data.table(get.zbr(episode, frame))) +  geom_polygon( aes(x=x, y=y, fill = factor(zoid), group = id)) +
            scale_fill_manual(name="Zoid", labels=list("1"="I", "2"="O", "3" = "T", "4" = "S", "5"="Z", "6"="J", "7"= "L", "8"="Option 1", "9"="Option 2"), values= zcol) +
            coord_fixed(ratio = 1, xlim = c(0, 500), ylim=c(0,1000)) + theme_bw()+ guides(fill=FALSE, color=FALSE) +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(), axis.line = element_blank(),
                  axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(),
                  panel.background = element_rect(fill="black"))
        ),
        episode = mwSlider(min=0,max=max(rep.dt$episode_number) ,value = 0, step=1),
        frame = mwSlider(min=1, max=max(rep.dt[episode_number==max(c(episode,0))]$frame_id)  , value=1, step = 1 ) #max(rep.dt[episode_number==episode]$frame_id)
      )
    }else{
      if(justTime){
        manipulateWidget(
          ggplotly(
            ggplot(data= get.zbr(max(rep.dt[time<=eptime ]$episode_number), max(rep.dt[time<=eptime & episode_number== max(rep.dt[time<=eptime ]$episode_number) ]$frame_id))) +  geom_polygon( aes(x=x, y=y, fill = factor(zoid), group = id)) +
              scale_fill_manual(name="Zoid", labels=list("1"="I", "2"="O", "3" = "T", "4" = "S", "5"="Z", "6"="J", "7"= "L", "8"="Option 1", "9"="Option 2"), values= zcol) +
              coord_fixed(ratio = 1, xlim = c(0, 500), ylim=c(0,1000)) + theme_bw()+ guides(fill=FALSE, color=FALSE) +
              theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                    panel.grid.minor = element_blank(), axis.line = element_blank(),
                    axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(),
                    panel.background = element_rect(fill="black"))
          ),
          eptime = mwSlider(min=min(rep.dt$time),max=max(rep.dt$time) ,value = min(rep.dt$time), step=.interval)
        )

      }else{
        manipulateWidget(
          ggplotly(
            ggplot(data= get.zbr(episode, max(rep.dt[time<=eptime & episode_number==episode]$frame_id))) +  geom_polygon( aes(x=x, y=y, fill = factor(zoid), group = id)) +
              scale_fill_manual(name="Zoid", labels=list("1"="I", "2"="O", "3" = "T", "4" = "S", "5"="Z", "6"="J", "7"= "L", "8"="Option 1", "9"="Option 2"), values= zcol) +
              coord_fixed(ratio = 1, xlim = c(0, 500), ylim=c(0,1000)) + theme_bw()+ guides(fill=FALSE, color=FALSE) +
              theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                    panel.grid.minor = element_blank(), axis.line = element_blank(),
                    axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(),
                    panel.background = element_rect(fill="black"))
          ),
          episode = mwSlider(min=0,max=max(rep.dt$episode_number) ,value = 0, step=1),
          eptime = mwSlider(min=min(rep.dt[episode_number==max(c(episode,0))]$time), max = max(rep.dt[episode_number==max(c(episode,0))]$time), value =min(rep.dt[episode_number==max(c(episode,0))]$time), step = .interval )
          # frame = mwSlider(min=1, max=max(rep.dt[episode_number==max(c(episode,0))]$frame_id)  , value=1, step = 1 ) #max(rep.dt[episode_number==episode]$frame_id)
        )
      }
    }

  }else{
    .type = "EpGame"
    justAWrap <- function(){
      for(episode in 0:max(rep.dt$episode_number)){
        for(frame in 1:max(rep.dt[episode_number==episode]$frame_id)){
          plt<-ggplot(data= get.zbr(episode, frame)) +  geom_polygon( aes(x=x, y=y, fill = factor(zoid), group = id)) +
            scale_fill_manual(name="Zoid", labels=list("1"="I", "2"="O", "3" = "T", "4" = "S", "5"="Z", "6"="J", "7"= "L", "8"="Option 1", "9"="Option 2"), values= zcol) +
            coord_fixed(ratio = 1, xlim = c(0, 500), ylim=c(0,1000)) + theme_bw()+ guides(fill=FALSE, color=FALSE) +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(), axis.line = element_blank(),
                  axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(),
                  panel.background = element_rect(fill="black"))
          print(plt)
        }
      }
    }
    if(is.null(suffix)){
      saveVideo(justAWrap(), video.name = sprintf("%s_%s_%s.mp4",.type,game,format(Sys.Date(), "%Y%m%d")), interval = .interval, ani.width=500, ani.height=1000)
    }else{
      saveVideo(justAWrap(), video.name = sprintf("%s_%s_%s.mp4",.type,game,suffix), interval = .interval, ani.width=500, ani.height=1000)

    }

  }
}


######################################################################################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################
###################################################### RUN CODE ######################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################

### you should be able to read in any file that has a column for "game number", "episode number", "board rep", and "zoid rep"



#####For all the following functions you will need to set the variables
# g             --  this is your data file, must be a complete file as the episode file does not have the times for the zoid_rep changes.
# game          --  currently the tool only works for a single game, give a number of which game you are interested in.
# game.col      --  the label from the header for the column containing "game_number" information
# episode.col   --  the label from the header for the column containing "episode_number" information
# board_rep.col --  the label from the header for the column containing "board_rep" information
# zoid_rep.col  --  the label from the header for the column containing "zoid_rep" information
#### Optional variables
# time.col      --  the label from the header for the column containing "time" information -- setting this alters the behavior of the manipulate version of the function
# justTime      --  boolean, when `time.col` is provided changes manipulate widget functionality to only use one slider for time.
# .interval     --  when the `time.col` is provided, sets the increment the slider moves. when `video` = T, sets the time a frame rate of the video
# video         --  attempts to create a video instead of manipulate widget.


################################# Results in a widget that you can manipulate #################################
