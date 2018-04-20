#!/bin/bash

#Reports in an one-line output different statistics about Assembly

usage+="Usage: $0 <Fastafile> \n"
usage+="\n"
usage+="Description : reporting in an one-line differents statistics about Assembly. In the directory where the fastafile is, should be present :\n"
usage+="\t\ti)<Fastafile>.buscoSummary (from busco v2)\n"
usage+="\t\tii)<Fastafile>.buscoStrand (from getStrand.pl ) \n"
usage+="\t\tiii)<Fastafile>.DescriptionAssemblage (from DescriptionAssemblage.R)\n"
usage+="Option : \t -l use a list of <Fastafile> instead a single (list should contain a fastafile per line)\n"
usage+="         \t -o print results in a file <Fastafile>.SummaryStatistics\n"
usage+="         \t -H print the description of each colum with # as first charcter\n"
list="no"
header="no"
out="no"

while getopts ":lHo" opt; do
  case $opt in
    l)
     echo "Use list mode ! " >&2
     list="yes"
     ;;
    H)
     header="yes"
     ;;
   o)
     out="yes"
     ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      printf "%b" "$usage" >&2
      exit
      ;;
  esac
done

# retire les options de la liste des arguments
shift $((OPTIND-1))
# test de l'argument obligatoire <Trinity.fasta>
if [ "$#" -eq 0 ];
then
        printf "%b" "$usage"
        exit
fi


# Dealing with list or direct file :
args=("$@")
if [ "$list" = "yes" ]
then
	listDATA=($(cat ${args[0]}))
else
	listDATA=(${args[0]})
fi

DATA=""

for DATA in ${listDATA[@]}
do
   if [ -f ${DATA}.buscoSummary ] && [ -f ${DATA}.DescriptionAssemblage ]  && [ -f ${DATA}.buscoStrand ]
   then
	OUTFILE="${DATA}.SummaryStatistics"

	#Dealing with Buscov2 output :
	#-----------------------------
	Complete=$(cat ${DATA}.buscoSummary | grep "Complete BUSCOs" | awk '{print $1}')
	CompleteSC=$(cat ${DATA}.buscoSummary | grep "Complete and single-copy BUSCOs" | awk '{print $1}')
	CompleteD=$(cat ${DATA}.buscoSummary | grep "Complete and duplicated BUSCOs" | awk '{print $1}' )
	Fragrmented=$(cat ${DATA}.buscoSummary | grep "Fragmented BUSCOs" | awk '{print $1}')
	Missing=$(cat ${DATA}.buscoSummary | grep "Missing BUSCOs" | awk '{print $1}')
	Total=$(cat ${DATA}.buscoSummary | grep "Total BUSCO groups searched" | awk '{print $1}')

	#Dealing with DescritpionAssemblage.R output :
	#---------------------------------------------
	Ncontig=$(cat ${DATA}.DescriptionAssemblage | grep "Number of contigs" | head -n 1 | awk -F "\t" '{print $2}')
	Nbase=$(cat ${DATA}.DescriptionAssemblage | grep "total size of contigs" | awk -F "\t" '{print $2}')
	Shortest=$(cat ${DATA}.DescriptionAssemblage | grep "Shortest contigs" | awk -F "\t" '{print $2}')
	Longest=$(cat ${DATA}.DescriptionAssemblage | grep "Longest contigs" | awk -F "\t" '{print $2}')
	Nc500=$(cat ${DATA}.DescriptionAssemblage | grep "Number of contigs > 500" | awk -F "\t" '{print $2}')
	Nc1k=$(cat ${DATA}.DescriptionAssemblage | grep "Number of contigs > 1k" | awk -F "\t" '{print $2}')
	Nc10k=$(cat ${DATA}.DescriptionAssemblage | grep "Number of contigs > 10k" | awk -F "\t" '{print $2}')
	Mean=$(cat ${DATA}.DescriptionAssemblage | grep "mean contig size" | awk -F "\t" '{print $2}')
	Median=$(cat ${DATA}.DescriptionAssemblage | grep "median contig size" | awk -F "\t" '{print $2}')
	N50=$(cat ${DATA}.DescriptionAssemblage | grep "N50 contig length" | awk -F "\t" '{print $2}')

	#Dealing with  BuscoStrand :
	#---------------------------
	Strand=$(cat ${DATA}.buscoStrand | grep "Percentage of strand +" | awk -F ";" '{print $2}' | awk -F "\t" '{print $2}')

	HEADER="#Name\tNumberOfContigs\tTotalSizeOfContigs\tShortestContigs\tLongestContigs\tNcontigs>500b\tNcontigs>1kb\tNcontigs>10kb\tMeanContigSize\tMedianContigSize\tN50\t"
	HEADER+="CompleteBUSCO\tCompleteSC\tCompleteD\tFragmented\tMissing\tTotalBUSCO\tStrand\n"
	OUT="${DATA}\t${Ncontig}\t${Nbase}\t${Shortest}\t${Longest}\t${Nc500}\t${Nc1k}\t${Nc10k}\t${Mean}\t${Median}\t${N50}\t"
	OUT+="${Complete}\t${CompleteSC}\t${CompleteD}\t${Fragrmented}\t${Missing}\t${Total}\t"
	OUT+="${Strand}\n"

	if [ "$header" = "yes" ] ; then printf "%b" "$HEADER" ;fi
	if [ "$out" = "yes" ] ;then printf "%b" "$OUT" >${OUTFILE} ; else printf "%b" "$OUT" ; fi
  else
	printf "%b" "$usage"
	printf "%b" "additional files for \"$DATA\" describing statistics wasn't found !\n"
  fi
done
