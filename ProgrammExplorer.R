options(java.parameters = "- Xmx1024m")

library(corporaexplorer)
library(pdftools)
library(tabulizer)

setwd(".../Parteiprogramme")

DieLinke_URL <- "https://www.die-linke.de/fileadmin/download/wahlen2021/Wahlprogramm/DIE_LINKE_Wahlprogramm_zur_Bundestagswahl_2021.pdf"
download.file(DieLinke_URL, 'DieLinke.pdf', mode="wb")

AfD_URL <- "https://cdn.afd.tools/wp-content/uploads/sites/111/2021/05/2021-05-20-_-AfD-Bundestagswahlprogramm-2021.pdf"
download.file(AfD_URL, 'AfD.pdf', mode="wb")

FDP_URL <- "https://www.fdp.de/sites/default/files/2021-06/FDP_Programm_Bundestagswahl2021_1.pdf"
download.file(FDP_URL, 'FDP.pdf', mode="wb")

SPD_URL <- "https://www.spd.de/fileadmin/Dokumente/Beschluesse/Programm/SPD-Zukunftsprogramm.pdf"
download.file(SPD_URL, 'SPD.pdf', mode="wb")

GRUENE_URL <- "https://cms.gruene.de/uploads/documents/Wahlprogramm-DIE-GRUENEN-Bundestagswahl-2021_barrierefrei.pdf"
download.file(GRUENE_URL, 'GRUENE.pdf', mode="wb")

CDU_URL <- "https://www.csu.de/common/download/Regierungsprogramm.pdf"
download.file(CDU_URL, 'CDU.pdf', mode="wb")

DieLinke <- pdf_text(pdf = "DieLinke.pdf")
AfD <- pdf_text(pdf = "AfD.pdf")
FDP <- pdf_text(pdf = "FDP.pdf")
SPD <- pdf_text(pdf = "SPD.pdf")
GRUENE <- pdf_text(pdf = "GRUENE.pdf")
CDU <- pdf_text(pdf = "CDU.pdf")

AfD_neu <- c()
for (i in 1:length(AfD)) AfD_neu[i] <- extract_text("AfD.pdf", pages=i) 
FDP_neu <- c()
for (i in 1:length(FDP)) FDP_neu[i] <- extract_text("FDP.pdf", pages=i) 
SPD_neu <- c()
for (i in 1:length(SPD)) SPD_neu[i] <- extract_text("SPD.pdf", pages=i) 
GRUENE_neu <- c()
for (i in 1:length(GRUENE)) GRUENE_neu[i] <- extract_text("GRUENE.pdf", pages=i) 
CDU_neu <- c()
for (i in 1:length(CDU)) CDU_neu[i] <- extract_text("CDU.pdf", pages=i) 
DieLinke_neu <- c()
for (i in 1:length(DieLinke)) DieLinke_neu[i] <- extract_text("DieLinke.pdf", pages=i) 

Partei <- c(rep("DieLinke", length(DieLinke)), 
            rep("AfD", length(AfD)),
            rep("FDP", length(FDP)),
            rep("SPD", length(SPD)),
            rep("GRUENE", length(GRUENE)),
            rep("CDU", length(CDU)))

Text <- c(DieLinke_neu, AfD_neu, FDP_neu, SPD_neu, GRUENE_neu, CDU_neu)

df <- data.frame(Text, Partei)

corpus <- prepare_data(
  df,
  date_based_corpus = FALSE,
  grouping_variable = "Partei")

dir.create("my_app")
saveRDS(corpus, "my_app/saved_corporaexplorerobject.rds", compress = FALSE)

install.packages('rsconnect')

rsconnect::setAccountInfo(name='parteiprogramme', token='XXX', secret='XXX')

library(rsconnect)
rsconnect::deployApp('my_app')

