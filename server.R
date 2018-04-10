library(tidyverse)
library(httr)
library(stringr)

function(input, output){
  observeEvent(input$GO,{
    
    
    end.point = input$END.POINT
    key = input$KEY
    ffmpeg = input$FFMPEG
    working.dir = input$WD
    fps = input$FPS
    
    working.dir = ifelse(str_sub(working.dir, start=-1) != "/", str_c(working.dir,"/"),working.dir)

    
    movie2frames <- function(file.url, id.number){
      dir.create(paste0(working.dir, id.number))
      system(
        paste0(
          ffmpeg, " -i ", file.url, # path to ffmpeg
          " -vf fps=", fps, " ", working.dir, 
          id.number, "/image%07d.jpg")
      )
    }
    
    
    
    send.face <- function(filename) {
      Sys.sleep(3)
      face_res <- POST(url = end.point,
                       add_headers(.headers = c("Ocp-Apim-Subscription-Key" = key)),
                       body = upload_file(filename, "application/octet-stream"),
                       query = list(returnFaceAttributes = "emotion"),
                       accept_json())
      
      if(length(content(face_res)) > 0){
        ret.expr <- as_tibble(content(face_res)[[1]]$faceAttributes$emotion)
      } else {
        ret.expr <- tibble(contempt = NA,
                           disgust = NA,
                           fear = NA,
                           happiness = NA,
                           neutral = NA,
                           sadness = NA,
                           surprise = NA)
      }
      return(ret.expr)
    }
    
    
    
    
    extract.from.frames <- function(directory.location){
      face.analysis <- dir(directory.location) %>%
        as_tibble() %>%
        mutate(filename = paste0(directory.location,"/", value)) %>%
        group_by(filename) %>%
        do(send.face(.$filename)) %>%
        mutate(frame.num = 1:NROW(filename)) %>%
        mutate(origin = directory.location) %>%
        ungroup()
      return(face.analysis)
    }
    
    
    
    videos.list <- list.files(working.dir)
    videos.list <- videos.list[str_detect(videos.list, regex(".avi$")) |
                                 str_detect(videos.list, regex(".AVI$")) |
                                 str_detect(videos.list,regex(".mp4$"))]
    
    
    withProgress(message = 'Splitting videos to frames', value = 0, {
      n <- length(videos.list)
      for (i in videos.list){
        incProgress(1/n, detail = str_c("processing video ", i))
        movie2frames(str_c(working.dir, i), str_c(i, "_frames"))
      } 
    })
    
   
    
    frames.list <- list.files(working.dir)
    frames.list <- frames.list[str_detect(frames.list, "_frames")]
    
    emotions <- data.frame()
    
    
    
    withProgress(message = 'Recognizing emotions', value = 0, {
      n <- length(frames.list)
      for(i in frames.list){
        print(str_c("video ", which(frames.list == i), " is processing"))
        emotions <- plyr::rbind.fill(emotions, extract.from.frames(str_c(working.dir, i)))
        write_csv(emotions, str_c(working.dir, "emotions.csv"))
        incProgress(1/n, detail = str_c("processing video ", i))
      }
          })
  })
}
  
