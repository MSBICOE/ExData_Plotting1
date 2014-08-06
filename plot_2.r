# read first few of rows to get the column class to optimizing memory for the large file reading 

hd <-read.table("household_power_consumption.txt",sep=";",as.is=T,header=T,nrow=10,skip=0)
myclasses <-sapply(hd, class) 	# get the column classes

colname <-colnames(hd)   		# get the column names

firstdate <- paste(hd[1,1],hd[1,2])  # figure out the first date time

# calculate how many rows to skip while importing data to save memory and speed up the process. we only need to import date starts from "01/02/2007 00:00:00"
rskip <-as.numeric(difftime(strptime("01/02/2007 00:00:00","%d/%m/%Y %H:%M:%S"), strptime(firstdate,"%d/%m/%Y %H:%M:%S"),units="mins")) + 1

# calculate how many rows to import while importing data to save memory and speed up the process. we only need to import date ends before "03/02/2007 00:00:00"
rownum <- as.numeric(difftime(strptime("03/02/2007 00:00:00","%d/%m/%Y %H:%M:%S"), strptime("01/02/2007 00:00:00","%d/%m/%Y %H:%M:%S"),units="mins"))

# import data only from the dates 2007-02-01 and 2007-02-02.
mydata <- read.table("household_power_consumption.txt",sep=";",as.is=T,header=F,nrow=rownum,skip=rskip, colClasses = myclasses)

# give the column proper header names
colnames(mydata) <- colname

# Add a proper date column 
mydata$mydate <- as.POSIXct(strptime(paste(mydata$Date,mydata$Time),"%d/%m/%Y %H:%M:%S"))

# save the graph to png file
png("plot_2.png",width = 480, height = 480)

with(mydata, plot(Global_active_power ~ mydate,type="l",xlab="", ylab="Global Active Power (Killowatts)",cex.axis=0.7,cex.lab=0.7))

# turn the device off
dev.off()

 
