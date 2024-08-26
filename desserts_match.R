library(tidyverse)
library(here)
library(dplyr)

our_fav_desserts <- read_csv(here("favorite_desserts.csv"))


library(rvest)  # used to scrape website content

# Check if that data folder exists and creates it if not
dir.create("data", showWarnings = FALSE)

# Read the webpage code
webpage <- read_html("https://www.eatthis.com/iconic-desserts-united-states/")

# Extract the desserts listing
dessert_elements<- html_elements(webpage, "h2")
dessert_listing <- dessert_elements %>% 
  html_text2() %>%             # extracting the text associated with this type of element of the webpage
  as_tibble() %>%              # make it a data frame
  rename(dessert = value) %>%  # better name for the column
  head(.,-3) %>%               # 3 last ones were not desserts 
  rowid_to_column("rank") %>%  # adding a column using the row number as a proxy for the rank
  write_csv("data/iconic_desserts.csv") # save it as csv


dessert_listing <- dessert_listing |>
  mutate(dessert = tolower(dessert))

our_fav_desserts <- our_fav_desserts |>
  mutate(dessert = Favorite_dessert) |>
  mutate(dessert = tolower(dessert))


# match(dessert_listing$dessert, our_fav_desserts$dessert) # feels clunky

dessert_match <- inner_join(our_fav_desserts, dessert_listing, by = "dessert") 







