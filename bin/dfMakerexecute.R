
functions= "/home/agora/functions/"

load(paste0(functions,"dfMaker.rda"))
load(paste0(functions,"clipCleaner.rda"))
load(paste0(functions,"xyCorrector.rda"))
load(paste0(functions,"cramerOpenPose.rda"))



args <- commandArgs(trailingOnly = TRUE)


args[1]->inputJSON
args[2]->rawFolder
args[3]->outPutFolder


  data<-dfMaker(input.folders = inputJSON,
                extra.var = FALSE,
                save.csv = T, output.folder =  rawFolder,
                return.empty = F,
                save.parquet = F,
                type.point = "full"
                )
                
  

#data<-clipCleaner(data = data,read.path = F,extract.goodCLips = F)


xyCorrector(df = data,df.full = T,set.NAs = T,fixed.point.x = 1,fixed.point.y = 1,reverse.y = T)->data

outPut<-cramerOpenPose(data = data,v.i = 5,orthonormal = T, save.video.csv = T,
                  output.folder = outPutFolder, save.parquet = T )

