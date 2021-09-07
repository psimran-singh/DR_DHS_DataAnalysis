##Run the code to make the program
##Copy the file path into your clipboard
##Run programs without arguments
##It'll spit out a R-friendly file path

pathPrep <- function(path = "clipboard") {
  y <- if (path == "clipboard") {
    readClipboard()
  } else {
    cat("Please enter the path:\n\n")
    readline()
  }
  x <- chartr("\\", "/", y)
  writeClipboard(x)
  return(x)
}

pathPrep()
