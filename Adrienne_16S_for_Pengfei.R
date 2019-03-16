#library 
library(phyloseq)
library(ggplot2)
library(RColorBrewer)


setwd("~/A_Wrighton_lab/Wetland_project/16SrRNA_ana_Adrienne")

#mapping file
# change "-" to "_" in order to match sample names
#sed -e 's/-/_/g' filtered_reordered_may-sept_merged_mapping_table.txt >filtered_reordered_may-sept_merged_mapping_table2.txt
#
#strange duplicates ??????filtered_reordered_may-sept_merged_mapping_table2, check the log file. 

map_file<-read.delim("filtered_reordered_may-sept_merged_mapping_table.txt",header=T,row.names=1)
#724*9
#w-D1, soil, change to water
#duplicates samples after change names. 

#remove unwanted samples
map_file<-map_file[-c(629:634),] # remove sept-B, extraction blank, 6
map_file<-map_file[-c(303:337),] # remove MPP-June samples from the matrix, 35
#683*9

#ASV with tax info
# change "-" to "_" in order to match sample names
#sed -e 's/-/_/g' filtered_ge10_feature-table_w_tax.tsv >filtered_ge10_feature-table_w_tax2.tsv
otus<-read.delim("filtered_ge10_feature-table_w_tax.tsv",header=T,row.names=1, check.names=FALSE) #38934*726
# add check.names=FALSE parameter to avoid hypen to .; 


#remove unwanted samples from ASV table
otus<-otus[,-338] #W.S000036.OWC sample, 1
otus<-otus[,-c(629:634)] #duplicate samples due to re-seq and blank, 6
#[1] "July_M1.C1.D1.A" "May.T1.C1.D6.A"  "Sept.B1"         "Sept.B2"         "Sept.B3"         "Sept.B4"         "Sept.B5"
#
otus<-otus[,-c(303:337)] #otus, 38934*684

# phyloseq section
#
otumat<-as.matrix(otus[,-684]) #line 684, not 719 is the tax info
#38934, 683

OTU = otu_table(otumat, taxa_are_rows = TRUE) #covert to phyoseq object

taxa<-read.delim("filtered_ge10_trimmed_tax_tab.txt",header = T,row.names = 1) #tax_info, domain,phylum,class,order,family,genus,species
#38934
taxmat<-as.matrix(taxa)

all.equal(row.names(taxmat),row.names(otumat)) #check OTU number from tax info ==OTU number from ASV reads table

TAX = tax_table(taxmat) #covert to phyoseq object, OTU table

physeq<-phyloseq(OTU,TAX) #creat physeq list

all.equal(row.names(map_file),sample_names(physeq)) #check if samples in metadata file ==from ASV reads table
#683 samples from meta file, 683 samples from ASV reads tbl after MPP not removed
#meta file, May_OW1-air-water, name not match, with ASV, strange, May_OW1.air.water, M
#[1] "683 string mismatches"
#finally get here, but there some issues with the names


sampledata<-sample_data(map_file)
mgd<-merge_phyloseq(physeq,sampledata)



## Here are the colors I used for the wetlands:
library(RColorBrewer)
bluepal<-brewer.pal(6,"Blues")
orangepal<-brewer.pal(6,"Oranges")
greenpal1<-brewer.pal(6,"Greens")
greenpal2<-brewer.pal(6,"YlGn")

#create an interaction object 'seddep' using Sedtype and Depth
#There should be 6 depths * 4 types (Mud, Open water, Nelubmo, Typha) = 24 levels in factor

#This palette corresponds to those levels - levels may need to be ordered so they
#correspond to this where orange 1 == Mud.D1 for example:
pal<-c(orangepal[1],greenpal2[1],bluepal[1],greenpal1[1],orangepal[2],greenpal2[2],bluepal[2],greenpal1[2],orangepal[3],greenpal2[3],bluepal[3],greenpal1[3],orangepal[4],greenpal2[4],bluepal[4],greenpal1[4],orangepal[5],greenpal2[5],bluepal[5],greenpal1[5],orangepal[6],greenpal2[6],bluepal[6],greenpal1[6])

mgd.ord <- ordinate(mgd, "NMDS", "bray")

theme_set(theme_bw())
pmds=plot_ordination(mgd, mgd.ord, color="ecosite", shape="depth") 
pmds=pmds + geom_point(size=1)+scale_color_manual(values=pal) #water samples still inclued
pmds

#-W- water samples, 30

#extract data for ggplot2 of the NMDS dataset
library(vegan)
nmds_xy <-as.data.frame(scores(mgd.ord))

############################################################################14-March-2019
############################################################################Archaeal analysis

#
#1 filtering out data
setwd("~/A_Wrighton_lab/Wetland_project/16SrRNA_ana_Adrienne")

#clean map_file
map_file<-read.delim("filtered_reordered_may-sept_merged_mapping_table.txt",header=T,row.names=1)
map_file<-map_file[-c(629:634),] # remove sept-B, extraction blank, 6
map_file<-map_file[-c(303:337),] # remove MPP-June samples from the matrix, 35
#683*9
#map_file_withoutW<- map_file[grepl("-W-", row.names(map_file), ignore.case=TRUE),] #invert=TRUE
map_file <- map_file[grep("-W-", row.names(map_file), ignore.case=TRUE, invert=TRUE),]#653, 9 

#remove resequenced samples, see below for sample names
map_file <- map_file[grep("July_N1-C1-D5-B|July_OW2-C1-D1-C|July_OW3-C1-D1-A|June_N3-C1-D4-A|June_N3-C1-D4-B|May_N3-C1-D6-A|May_T1-C1-D6-A", row.names(map_file), ignore.case=TRUE, invert=TRUE), ] #646, 9
#646, 9, good

#remove low depth samples (cutoff, 6000 reads/sample), see sample names below
#[1] "Sept-N2-C1-D1-B"  "Aug-N3-C2-D6"     "Aug-M3-C2-D3"     "Aug-M3-C3-D2"     "Aug-N2-C3-D5"     "Aug-OW3-C1-D4-A"  "Aug-M3-C2-D5"     "Aug-M2-C3-D2"    
#[9] "Sept-OW2-C1-D1-B" "Sept-OW1-C1-D1-A"
map_file <- map_file[grep("Sept-N2-C1-D1-B|Aug-N3-C2-D6|Aug-M3-C2-D3|Aug-M3-C3-D2|Aug-N2-C3-D5|Aug-OW3-C1-D4-A|Aug-M3-C2-D5|Aug-M2-C3-D2|Sept-OW2-C1-D1-B|Sept-OW1-C1-D1-A", row.names(map_file), ignore.case=TRUE, invert=TRUE), ] 
#636,9, good (-10)

#remove samples with {"D9 and water"
map_file <- map_file[grep("D9|water", row.names(map_file), ignore.case=TRUE, invert=TRUE),] #630, 9

write.table(data.frame("Sample_ID"=rownames(map_file),map_file),"map_file_clean_Cores.txt", sep="\t", row.names=FALSE, quote = FALSE)
# samples, without water samples

#only for ploting
library(tidyr)
map_file$ecosite1=gsub("1|2|3","",map_file$ecosite)
map_file = unite(map_file, eco_dep, c(ecosite1, depth), remove=FALSE)
map_file = map_file[order(map_file$eco_dep), ,drop=FALSE] #M (D1-D6), N, OW, T is the order


## clean OTU file
#
otus<-read.delim("filtered_ge10_feature-table_w_tax.tsv",header=T,row.names=1, check.names=FALSE) #38934*726
#remove unwanted samples from ASV table
otus<-otus[,-338] #W.S000036.OWC sample, 1
otus<-otus[,-c(629:634)] #blank samples, 6
#[1] "Sept.B1"         "Sept.B2"         "Sept.B3"         "Sept.B4"         "Sept.B5"
#
otus<-otus[,-c(303:337)] #remove MPP samples, otus, 38934*684

#remove water samples
otus<- otus[, grep("-W-", colnames(otus), ignore.case=TRUE, invert=TRUE)]

#resequenced samples, the first round were removed due to low depth; 
#these are removed: 
#"July_N1-C1-D5-B|July_OW2-C1-D1-C | July_OW3-C1-D1-A | June_N3-C1-D4-A | June_N3-C1-D4-B | May_N3-C1-D6-A|May_T1-C1-D6-A"
#otus_check4<- otus[, grep("July_N1-C1-D5-B|July_OW2-C1-D1-C|July_OW3-C1-D1-A|June_N3-C1-D4-A|June_N3-C1-D4-B|May_N3-C1-D6-A|May_T1-C1-D6-A", colnames(otus), ignore.case=TRUE, invert=FALSE)]
#otus_check4["Total" ,] <- colSums(otus_check4)
#tail(otus_check4)

#these are kept: 
#otus_check5<- otus[, grep("July-N1-C1-D5-B|July-OW2-C1-D1-C|July-OW3-C1-D1-A|June-N3-C1-D4-A|June-N3-C1-D4-B|May-N3-C1-D6-A|May-T1-C1-D6-A", colnames(otus), ignore.case=TRUE, invert=FALSE)]
#otus_check5["Total" ,] <- colSums(otus_check5)
#tail(otus_check5)

otus<- otus[, grep("July_N1-C1-D5-B|July_OW2-C1-D1-C|July_OW3-C1-D1-A|June_N3-C1-D4-A|June_N3-C1-D4-B|May_N3-C1-D6-A|May_T1-C1-D6-A", colnames(otus), ignore.case=TRUE, invert=TRUE)]
#38934, 647

#check remove low depth samples?
otus_colsum <-otus[,-647]
otus_colsum ["Total" ,] <- colSums(otus_colsum)
otus_colsum_num = as.data.frame(t(otus_colsum["Total", ]))
otus_colsum_num = otus_colsum_num [order(otus_colsum_num$Total), ,drop=FALSE]
summary(otus_colsum_num)
otus_colsum_num_low = otus_colsum_num[otus_colsum_num$Total<=6000, ,drop = FALSE ]

#remove 
otus<- otus[, grep("Sept-N2-C1-D1-B|Aug-N3-C2-D6|Aug-M3-C2-D3|Aug-M3-C3-D2|Aug-N2-C3-D5|Aug-OW3-C1-D4-A|Aug-M3-C2-D5|Aug-M2-C3-D2|Sept-OW2-C1-D1-B|Sept-OW1-C1-D1-A", colnames(otus), ignore.case=TRUE, invert=TRUE)]
#38934, 637, good (-10)

#remove samples with {"D9 and water"
otus<- otus[, grep("water|D9", colnames(otus), ignore.case=TRUE, invert=TRUE)] #38934, 631

write.table(data.frame("OTU_ID"=rownames(otus), otus),"feature_table_w_tax_clean_Cores_ge10.txt", sep="\t", row.names=FALSE, quote = FALSE)
#caution, "- were changed to ."

## great!!!!!
## we got 630 core samples with enough reads 
##
# phyloseq section
#
otumat<-as.matrix(otus[,-ncol(otus)]) #line 631 is the tax info
str(otumat) #do not view it, it is too large
#num [1:38934, 1:636]

OTU = otu_table(otumat, taxa_are_rows = TRUE) #covert to phyoseq object

taxa<-read.delim("filtered_ge10_trimmed_tax_tab.txt",header = T,row.names = 1) #tax_info, domain,phylum,class,order,family,genus,species
#38934
taxmat<-as.matrix(taxa)

all.equal(row.names(taxmat),row.names(otumat)) #check OTU number from tax info ==OTU number from ASV reads table

TAX = tax_table(taxmat) #covert to phyoseq object, OTU table

physeq<-phyloseq(OTU,TAX) #creat physeq list

all.equal(row.names(map_file),sample_names(physeq)) #check if samples in metadata file ==from ASV reads table
#630 samples from meta file, 630 samples from ASV reads tbl after MPP not removed
#
sampledata<-sample_data(map_file)
mgd<-merge_phyloseq(physeq,sampledata)

## Here are the colors I used for the wetlands:
library(RColorBrewer)
bluepal<-brewer.pal(6,"Blues") #open water
orangepal<-brewer.pal(6,"Oranges") # mud
greenpal1<-brewer.pal(6,"Greens") # Typha
greenpal2<-brewer.pal(6,"YlGn") # Nelumbo

#create an interaction object 'seddep' using Sedtype and Depth
#There should be 6 depths * 4 types (Mud, Open water, Nelubmo, Typha) = 24 levels in factor

#This palette corresponds to those levels - levels may need to be ordered so they
#correspond to this where orange 1 == Mud.D1 for example:
#pal<-c(orangepal[1],greenpal2[1],bluepal[1],greenpal1[1],orangepal[2],greenpal2[2],bluepal[2],greenpal1[2],orangepal[3],greenpal2[3],bluepal[3],greenpal1[3],orangepal[4],greenpal2[4],bluepal[4],greenpal1[4],orangepal[5],greenpal2[5],bluepal[5],greenpal1[5],orangepal[6],greenpal2[6],bluepal[6],greenpal1[6])
pal<-c(orangepal[1], orangepal[2], orangepal[3], orangepal[4], orangepal[5], orangepal[6], greenpal1[1], greenpal1[2], greenpal1[3], greenpal1[4], greenpal1[5], greenpal1[6], bluepal[1], bluepal[2], bluepal[3], bluepal[4], bluepal[5], bluepal[6], greenpal2[1], greenpal2[2], greenpal2[3], greenpal2[4], greenpal2[5], greenpal2[6])

barplot(c(1:24), col=pal)

mgd.ord <- ordinate(mgd, "NMDS", "bray")

theme_set(theme_bw())
pmds=plot_ordination(mgd, mgd.ord, color="eco_dep", shape="depth") #
pmds=pmds + geom_point(size=1.5)+scale_color_manual(values=pal) #
pmds

#by month
p_month=pmds+facet_wrap(~month, 3)
p_month

#by_sites
p_site = pmds+facet_wrap(~ecosite1, 2)
p_site


#by_depth
p_dep = pmds+facet_wrap(~depth, 2)
p_dep

#by eco-depth
p_eco_dep = pmds+facet_wrap(~eco_dep, 2)
p_eco_dep

#??
library (ggrepel)
map_file$sample_name=row.names(map_file)
sampledata<-sample_data(map_file)
mgd<-merge_phyloseq(physeq,sampledata)

pmds=plot_ordination(mgd, mgd.ord, color="eco_dep", shape="depth", label = "sample_name") #
pmds=pmds + geom_point(size=1.5)+scale_color_manual(values=pal) #
pmds
p_eco_dep1 = pmds+facet_wrap(~eco_dep, 2) +
p_eco_dep1
#??

#-W- water samples, 30

#extract data for ggplot2 of the NMDS dataset
library(vegan)
nmds_xy <-as.data.frame(scores(mgd.ord))

##archaea dataset
Arc = taxa[taxa$Domain=="Archaea", ,drop=FALSE ]
feature_table_Arc_w_tax= merge(otus, Arc, by=0, all=FALSE)
row.names(feature_table_Arc_w_tax) = feature_table_Arc_w_tax[,1]
feature_table_Arc_w_tax = feature_table_Arc_w_tax[,-1]

write.table(data.frame("OTU_ID"=rownames(feature_table_Arc_w_tax), feature_table_Arc_w_tax),"feature_table_ArcWTax_clean_Cores_ge10.txt", sep="\t", row.names=FALSE, quote = FALSE)

#phyloseq section for Archaea
#
otumat<-as.matrix(feature_table_Arc_w_tax[,-c((ncol(feature_table_Arc_w_tax)-7):ncol(feature_table_Arc_w_tax))]) #line 631 is the tax info
str(otumat) #do not view it, it is too large
#num [1:3807, 1:630]

OTU = otu_table(otumat, taxa_are_rows = TRUE) #covert to phyoseq object

#taxa<-read.delim("filtered_ge10_trimmed_tax_tab.txt",header = T,row.names = 1) #tax_info, domain,phylum,class,order,family,genus,species
#38934
taxmat<-as.matrix(Arc)

all.equal(row.names(taxmat),row.names(otumat)) #check OTU number from tax info ==OTU number from ASV reads table

TAX = tax_table(taxmat) #covert to phyoseq object, OTU table

physeq<-phyloseq(OTU,TAX) #creat physeq list

#?
all.equal(row.names(map_file),sample_names(physeq)) #check if samples in metadata file ==from ASV reads table
#630 samples from meta file, 630 samples from ASV reads tbl after MPP not removed
#
sampledata<-sample_data(map_file)
mgd<-merge_phyloseq(physeq,sampledata)

## Here are the colors I used for the wetlands:
#create an interaction object 'seddep' using Sedtype and Depth
#There should be 6 depths * 4 types (Mud, Open water, Nelubmo, Typha) = 24 levels in factor
#This palette corresponds to those levels - levels may need to be ordered so they
#correspond to this where orange 1 == Mud.D1 for example:
#pal<-c(orangepal[1],greenpal2[1],bluepal[1],greenpal1[1],orangepal[2],greenpal2[2],bluepal[2],greenpal1[2],orangepal[3],greenpal2[3],bluepal[3],greenpal1[3],orangepal[4],greenpal2[4],bluepal[4],greenpal1[4],orangepal[5],greenpal2[5],bluepal[5],greenpal1[5],orangepal[6],greenpal2[6],bluepal[6],greenpal1[6])
pal<-c(orangepal[1], orangepal[2], orangepal[3], orangepal[4], orangepal[5], orangepal[6], greenpal1[1], greenpal1[2], greenpal1[3], greenpal1[4], greenpal1[5], greenpal1[6], bluepal[1], bluepal[2], bluepal[3], bluepal[4], bluepal[5], bluepal[6], greenpal2[1], greenpal2[2], greenpal2[3], greenpal2[4], greenpal2[5], greenpal2[6])

barplot(c(1:24), col=pal)

mgd.ord <- ordinate(mgd, "NMDS", "bray")

theme_set(theme_bw())
pmds=plot_ordination(mgd, mgd.ord, color="eco_dep", shape="depth") #
pmds=pmds + geom_point(size=1.5)+scale_color_manual(values=pal) #
pmds

#by month
p_month=pmds+facet_wrap(~month, 3)
p_month

#by_sites
p_site = pmds+facet_wrap(~ecosite1, 2)
p_site


#by_depth
p_dep = pmds+facet_wrap(~depth, 2)
p_dep

#by eco-depth
p_eco_dep = pmds+facet_wrap(~eco_dep, 2)
p_eco_dep

#color by month, archaea
theme_set(theme_bw())
pmds=plot_ordination(mgd, mgd.ord, color="month",shape = "depth") #
pmds=pmds + geom_point(size=2) +scale_color_manual(values = wes.palette(n=5, name="GrandBudapest")) #
pmds

p_month=pmds+facet_wrap(~month, 5)
p_month

#plot by taxa, class

pmds=plot_ordination(mgd, mgd.ord, type="taxa", color="Class") #
pmds=pmds + geom_point(size=1.5)#+scale_color_manual(values=pal) #
pmds

###August
#



##bar plot to check community profile and compositions
#https://joey711.github.io/phyloseq/plot_bar-examples.html

Euryarchaeota = subset_taxa(mgd, Phylum == "Euryarchaeota")
plot_bar(mgd, fill="Phylum", x="eco_dep")
#bad resolution