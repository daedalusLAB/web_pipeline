args <- commandArgs(trailingOnly = TRUE)

# Asignar argumentos a variables, con valores predeterminados o basados en los argumentos recibidos
# Asegúrate de que cada condición se evalúa como esperas
input.folder <- if(length(args) >= 1) args[1] else stop("No input folder provided")
output.path <- if(length(args) >= 2) args[2] else "path/to/output"
config.path <- if(length(args) >= 3) args[3] else NULL
output.file <- if(length(args) >= 4) args[4] else NULL
no_save <- if(length(args) >= 5) as.logical(args[5]) else FALSE

# Asegurarse de que el script de dfMaker está accesible, ya sea cargándolo directamente o asegurando que está en el path
load("/home/agora/functions/dfMaker.rda")


# Llamar a dfMaker con los argumentos procesados
dfMaker(input.folder = input.folder, output.path = output.path)
