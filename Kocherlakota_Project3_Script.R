#Venkata Satya Nagendra Sai Krishna Mohan Kocherlakota 10/07/2023 ALY6000: -Project-3
cat("\014") # clears console
rm(list = ls()) # clears global environment
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # clears plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) # clears packages
options(scipen = 100) # disables scientific notion for entire R session
setwd("C:/Users/kvsns/OneDrive/Documents/Rprojects/Intro to Analytics/Week-2")
#1
books <- read_csv("books.csv")
#Cleaning the data set
#1
clean_names(books) #Cleaning the data frame using janitor package
books
#2
books$firstPublishDate = mdy(books$firstPublishDate) #Converting str to date type using lubridate package.
books
#3
books$year <-year(books$firstPublishDate) #Creating a new column in data frame using year function.
books
#4
books <- books %>% filter(between(year, 1990, 2020)) #Filtering data from data frame.
books
#5
books = subset(books, select = -c(publishDate, edition, characters, price, genres, setting, isbn)) #Removing columns using data frame.
books
#6
books <- books %>% filter(pages < 1200) #Filtering pages less than 1200 pages in data frame.
books
#Data Analysis
#1
glimpse(books) #Short view of data frame.
#2
summary(books[c('rating', 'pages', 'numRatings', 'bbeScore', 'year')]) #Summaries the info of the data frame containing statistical date.
summary(books) #Summary of complete data frame.
#3
ggplot(books, aes(x = rating)) +
  geom_histogram(binwidth = 0.25, fill = "red") +
  labs(x = "Rating", y = "Number of Books") +
  ggtitle("Histogram of Books Ratings") #Histogram of Books Ratings.
#4
ggplot(books, aes(x = pages)) + ggtitle("Box Plot of Page Counts") +
  geom_boxplot(fill = "magenta") +
  theme_economist() #Bar plot of pages using themes
#5
book_publishers <- books %>% group_by(publisher = books$publisher) %>% 
  summarise(total_books = n()) %>% arrange(desc(total_books)) %>% 
  mutate(publisher = factor(publisher, levels = publisher)) %>%
  drop_na(publisher) %>%
  filter(total_books > 250) %>% mutate(cum_count= cumsum(total_books)) %>% 
  mutate(rel_freq = total_books/sum(total_books)) %>% mutate(cum_freq = cumsum(rel_freq))
book_publishers #Creating publisher data and performing multiple operations.
#6
Rightscale <- 100 / max(book_publishers$total_books)

ogive <- ggplot(book_publishers,aes(x=publisher))+
  geom_col(aes(y=total_books),fill="cyan")+
  geom_point(aes(y=cum_count))+
  geom_path(aes(y=cum_count),group=1)+
  scale_y_continuous(sec.axis = sec_axis(~.*Rightscale))+
  labs(title = "Pareto and Ogive of Publisher Book Counts",y="Number of Books",x="Publisher") + theme_clean()
ogive + easy_rotate_x_labels(angle = 45, side = c("right"), teach = FALSE)
#7
ggplot(books, aes(x = pages, y = rating, color = year)) +
  geom_point() +
  labs(x = "Pages", y = "Ratings") +
  ggtitle("Scatter Plot of Pages vs. Ratings") + theme_tufte() # Creation of sactter plot of data frame books and coloring
#8
by_year <- books %>% group_by(year) %>% 
  summarise(total_books = n(), avg_rating = mean(rating, na.rm = TRUE))
by_year #Summarise data by year of data frame books.
#9
plot <- ggplot(by_year, aes(x = year, y = total_books, color = avg_rating)) +
  geom_line() + 
  geom_point(size = 4) +
  ggtitle("Total Number of Books Rated Per Year.") +
  theme_excel_new()
plot
#10 & #11
avg_rating <- round(sum(books$rating)/ length(books$rating), digits = 2)
avg_rating
varience <- round(sum((books$rating - avg_rating) ^ 2)/length(books$rating), digits = 4)
varience
sd <- round(sqrt(varience), digits = 4)
sd
built <- tibble(avg_rating, varience, sd)
built
#12
# Set the seed for reproducibility
set.seed(123)

# Create three samples of size 100 from the 'rating' column
sample_size <- 100

sample1 <- sample(books$rating, size = sample_size)
sample2 <- sample(books$rating, size = sample_size)
sample3 <- sample(books$rating, size = sample_size)

# Compute sample statistics
sample_mean1 <- mean(sample1)
sample_variance1 <- var(sample1)
sample_sd1 <- sd(sample1)

sample_mean2 <- mean(sample2)
sample_variance2 <- var(sample2)
sample_sd2 <- sd(sample2)

sample_mean3 <- mean(sample3)
sample_variance3 <- var(sample3)
sample_sd3 <- sd(sample3)

sample_data1 <- tibble(sample_mean1, sample_variance1, sample_sd1)
sample_data2 <- tibble(sample_mean2, sample_variance2, sample_sd2)
sample_data3 <- tibble(sample_mean3, sample_variance3, sample_sd3)
sample_data1
sample_data2
sample_data3
#13
bitcoin <- read_csv("Bitcoin.csv")
bitcoin

bitcoin <- clean_names(bitcoin)
bitcoin

bitcoin$date = dmy(bitcoin$date)
bitcoin

bitcoin$year <- year(bitcoin$date)
bitcoin

bitcoin_year <- bitcoin %>% group_by(year) %>% 
  summarise(avg_rating = mean(close, na.rm = TRUE))
bitcoin_year

ggplot(bitcoin_year, aes(x = year, y = avg_rating, color = year)) +
  geom_line() +
  geom_point(size = 2) +
  labs(x = "Years", y = "Ratings") +
  ggtitle("Scatter Plot of Years vs. Ratings of Bitcoin") + theme_clean()