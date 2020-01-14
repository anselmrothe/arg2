library(tidyverse)
library(readxl)
library(lubridate)


transcript <- read_excel("data/arg2 transcript.xlsx",
                         na = "na")[-1,][1:297,] %>%
  select(
    subject,
    card_no,
    rare,
    irrelevant,
    risky
  ) %>%
  transmute(
    subject = as.integer(subject),
    card_no = as.integer(card_no),
    condition = as.factor(rare),
    condition = fct_recode(condition,
                           skewed = "arms",
                           even = "none"),
    irrelevant = irrelevant == "true",
    risky = risky == "true"
  )

subjects <- read_excel("data/arg2 participants.xlsx") %>%
  select(
    subject,
    dob,
    date,
    condition,
    drop
  ) %>%
  mutate(
    subject = as.integer(subject),
    condition = as.factor(condition),
    dob = ymd(dob),
    date = ymd(date),
    age = as.numeric(date - dob) / 365.25,
    drop = as.logical(drop)
  ) %>%
  ## remove dropouts:
  filter(is.na(drop)) %>%
  select(-drop)

trans_sum <- transcript %>%
  group_by(subject, condition) %>%
  summarize(
    cards = max(card_no),
    irrelevant_n = sum(!is.na(irrelevant)),
    irrelevant = sum(irrelevant, na.rm = TRUE),
    risky_n = sum(!is.na(risky)),
    risky = sum(risky, na.rm = TRUE)
  ) %>%
  ungroup

d <- subjects %>%
  left_join(trans_sum,
            by = "subject") %>%
  mutate(condition = condition.x,
         condition.x = NULL,
         condition.y = NULL)


## add 1 to all for useful beta curves (HACK):
#d[,6:9] <- d[,6:9] + 1

ggplot(d,
       aes(x = age,
           y = irrelevant/irrelevant_n,
           size = irrelevant_n)) +
  geom_point() +
  geom_rug(size = 1, sides = "b")

ggplot(d,
       aes(x = age,
           y = risky/risky_n,
           size = risky_n)) +
  geom_point() +
  geom_rug(size = 1, sides = "b")


## assign manual age groups (HACK):
d <- d %>%
  mutate(agegroup = case_when(
    age < 5 ~ "3-5",
    age >= 5 & age < 6 ~ "5-6",
    age >= 6 & age < 7 ~ "6-7",
    age > 7 ~ "7-10"
  ))
