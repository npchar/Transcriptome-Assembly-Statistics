#!/usr/bin/env Rscript
library("optparse")
 
option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="dataset file name", metavar="character"),
	make_option(c("-o", "--out"), type="character", default=NULL, 
              help="output file name", metavar="character")
); 
 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if (is.null(opt$file) | is.null(opt$out)){
  print_help(opt_parser)
  stop("Two arguments must be supplied (input and output file name).n", call.=FALSE)
}

## program...
df = read.table(opt$file, header=TRUE)
num_vars = which(sapply(df, class)=="numeric")
df_out = df[ ,num_vars]
write.table(df_out, file=opt$out, row.names=FALSE)


data = read.table(opt$file, h=F)
names(data)=c("Seq", "length")

sortedLength = rev(sort(data$length))
NumberOfContigs = length(data$length)
medianAssembly = median(data$length)
meanAssembly = round(mean(data$length))
shortest = min(data$length)
longest = max(data$length)
totalsize = sum(data$length)
Sup500 = length(data[data$length>500,1])
Sup1k = length(data[data$length>1000,1])
Sup10k = length(data[data$length>10000,1])
N50 = sortedLength[min(which(cumsum(sortedLength)>sum(sortedLength)/2))] 
res = c(NumberOfContigs, totalsize, shortest, longest, Sup500, Sup1k, Sup10k, meanAssembly, medianAssembly, N50)
RowNames = c("Number of contigs", "total size of contigs", "Shortest contigs", "Longest contigs", "Number of contigs > 500", "Number of contigs > 1k", "Number of contigs > 10k", "mean contig size", "median contig size","N50 contig length")
write.table(cbind(RowNames, res), file = opt$out, quote=F, row.names=F, sep="\t")
