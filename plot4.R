## This script creates a png file, "plot4.png", in the current working directory
## containing 4 separate graphs comparing Global Active Power measurements
## over a 2-day time period. The 2-day period between February 1, 2007 and
## February 2, 2007 are subsetted from the full source dataset. 

# Load the library needed to support line graphs for multiple variables.

library(reshape2)

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

# Reshape data frame so variables to plot are in a single column and each 
# row stores a single value.

hpcMelt <- melt(hpc2, id=c("dt", "Global_active_power"), measure.vars = 
                        c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Open PNG device; create 'plot4.png' in the current working directory

png(file = "plot4.png")

        # Set viewer to display 4 charts in a 2 x 2 arrangement.

        par(mfrow = c(2,2))
        
        # Create plot 1: Global Active Power measurements over 2-day period.
        
        with(hpc2, plot(hpc2$dt, hpc2$Global_active_power, type = "n", 
             xlab = "", ylab = "Global Active Power"))
        lines(hpc2$dt, hpc2$Global_active_power)
        
        ## Create plot 2: Voltage measurements over 2-day period.
        
        with(hpc2, plot(hpc2$dt, hpc2$Voltage, type = "n", 
             xlab = "datetime", ylab = "Voltage"))
        lines(hpc2$dt, hpc2$Voltage) 
        
        # Create plot 3: Global Active Power meaurements for 3 sub-metering
        # stations over 2-day period.
        
        with(hpcMelt, plot(hpcMelt$dt, hpcMelt$value, type = "n", xlab = "", 
                           ylab = "Energy sub metering"))
        lines(hpcMelt$dt[hpcMelt$variable =="Sub_metering_1"], 
              hpcMelt$value[hpcMelt$variable == "Sub_metering_1"])
        lines(hpcMelt$dt[hpcMelt$variable =="Sub_metering_2"], 
              hpcMelt$value[hpcMelt$variable == "Sub_metering_2"], col = "red")
        lines(hpcMelt$dt[hpcMelt$variable =="Sub_metering_3"], 
              hpcMelt$value[hpcMelt$variable == "Sub_metering_3"], col = "blue") 
        legend("topright", col = c("black", "red", "blue"), 
              legend = c("Sub_metering_1", "Sub_metering_2",  "Sub_metering_3"),
              lwd = 1)
        
        # Create plot 4: Global Reactive Power measurements over 2-day period.
        
        with(hpc2, plot(hpc2$dt, hpc2$Global_reactive_power, type = "n", 
             xlab = "datetime", ylab = "Global_reactive_power"))
        lines(hpc2$dt, hpc2$Global_reactive_power)  
       
# close PNG device.
        
dev.off() 
  