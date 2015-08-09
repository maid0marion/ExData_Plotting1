## This script creates a line graph of measurements of Global Active Power 
## values over a 2-day period between February 1, 2007 and February 2, 2007.  
## The code subsets the original dataset to the above date range and stores
## the result in a "plot2.png" file in the current working directory. 

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

# Create new datetime variable using the 'Date' and 'Time' columns.

dt <- paste(hpc[,1], hpc[,2])
dt <- strptime(dt, "%d/%m/%Y %H:%M:%S")
hpc <- cbind(dt, hpc)

# Convert 'Date' column to a 'Date' type and subset dataframe to measurements
# for the two-day period between Feb 1, 2007 and Feb 2, 2007.

hpc[,2] <- as.Date(hpc[,2], "%d/%m/%Y")
hpc2 <- hpc[(hpc$Date <= "2007-2-2" & hpc$Date >="2007-2-1"),]

# Remove the full dataset from the workspace to free memory.

rm(hpc)

# Open PNG device; create 'plot2.png' in the current working direcotry; close 
# PNG device.

png(file = "plot2.png")
        with(hpc2, plot(hpc2$dt, hpc2$Global_active_power, type = "n", 
                        xlab = "", ylab = "Global Active Power (kilowatts)"))
        lines(hpc2$dt, hpc2$Global_active_power)   
        dev.off() 
 