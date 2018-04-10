fluidPage(
  
  titlePanel("Emotion Recognition from Video"),
  
  sidebarLayout(
    
    sidebarPanel(h3("Setting things up"),
                 textInput("END.POINT", "End point",""),
                 textInput("KEY", "Key", ""),
                 textInput("FFMPEG", "Path to ffmpeg", "ex. C:/Users/yourname/ffmpeg/bin/ffmpeg.exe"),
                 textInput("WD", "Folder with videos", "ex. C:/Users/yourname/Desktop/test"),
                 sliderInput("FPS", "Frames per second", 0.1, 5, 0.2, 0.1, round = -1, ticks = F),
                 actionButton("GO", "Go!")),
    
    mainPanel(
      h3("Prerequisites"),
      "First, you need to go to Microsoft Azure, click on Get API Key for Face API.",
      a("Log in here and copy Endpoint and Key", href = "https://azure.microsoft.com/en-gb/try/cognitive-services/", target = "_blank"), 
      br(),
      "Second, download", a("ffmpeg.",  href = "https://ffmpeg.zeranoe.com/builds/", target = "_blank"),  
      "You can change Architecture depending on your computer but don't change anything else.",
      br(),
      "Third, specify the working folder with videos.",
      br(),
      "Note: Windows paths contain backslashes instead of slashes. Please change it. If your videos are not in eigher .mp4 or .avi contact the developer",
      h3("Background info"),
      p("Microsoft Azure gives an access to a set of machine learning tools including emotion recognition system. 
        It is used via application program interface (API) which is just a set of routines, 
        protocols, and tools for building software applications."),
      p("Microsoft Azure recognizes emotions from photos. 
        Therefore, the first step is splitting videos into frames. Ffmpeg is a free tool to do it. 
        You need to specify the number of frames per second. 
        When it is set to 2, you get 2 frames from each second of a video. 
        When it is set to 0.2, you’ll get 1 frame per 5 seconds. Choose wisely."),
      p("You have 30,000 free requests per month. This is the number of frames that you can process. 
        Don't worry if you need more (but usually in research you need much less), 
        it is not expensive. You can check the details", 
        a("here.", href = "https://azure.microsoft.com/en-gb/pricing/details/cognitive-services/face-api/", target = "_blank")),
      p("My final note is be patient. I mean it. Sometimes it's really annoying.")
      
    )
  )
)