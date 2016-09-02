for (nextMarkdown in list.files("./appTextContent/", pattern = "\\.md$")){
  nextMarkdown=file.path(".","appTextContent",nextMarkdown)
  rmarkdown::render(nextMarkdown)  
} 