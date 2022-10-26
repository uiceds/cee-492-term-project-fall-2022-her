---
title: Analyzing the Correlations among Tree Characteristics and their Surroundings
keywords:
- markdown
- publishing
- manubot
lang: en-US
date-meta: '2022-10-26'
author-meta:
- Hadil Helaly
- Emma Golub
- Riley Blasiak
- Rupesh Rokade
header-includes: |-
  <!--
  Manubot generated metadata rendered from header-includes-template.html.
  Suggest improvements at https://github.com/manubot/manubot/blob/main/manubot/process/header-includes-template.html
  -->
  <meta name="dc.format" content="text/html" />
  <meta name="dc.title" content="Analyzing the Correlations among Tree Characteristics and their Surroundings" />
  <meta name="citation_title" content="Analyzing the Correlations among Tree Characteristics and their Surroundings" />
  <meta property="og:title" content="Analyzing the Correlations among Tree Characteristics and their Surroundings" />
  <meta property="twitter:title" content="Analyzing the Correlations among Tree Characteristics and their Surroundings" />
  <meta name="dc.date" content="2022-10-26" />
  <meta name="citation_publication_date" content="2022-10-26" />
  <meta name="dc.language" content="en-US" />
  <meta name="citation_language" content="en-US" />
  <meta name="dc.relation.ispartof" content="Manubot" />
  <meta name="dc.publisher" content="Manubot" />
  <meta name="citation_journal_title" content="Manubot" />
  <meta name="citation_technical_report_institution" content="Manubot" />
  <meta name="citation_author" content="Hadil Helaly" />
  <meta name="citation_author_institution" content="Department of Civil and Environmental Engineering" />
  <meta name="citation_author" content="Emma Golub" />
  <meta name="citation_author_institution" content="Department of Civil and Environmental Engineering" />
  <meta name="citation_author" content="Riley Blasiak" />
  <meta name="citation_author_institution" content="Department of Civil and Environmental Engineering" />
  <meta name="citation_author" content="Rupesh Rokade" />
  <meta name="citation_author_institution" content="Department of Civil and Environmental Engineering" />
  <link rel="canonical" href="https://uiceds.github.io/cee-492-term-project-fall-2022-her/" />
  <meta property="og:url" content="https://uiceds.github.io/cee-492-term-project-fall-2022-her/" />
  <meta property="twitter:url" content="https://uiceds.github.io/cee-492-term-project-fall-2022-her/" />
  <meta name="citation_fulltext_html_url" content="https://uiceds.github.io/cee-492-term-project-fall-2022-her/" />
  <meta name="citation_pdf_url" content="https://uiceds.github.io/cee-492-term-project-fall-2022-her/manuscript.pdf" />
  <link rel="alternate" type="application/pdf" href="https://uiceds.github.io/cee-492-term-project-fall-2022-her/manuscript.pdf" />
  <link rel="alternate" type="text/html" href="https://uiceds.github.io/cee-492-term-project-fall-2022-her/v/68b4c9e6eb3a6223c23843928c7a17033fba1812/" />
  <meta name="manubot_html_url_versioned" content="https://uiceds.github.io/cee-492-term-project-fall-2022-her/v/68b4c9e6eb3a6223c23843928c7a17033fba1812/" />
  <meta name="manubot_pdf_url_versioned" content="https://uiceds.github.io/cee-492-term-project-fall-2022-her/v/68b4c9e6eb3a6223c23843928c7a17033fba1812/manuscript.pdf" />
  <meta property="og:type" content="article" />
  <meta property="twitter:card" content="summary_large_image" />
  <link rel="icon" type="image/png" sizes="192x192" href="https://manubot.org/favicon-192x192.png" />
  <link rel="mask-icon" href="https://manubot.org/safari-pinned-tab.svg" color="#ad1457" />
  <meta name="theme-color" content="#ad1457" />
  <!-- end Manubot generated metadata -->
bibliography:
- content/manual-references.json
manubot-output-bibliography: output/references.json
manubot-output-citekeys: output/citations.tsv
manubot-requests-cache-path: ci/cache/requests-cache
manubot-clear-requests-cache: false
...






<small><em>
This manuscript
([permalink](https://uiceds.github.io/cee-492-term-project-fall-2022-her/v/68b4c9e6eb3a6223c23843928c7a17033fba1812/))
was automatically generated
from [uiceds/cee-492-term-project-fall-2022-her@68b4c9e](https://github.com/uiceds/cee-492-term-project-fall-2022-her/tree/68b4c9e6eb3a6223c23843928c7a17033fba1812)
on October 26, 2022.
</em></small>

## Authors



+ **Hadil Helaly**<br>
    · ![GitHub icon](images/github.svg){.inline_icon}
    [hadilhelaly](https://github.com/hadilhelaly)<br>
  <small>
     Department of Civil and Environmental Engineering
  </small>

+ **Emma Golub**<br>
    · ![GitHub icon](images/github.svg){.inline_icon}
    [emmaagolub](https://github.com/emmaagolub)<br>
  <small>
     Department of Civil and Environmental Engineering
  </small>

+ **Riley Blasiak**<br>
    · ![GitHub icon](images/github.svg){.inline_icon}
    [blasiak2](https://github.com/blasiak2)<br>
  <small>
     Department of Civil and Environmental Engineering
  </small>

+ **Rupesh Rokade**<br>
    · ![GitHub icon](images/github.svg){.inline_icon}
    [RupeshRokade16](https://github.com/RupeshRokade16)<br>
  <small>
     Department of Civil and Environmental Engineering
  </small>



## Introduction

The Urban tree database, which was collected by the US Forest Service Research Archive of the US Department of Agriculture, includes data about tree growth in urban areas across 17 cities and 13 states over the span of 14-years (from 1998-2012). The states included in the study are: Arizona, California, Colorado, Florida, Hawaii, Idaho, Indiana, Minnesota, New Mexico, New York, North Carolina, Oregon, and South Carolina. The data come from measurements taken to over 14,000 street and urban park trees, and the data can be obtained by downloading the 1.08 MB compressed “data publication” file from [Link]( https://www.fs.usda.gov/rds/archive/catalog/RDS-2016-0005). Some measurements of interest include tree age, location, height, crown diameter, leaf area, foliar biomass, and utility line interference. Tree age, for example, was determined from interviews with residents, street construction dates, aerial and historical photos, the city’s urban forester, and laboratory cores developed by the Lamont-Doherty Earth Observatory’s Tree Ring Laboratory. 

The downloaded folder includes 9 data sheets in CSV format. The most interesting data files are 1. TS1_Regional_information.csv, 2. TS2_Regional_species_and_counts.csv, and 3. TS3_Raw_tree_data.csv. First, the “TS1_Regional_information.csv” file contains information about region code, city, state, airport codes, and collection year. Second, the “TS2_Regional_species_and_counts.csv” file contains information (columns) regarding region, scientific and common names of trees, tree type, and 9 columns of dbh_class, which represent a species diameter at breast height and are used to predict tree height, crown diameter, crown height, and leaf area. The file contains a total of 347 rows. Finally, the “TS3_Raw_tree_data.csv” file includes 14487 observations (rows) of raw tree data. For each observation, 41 different variables were collected (columns). A detailed description of each of these 41 variables is as followed:

- DbaseID = Unique id number for each tree.
- Region = 16 U.S. climate regions, abbreviations are used.
- City = City/state names where data collected.
- Source = Original *.xls filename (not available in this data publication).
- TreeID = Number assigned to each tree in inventory by city.
- Zone = Number/ID/name of the management area or zone that the tree is located in within a city; or nursery if young tree data collected there.
- Park/Street = Data listed as Park, Street, Regional Big Tree, or Nursery (for young tree measurements).
- SpCode = 4 to 6 letter code consisting of the first two letters of the genus name and the first two letters of the species name followed by two optional letters to distinguish two species with the same four-letter code (See \Data\TS2_Regional_species_and_counts.csv for a list of the SpCodes and corresponding scientific names.)
- ScientificName = Botanical name of species.
- CommonName = Common name of species.
- Tree Type = 3 letter code where first two letters refer to life form (BD=broadleaf deciduous, BE=broadleaf evergreen, CE=coniferous evergreen, PE=palm evergreen) and the third letter is mature height (S=small which is < 8 meters, M=medium which is 8-15 meters, and L=large which is > 15 meters).
- Address = From inventory, street number of building where tree is located.
- Street = From inventory, the name of the street the tree is located on. (NOTE: zero values denote data were not recorded in that city. These values were left unchanged because they originated from city inventories.)
- Side = From inventory, side of building or lot tree is located on (F=front, M=median, S=side, P=park). (NOTE: zero values denote data were not recorded in that city. These values were left unchanged because they originated from city inventories.)
- Cell = From inventory, the cell number (i.e., 1, 2, 3, …), where protocol determines the order trees at same address are numbered (e.g., driving direction or as street number increases).
- OnStreet = From inventory (omitted if not a field in city’s inventory), for trees at corner addresses when tree is on cross street rather than addressed street.
FromStreet = From inventory, the name of the first cross street that forms a boundary for trees lining un-addressed boulevards. Trees are typically numbered in order (1, 2, 3 …) on boulevards that have no development adjacent to them, no obvious parcel addresses.
- ToStreet = From inventory, the name of the last cross street that forms a boundary for trees lining un-addressed boulevards.
- Age = Number of years since planted. (NOTE: zero values represent newly planted trees, < 1 year old.)
- DBH (cm) = Diameter at breast height (1.37 meters [m]) measured to nearest 0.1 centimeters (tape). For multi-stemmed trees forking below 1.37 m measured above the butt flare and below the point where the stem begins forking, as per protocol.
- TreeHt (m) = From ground level to tree top to nearest 0.5 m (omitting erratic leader).
- CrnBase (m) = Average distance between ground and lowest foliage layer to nearest 0.5 m (omitting erratic branch).
- CrnHt (m) = Calculated as TreeHT minus Crnbase to nearest 0.5 m. (NOTE: zero values indicate no live crown was present, hence no other tree dimension data were available.)
- CdiaPar (m) = Crown diameter measurement taken to the nearest 0.5 m parallel to the street (omitting erratic branch).
- CDiaPerp (m) = Crown diameter measurement taken to the nearest 0.5 m perpendicular to the street (omitting erratic branch).
- AvgCdia (m) = The average of crown diameter measured parallel and perpendicular to the street.
- Leaf (m2) = Estimated using digital imaging method to nearest 0.1 squared meter (m2).
- Setback = Distance from tree to nearest air-conditioned/heated space (may not be same address as tree location): 1=0-8 m, 2=8.1-12 m, 3=12.1-18 m, 4=> 18 m.
- TreeOr = Taken with compass, the coordinate of tree taken from imaginary lines extending from walls of the nearest conditioned space (may not be same address as tree location).
- CarShade = Number of parked automotive vehicles with some part under the tree's drip line. Car must be present (0=no autos, 1=1 auto, etc.).
- LandUse = Predominant land use type where tree is growing (1=single family residential, 2=multi-family residential [duplex, apartments, condos], 3=industrial/institutional/large commercial [schools, gov't, hospitals], 4=park/vacant/other [agric., unmanaged riparian areas of greenbelts], 5=small commercial [minimart, retail boutiques, etc.], 6=transportation corridor).
- Shape = Visual estimate of crown shape verified from each side with actual measured dimensions of crown height and average crown diameter (1=cylinder [maintains same crown diameter in top and bottom thirds of tree], 2=ellipsoid, the tree's center [whether vertical or horizontal is the widest, includes spherical], 3=paraboloid [widest in bottom third of crown], 4=upside down paraboloid [widest in top third of crown]).
- WireConf = Utility lines that interfere with or appear above tree (0=no lines, 1=present and no potential conflict, 2=present and conflicting, 3=present and potential for conflicting). (NOTE: -1 denotes data were not collected.)
- dbh1 = Dbh (centimeters [cm]) for multi-stemmed trees; for non-multi-stemmed trees, dbh1 is same as Dbh (cm).
- dbh2 = Dbh (cm) for second stem of multi-stemmed trees.
- dbh3 = Dbh (cm) for third stem of multi-stemmed trees.
- dbh4 = Dbh (cm) for fourth stem of multi-stemmed trees.
- dbh5 = Dbh (cm) for fifth stem of multi-stemmed trees.
- dbh6 = Dbh (cm) for sixth stem of multi-stemmed trees.
- dbh7 = Dbh (cm) for seventh stem of multi-stemmed trees.
- dbh8 = Dbh (cm) for eight stem of multi-stemmed trees.

Additionally, a fourth data set may be of later interest for estimating leaf area, species dominance at a spatial scale, and carbon storage estimates. The TS5_Foliar_biomass_leaf_samples.csv contains urban foliar samples data by species for 17 U.S. cities. A total of 261 rows are provided.

The breadth of this dataset allows for a myriad of problems to be explored. The primary data that will be utilized for this project is the “TS3_Raw_tree_data.csv” file, as this contains the most columns which will result in more feasible predictions during the machine learning portion of the project. This data can be used to analyze correlations between tree characteristics and their surroundings. One potential research question using the “TS3_Raw_tree_data.csv” file is: how does utility line interference affect the growth of a certain type of tree in one state versus a different state. the preliminery 14 variables that can be used in the proposed analysis include "Address", "Age", "Shape", "WireConf", "Setback","CarShade", "DBH", "TreeHt", "CrnBas" "CrnHt", "CdiaPar", "CDiaPerp", "AvgCdia", "Leaf".

After tidying the dataset, we can compare the effect of the WireConf, Setback, CarShade on the remaining variables of similar trees. Since we also contain the addresses of the trees, along with visualizing graphs from results of the comparisons, we can create maps to understand the variance of these effects across different cities. Further, a machine learning model can be created to possibly target and predict the above results for a city that is not mentioned in the dataset and predict the missing values in the dataset.




## Exploratory Data Analysis

The following will provide a narrative description and characterization of the tree dataset, interspersed with summary statistics and plots. Throughout this exploratory analysis, four main questions were investigated to guide data exploration:

1. How do power lines impact the growth of trees? (i.e., number of trees, leaf area, tree height, power lines)
2. How does setback (tree distance from heated/airconditioned spaces) show in different cities and/or regions? (i.e., correlation with tree height, leaf size, location)
3. What are the correlations between tree type, land use, height, leaf area, carshade, DBH, CdiaPar, and CDiaPerp for urban tree planning by region and/or city?
4. How does growth rate (i.e., height per age of tree) differ for each region, land use, city, etc.?

For each of these questions, the data was wrangled and filtered to generate visualizations of potential correlations among selected variables of interest.


### Question 1
In this part, the research team were exploring if the present of utility lines has an impact on the growth of tree. To answer this question, four variables were selected to be analyzed and filtered to find the correlation between the present of utility lines and the growth of tree that include “WireConf” “Age”, “TreeHt”, and “DBH”. The “WireConf” variable is a categorical variable that presents if the utility lines interfere with or appear above tree. This variable might include one of five values, 0=no lines, 1=present and no potential conflict, 2=present and conflicting, 3=present and potential for conflicting, and -1 denotes data were not collected. The “Age” variable is a numerical variables that presents number of years since planted. The “TreeHt (m)” variable is a numerical variable that presents tree height from ground to the treetop to the nearest 0.5 m. The “DBH” variable is a numerical variable that presents diameter of tree at breast height (1.37 meters [m]) measured to nearest 0.1 centimeters. 
The first step in our analysis is to group data by “WireConf” to discover how many trees in our database were affected. Figure 1 shows the number of trees in the database in each category after excluding all trees that do not have data, where 1= no lines, 2 = present and no potential conflict, 3 = present and conflicting, and 4 = present and potential for conflicting. It is clear that the majority of the trees are not in areas that have utility lines conflicting with trees which will help the research team to examine the growth of trees when there are no utility lines and compare it with the growth of trees when utility lines are present.

**(hhttps://github.com/uiceds/cee-492-term-project-fall-2022-her/blob/main/content/images/h_numberOf%20Datapoint.png"){#fig:h_numberOf Datapoint-image}**

![Number of Trees in Each Category.](images/h_numberOfDatapoint.png){#fig:example-id}


### Question 2

### Question 3

Relationships among tree species, land use, leaf area, height, and shade were explored to identify any plausible correlations among the variables for the purpose of urban tree planning. It was intially considered that urban city planners may select particular species of tree to plant within specific land use types, and perhaps those tree species were chosen based on average height or canopy size (leaf area) characteristics. For example, an urban planner might choose a specific tree type (i.e., species) for its wide canopy and shorter height to provide shade to automobiles parked along a street without interscepting overhead telephone lines or buildings. [Site from evidence] The following visualizations were produced to study these relationships. 

[insert images]
(images/E_TreeHt_City_barplot.png)

As shown in the above visualizations [insert narrative descriptions here for overall graphs from this question]


Additionally, the relationships among tree height, DBH, CdiaParm and CDiaPerp were further explored. The US Forest Service Research Archives, from which the raw tree data was obtained, describes how variables such as tree age can be used to predict a species diameter at breast height (dbh), which can in turn predict tree height, crown diameter, crown height, leaf area, and tree age (https://data.nal.usda.gov/dataset/urban-tree-database) [note: citations will be updated formally!]. Thus, these variables were chosen to further investigate potential correlations. 



### Question 4


## References {.page_break_before}

<!-- Explicitly insert bibliography here -->
<div id="url:https://www.fs.usda.gov/rds/archive/catalog/RDS-2016-0005"></div>
McPherson, E. Gregory; van Doorn, Natalie S.; Peper, Paula J. 2016. Urban tree database. Fort Collins, CO: Forest Service Research Data Archive. Updated 21 January 2020. https://doi.org/10.2737/RDS-2016-0005