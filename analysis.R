library(dplyr)
library(lintr)
library(ggplot2)
library(tidyr)
library(stringr)
library(lubridate)
library(plotly)

original_df <- read.csv("data_11_2019.csv", stringsAsFactors = FALSE)
all_time_start <- c("2017-01-01")
all_time_end <- c("2100-01-01")
#original_df$Date <- format(as.Date(original_df$Date,"%m/%d/%Y"))


get_deposits <- function(df) {
  result <- df %>%
    filter(Transaction == "CREDIT")
  return(result)
}
test_deposits <- get_deposits(original_df)


get_spend <- function(df) {
  result <- df %>%
    filter(Transaction == "DEBIT")
  return(result)
}
test_get_spend <- get_spend(original_df)


add_months <- function(df) {
  result <- df %>%
    mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
    mutate(month = month(Date)) %>%
    mutate(year = year(Date))
  return(result)
}
test_add_months <- add_months(original_df)


get_monthly_df <- function(df, beginDate, endDate) {
  df <- add_months(df)
  result <- df %>%
    group_by(year, month) %>%
    summarize(total = sum(Amount))
  result$newdate <- as.Date(paste(result$year, result$month, "01", sep="-"), "%Y-%m-%d")
  result <- result %>%
    filter(newdate >= beginDate & newdate <= endDate)
  return(result)
}


get_filtered_df <- function(df, term1, term2, term3, term4, term5) {
  if(missing(term1) | term1 == "") {
    term1 = "NULL"
  }
  if(missing(term2) | term2 == "") {
    term2 = "NULL"
  }
  if(missing(term3) | term3 == "") {
    term3 = "NULL"
  }
  if(missing(term4) | term4 == "") {
    term4 = "NULL"
  }
  if(missing(term5) | term5 == "") {
    term5 = "NULL"
  }
    
  result <- df %>%
    filter(grepl(term1, Memo) | grepl(term2, Memo) | grepl(term3, Memo) | grepl(term4, Memo) | grepl(term5, Memo))
  return(result)
}
#test_get_filtered <- get_filtered_df(original_df, "QFC", "COSTCO WHSE")


create_grocery_barplot <- function(df, startDate, endDate, term1, term2, term3, term4, term5) {
  filtered_df <- get_filtered_df(df, term1, term2, term3, term4, term5)
  monthly_df <- get_monthly_df(filtered_df, startDate, endDate)
  p <- plot_ly() %>%
    add_bars(
      x = monthly_df$newdate,
      y = monthly_df$total * -1,
      base = 0,
      marker = list(color = "red"),
      name = "placeholder"
    )
  return(p)
}
#grocery_barplot <- create_grocery_barplot(original_df, all_time_start, all_time_end, "QFC", "COSTCO WHSE")
#grocery_barplot


create_grocery_lineplot <- function(df, startDate, endDate, term1, term2, term3, term4, term5) {
  filtered_df <- get_filtered_df(df, term1, term2, term3, term4, term5)
  monthly_df <- get_monthly_df(filtered_df, startDate, endDate)
  p <- plot_ly() %>%
    add_trace(
      x = monthly_df$newdate,
      y = cumsum(monthly_df$total) * -1,
      marker = list(color = "red"),
      name = "placeholder",
      mode = "lines+markers",
      type = "scatter"
    )
  return(p)
}
#grocery_lineplot <- create_grocery_lineplot(original_df, all_time_start, all_time_end, "QFC", "COSTCO WHSE")
#grocery_lineplot


# Vertical stacked barchart for deposits and spending
create_full_barplot <- function(deposits, spending) {
  df1 <- deposits
  df2 <- spending
  p <- plot_ly() %>%
    add_bars(
      x = df1$newdate,
      y = df1$total,
      base = 0,
      marker = list(color = "green"),
      name = "Deposits"
    ) %>%
    add_bars(
      x = df2$newdate,
      y = df2$total,
      base = 0,
      marker = list(color = "red"),
      name = "Spending"
    ) %>%
    layout(barmode = "stack")
  return(p)
}
monthly_total <- get_monthly_df(original_df, "2019-08-01", "2019-10-15")
monthly_spend <- get_monthly_df(get_spend(original_df), all_time_start, all_time_end)
monthly_deposits <- get_monthly_df(get_deposits(original_df), all_time_start, all_time_end)
test_full_barplot <- create_full_barplot(monthly_deposits, monthly_spend)
test_full_barplot


create_cumsum_lineplot <- function(df) {
  df$Date <- format(as.Date(original_df$Date,"%m/%d/%Y"))
  expected_bal <- sum(df$Amount)
  p <- plot_ly() %>%
    add_trace(
      x = df$Date,
      y = cumsum(df$Amount),
      text = paste(df$Amount, df$Name),
      mode = "lines+markers",
      type = "scatter"
    )
  return(p)
}

test_lineplot <- create_cumsum_lineplot(original_df)
test_lineplot