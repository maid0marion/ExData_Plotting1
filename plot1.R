## This script creates a histogram of the frequency of Global Active Power 
## over a 2-day period and stores the result in a "plot1.png" file in the 
## current working directory.  The 2-day period between February 1, 2007 and
## February 2, 2007 are subsetted from the full source dataset. 

# If not already present, create 'data' directory in current working directory
# to store the source dataset files.

if (!file.exists("data")) {
        dir.create("data")
}

# If dataset file not already downloaded, download compressed (.zip) file
# from internet and store in 'data' folder.

if (!file.exists("./data/exdata-data-household_power_consumption.zip")) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, 
                      destfile = "./data/exdata-data-household_power_consumption.zip",
                      method = "curl")
}

# If uncompressed version of dataset not present, uncompress the source dataset
# and store it in the 'data' folder.

if (!file.exists("./data/household_power_consumption.txt")) {
        unzip("./data/exdata-data-household_power_consumption.zip", 
              exdir = "./data")
}

# Load dataset into R.

hpc <- read.table("./data/household_power_consumption.txt", header = TRUE, sep=";", 
                  na.strings = "?")

# Convert 'Date' column to a 'Date' type.

hpc[,1] <- as.Date(hpc[,1], "%d/%m/%Y")

# Subset dataframe to measurements from the two-day period between Feb 1, 2007 
# and Feb 2, 2007.

hpc2 <- hpc[(hpc$Date <= "2007-2-2" & hpc$Date >="2007-2-1"),]

# Remove the full dataset to free memory.

rm(hpc)

# Open PNG device; create plot and send to a file named 'plot1.png' in the 
# current working directory.

png(file = "plot1.png") 
        with(hpc2, hist(hpc2$Global_active_power, col = "red", 
                   xlab = "Global Active Power (kilowatts)", 
                   ylab = "Frequency", main = "Global Active Power"))

# Close PNG device.
        
dev.off() 

