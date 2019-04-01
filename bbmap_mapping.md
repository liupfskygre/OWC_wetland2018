##bbmap mapping rawreads to contigs

**mapping on megahit**
#M1C1D1 running
```
cd /home/projects/Wetlands/2018_sampling/test_assemblies/megahit_assemblies

cd /home/projects/Wetlands/2018_sampling/test_assemblies/megahit_assemblies/Aug_M1_C1_D1_megahit_k41_assembly

screen -S M1C1D1_megahit_bbmaping

bbmap.sh ref=Aug_M1_C1_D1_megahit_k41_assembly.contigs.fa in=/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D1_B_[OWC_Aug_M1_C1_D1_FD]/Raw_Data/12757.4.282994.GTCTCCTT-AAGGAGAC.fastq.gz xmtag=t nmtag=t ambiguous=random outm=Aug_M1_C1_D1_megahit_random.sam covstats=Aug_M1_C1_D1_megahit_random_random.stats threads=30
done

# use ctrl+a and d to detach, 
#screen -r to re-attach
#nmtag, edit distance (number of mismatch or number of edit base for full match)
```

#M1C1D5, running
```
screen -S M1C1D5_megahit_bbmaping

cd /home/projects/Wetlands/2018_sampling/test_assemblies/megahit_assemblies/Aug_M1_C1_D5_megahit_k41_assembly

bbmap.sh ref=Aug_M1_C1_D5_megahit_k41_assembly.contigs.fa in=/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D5_B_[OWC_Aug_M1_C1_D5_FD]/Raw_Data/12757.2.282924.GATAGCGA-TCGCTATC.fastq.gz xmtag=t nmtag=t ambiguous=random outm=Aug_M1_C1_D5_megahit_random.sam covstats=Aug_M1_C1_D5_megahit_random_random.stats threads=30

```
not running
**mapping on idba_60K contigs**
#M1C1D1
```
cd /home/projects/Wetlands/2018_sampling/test_assemblies/megahit_assemblies

cd /home/projects/Wetlands/2018_sampling/test_assemblies/megahit_assemblies/Aug_M1_C1_D1_megahit_k41_assembly

screen -S M1C1D1_idba60k_bbmaping

bbmap.sh ref=Aug_M1_C1_D1_megahit_k41_assembly.contigs.fa in=/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D1_B_[OWC_Aug_M1_C1_D1_FD]/Raw_Data/12757.4.282994.GTCTCCTT-AAGGAGAC.fastq.gz xmtag=t nmtag=t ambiguous=random outm=Aug_M1_C1_D1_megahit_random.sam covstats=Aug_M1_C1_D1_megahit_random_random.stats threads=30
done

# use ctrl+a and d to detach, 
#screen -r to re-attach
#nmtag, edit distance (number of mismatch or number of edit base for full match)
```

#M1C1D5
```
screen -S M1C1D5_megahit_bbmaping

cd /home/projects/Wetlands/2018_sampling/test_assemblies/megahit_assemblies/Aug_M1_C1_D5_megahit_k41_assembly

bbmap.sh ref=Aug_M1_C1_D5_megahit_k41_assembly.contigs.fa in=/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D5_B_[OWC_Aug_M1_C1_D5_FD]/Raw_Data/12757.2.282924.GATAGCGA-TCGCTATC.fastq.gz xmtag=t nmtag=t ambiguous=random outm=Aug_M1_C1_D5_megahit_random.sam covstats=Aug_M1_C1_D5_megahit_random_random.stats threads=30

```



*path*
```
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D1_B_[OWC_Aug_M1_C1_D1_FD]/Raw_Data/12757.4.282994.GTCTCCTT-AAGGAGAC.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D4_B_[OWC_Aug_M1_C1_D4_FD]/Raw_Data/12757.4.282994.AGTAGTCC-GGACTACT.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D5_B_[OWC_Aug_M1_C1_D5_FD]/Raw_Data/12757.2.282924.GATAGCGA-TCGCTATC.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M2_C1_D1_C_[OWC_Aug_M2_C1_D1_FD]/Raw_Data/12756.1.282774.GCTGGATT-AATCCAGC.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M2_C1_D5_C_[OWC_Aug_M2_C1_D5_FD]/Raw_Data/12757.2.282924.GTGGTGTT-AACACCAC.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D2_B_[OWC_Aug_M1_C1_D2_FD]/Raw_Data/12757.4.282994.ACGATGAC-GTCATCGT.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_M1_C1_D3_B_[OWC_Aug_M1_C1_D3_FD]/Raw_Data/12757.4.282994.TACGCCTT-AAGGCGTA.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_N3_C1_D1_A_[OWC_Aug_N3_C1_D1_FD]/Raw_Data/12757.4.282994.AGAGCCTT-AAGGCTCT.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_N3_C1_D5_A_[OWC_Aug_N3_C1_D5_FD]/Raw_Data/12756.1.282774.TCTCTTCC-GGAAGAGA.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_OW2_C1_D1_C_[OWC_Aug_OW2_C1_D_2_FD]/Raw_Data/12809.2.288043.TACCACAG-CTGTGGTA.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_OW2_C1_D5_C_[OWC_Aug_OW2_C1_D_FD]/Raw_Data/12757.2.282924.ATGGTTGC-GCAACCAT.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_T1_C1_D1_A_[OWC_Aug_T1_C1_D1_FD]/Raw_Data/12756.1.282774.GAGGACTT-AAGTCCTC.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_Aug_T1_C1_D5_A_[OWC_Aug_T1_C1_D5_FD]/Raw_Data/12756.1.282774.AGAATGCC-GGCATTCT.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_May_M1_C1_D1_A_[OWC_May_M1_C1_D1_FD]/Raw_Data/12756.1.282774.AGCAAGCA-TGCTTGCT.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_May_M1_C1_D3_A_[OWC_May_M1_C1_D3_FD]/Raw_Data/12809.2.288043.GTTACGCA-TGCGTAAC.fastq.gz
/ORG-Data/Wetlands_2018_JGI/From_genomes_to_methane_production__Targeting_critical_knowledge_gaps_in_wetland_soils__OWC_May_M1_C1_D6_A_[OWC_May_M1_C1_D6_FD]/Raw_Data/12756.1.282774.CGACCATT-AATGGTCG.fastq.gz
```

