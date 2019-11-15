## ------------------------------------------------------------------------
install.packages("tidyverse", repos = "http://cran.us.r-project.org")
library("tidyverse")

survey <- read_csv("https://raw.githubusercontent.com/introdsci/MusicSurvey/master/music-survey.csv")
preferences <- read_csv("https://raw.githubusercontent.com/introdsci/MusicSurvey/master/preferences-survey.csv")


## ------------------------------------------------------------------------
colnames(survey)[colnames(survey) == "First, we are going to create a pseudonym for you to keep this survey anonymous (more or less). Which pseudonym generator would you prefer?"] <- "generator_name"



## ------------------------------------------------------------------------
parse_datetime


## ------------------------------------------------------------------------
colnames(survey)


## ------------------------------------------------------------------------
colnames(survey)[colnames(survey) == "Timestamp"] <- "Time_Submitted"
colnames(survey)[colnames(survey) == "generator_name"] <- "pseudonym_generator"
colnames(survey)[colnames(survey) == "What is your pseudonym?"] <- "pseudonym"
colnames(survey)[colnames(survey) == "Sex"] <- "sex"
colnames(survey)[colnames(survey) == "Major"] <- "academic_major"
colnames(survey)[colnames(survey) == "Academic Year"] <- "academic_level"
colnames(survey)[colnames(survey) == "Year you were born (YYYY)"] <- "year_born"
colnames(survey)[colnames(survey) == "Which musical instruments/talents do you play? (Select all that apply)"] <- "instrument_list"
colnames(survey)[colnames(survey) == "Artist"] <- "favorite_song_artist"
colnames(survey)[colnames(survey) == "Song"] <- "favorite_song"
colnames(survey)[colnames(survey) == "Link to song (on Youtube or Vimeo)"] <- "favorite_song_link"
colnames(preferences)[colnames(preferences) == "What was your pseudonym?"] <- "pseudonym"


## ------------------------------------------------------------------------
library(dplyr)
library(tidyr)


## ------------------------------------------------------------------------
person <- tibble(pseudonym = survey$pseudonym, pseudonym_generator = survey$pseudonym_generator, sex = survey$sex, academic_major = survey$academic_major, academic_level = survey$academic_level, year_born = survey$year_born, Time_Submitted = survey$Time_Submitted)

favorite_song <- tibble(favorite_song_artist = survey$favorite_song_artist, favorite_song = survey$favorite_song, favorite_song_link = survey$favorite_song_link, pseudonym = survey$pseudonym)


## ------------------------------------------------------------------------
survey$Time_Submitted <- as.POSIXlt(parse_datetime(survey$Time_Submitted, format = "%m/%d/%y %H:%M"))


## ------------------------------------------------------------------------
preferences <- gather(preferences, "artist_song", "ratings", 3:45)
ratings <- tibble(pseudonym = preferences$pseudonym, artist_song = preferences$artist_song, ratings = preferences$ratings)


## ------------------------------------------------------------------------
ratings$artist_song <- str_replace_all(ratings$artist_song, pattern = "\t", replacement = " ")
favorite_rating <- ratings %>% 
  left_join(favorite_song, by="pseudonym") %>%
  filter(artist_song==paste(favorite_song_artist,favorite_song)) %>%
  select(pseudonym,artist_song, ratings)
print(favorite_rating)

