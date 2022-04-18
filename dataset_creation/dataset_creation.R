
# library 
library(decryptr)
library(png)
library(filesstrings)
library(stringr)

# captcha path
url = 'https://www.jpj.gov.my/web/main-site/semakan-saman?p_p_id=summon_WAR_JPJDXPPluginportlet&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_cacheability=cacheLevelPage&_summon_WAR_JPJDXPPluginportlet_cmd=captcha&force=521'
if(!dir.exists('data')){dir.create('data')}

root = 'C:\\\\Users\\\\hafizuddin\\\\Documents\\\\mining\\\\captcha_classifier\\\\dataset_creation\\\\data\\\\captcha\\\\'
# download captcha
for(i in 1:1000){
  captcha_path = download_captcha(url, path = "data\\captcha")
  file.rename(captcha_path,gsub(';charset=UTF-8','',captcha_path))
  captcha_path = gsub(';charset=UTF-8','',captcha_path)
  # display image
  img = readPNG(captcha_path)
  plot.new()
  rasterImage(img,0,0,1,1)
  # input captcha
  cat('Key in captcha or [q] to quit or [m] if unable to read:\n')
  code = readline()
  # condition
  #quit
  if(grepl('^q$',code,ignore.case = T)){
    file.remove(captcha_path)
    break
  }
  #unable to read
  else if(grepl('^m$',code,ignore.case = T)){
    file.move(captcha_path,'data\\bad_captcha')
    next
  }
  else if(!grepl('^[[:digit:]]{4}$',code)){
    cat('Wrong input\n')
    file.remove(captcha_path)
    next
  }
  # rename file
  new_file_name = gsub(root,'',captcha_path)
  new_file_name = paste0('data\\captcha\\',code,'_',new_file_name)
  file.rename(captcha_path,new_file_name)
  # clear plots
  if(i%%10==0){dev.off(dev.list()["RStudioGD"])}
}

# captcha dataset analysis
captcha_dataset = list.files('data/captcha')
digits = str_extract(captcha_dataset,'^[[:digit:]]{4}')
digit1 = str_sub(digits,start = 1, end = 1)
digit2 = str_sub(digits,start = 2, end = 2)
digit3 = str_sub(digits,start = 3, end = 3)
digit4 = str_sub(digits,start = 4, end = 4)
# get frequency
table(digit1)
table(digit2)
table(digit3)
table(digit4)

# balancing dataset
balanced_digits = vector()
for(i in 0:9){
  dig_regex = paste0('^[[:digit:]]{3}',i)
  dig = grep(dig_regex,digits,value = T)
  dig = dig[1:100]
  balanced_digits = append(balanced_digits,dig)
}
digit1 = str_sub(balanced_digits,start = 1, end = 1)
digit2 = str_sub(balanced_digits,start = 2, end = 2)
digit3 = str_sub(balanced_digits,start = 3, end = 3)
digit4 = str_sub(balanced_digits,start = 4, end = 4)
# get frequency
table(digit1)
table(digit2)
table(digit3)
table(digit4)

# rename bad captcha
bad = list.files('data/bad_captcha')
