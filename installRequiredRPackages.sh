#!/bin/bash
#Install any packages required by an R file that aren't already installed

if [ $# -ne 1 ]; then
    echo $0: usage: installAllRPackages.bash file
    exit 1
fi

file=$1

tempfile() {
    tempprefix=$(basename "$0")
    mktemp /tmp/${tempprefix}.XXXXXX
}

TMP1=$(tempfile)
TMP2=$(tempfile)
TMP3=$(tempfile)

trap 'rm -f $TMP1 $TMP2 $TMP3' EXIT

grep library $file >> $TMP1
grep require $file >> $TMP1
awk -F "[()]" '{ for (i=2; i<NF; i+=2) print $i }' $TMP1 >> $TMP2

while read p; do
  truncate -s 0 $TMP3
  sudo su - -c "R -q -e \"is.element('$p', installed.packages()[,1])\"" >> $TMP3 
  if grep -Fxq "[1] TRUE" $TMP3
  then
    echo "$p package already installed"
  else
    echo "installing $p package"
    sudo su - -c "R -q -e \"install.packages('$p', repos='http://cran.rstudio.com/')\""
  fi
done <$TMP2

### example commands to install packages from command line
# R -q -e "is.element('shinyBS', installed.packages()[,1])"
# R -q -e "install.packages('shinyBS', repos='http://cran.rstudio.com/')"
#

# R -q -e "packages=c("shinyBS","markdown","stats")
#   for (i in packages){
#     if(!is.element('shinyBS', installed.packages()[,1])){
#       install.packages('shinyBS', repos='http://cran.rstudio.com/')  
#       }
#   }
# "