install.packages('stringr') # to install the library. You can delete it after first firing
librry(stringr) # is needed for splitting strings (str_split function)
setwd('Documents//Learning//R//CSS SVG Compliance')

f <- readLines('hex2.svg') # reading SVG by lines. The result is an array

style_open <- grep('style type', f) # where style tag begins
style_close <- grep('/style', f) # where style tag ends

# Parsing colors
colors <- array(dim = (style_close-1) - style_open)
for ( i in (style_open+1) : (style_close-1) ) {
  num <- i - style_open  # index for colors array (start with 1, not zero)
  
  color <- gsub('.*fill:', '', f[i]) # replace stuff with emty string. '.*' means delete every simbol until you meet 'fill'
  color <- gsub(';}', '', color) # replace the rest
  colors[num] <- color # adding color to array
}

# Pasting colors to children
for ( i in (style_close+1) : (style_close+length(colors)) ) { # from style tags closes until children end
   color_num <- i - style_close # index for colors array
   
   split_pos <- str_locate(f[i], ' points')[[1]] # assuming we want to paste colors before points. [[1]] means we take only start position (function result is 2 numbers: start & end)
   begin <- substr(f[i], 1, split_pos) # the substring to paste before a color
   end   <- substr(f[i], split_pos + 1, nchar(f[i])) # the substring to pase after a color. nchar returns number of chracters
   color <- str_c('fill = "', colors[color_num], '" ')
   
   f[i] <- str_c(begin, color, end)
}

writeLines(f, 'hex2_colors.svg')
