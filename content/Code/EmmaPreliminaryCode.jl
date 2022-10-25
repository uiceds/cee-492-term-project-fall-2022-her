# import Pkg; 
#Pkg.add("PlutoUI")
#Pkg.add("DataFrames")
#Pkg.add("Plots")
#Pkg.add("RDatasets")
#Pkg.add("Statistics")
#Pkg.add("StatsPlots")
#Pkg.add("CSV")
#Pkg.add("StatsBase")
using PlutoUI
using DataFrames
using Plots
using RDatasets
using Statistics
using StatsPlots
using CSV
using StatsBase

# Question of study 3): What are the correlations between tree type, land use, height, leaf area, carshade for urban tree planning by region/city.

df = CSV.read("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/TreeData/Data/TS3_Raw_tree_data.csv", DataFrame)
#print(df)

# Data Cleaning Approach
# Interested in the following variables: Region, City, CommonName, TreeHt (m), CrnBase (m), Leaf (m2), Setback, CarShade, LandUse, WireConf

# Exploration 1: -	Tree height distributions (height x number of trees histograms), by location (i.e. city) , by region (warm, cold, dry, wet climates).
# Step 1: select Region, City, TreeHt (m), species, and create new df from these.
df_TreeDist = select(df,["Region", "City", "CommonName", "TreeHt"])

# Step 2: Rename TreeHt (m) to TreeHt and exclude all "-1" values, which mean data was not collected in those rows.
df_TreeDist_filt = filter(x -> x.TreeHt > 0, df_TreeDist)

# Step 3: try grouping by city, or by region
df_TreeDist_city = groupby(df_TreeDist_filt, :City)
comb_df_TreeHt_city = combine(df_TreeDist_city, :TreeHt => mean)
#comb_df_TreeName_city = combine(df_TreeDist_city, :CommonName => mean)
df_TreeDist_region = groupby(df_TreeDist_filt, :Region)
comb_df_TreeHt_region = combine(df_TreeDist_region, :TreeHt => mean)

# Step 4: Explore distribution of tree heights
TreeHt_plot = histogram(df_TreeDist_filt.TreeHt, label="", xlabel="Tree Height (m)", ylabel="Count")
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_Histogram")

# Violin and Boxplot? NOT WORKING, SYMBOL ERRORS?
    #TreeHt_city_boxplot = violin(:City, :TreeHt, lab="", df_TreeDist_filt)
    #TreeHt_city_boxplot = boxplot!(:City, :TreeHt, alpha=.4, lab="",df_TreeDist_filt)
    #savefig("/TreeHt_city_boxplot.png")

# Step 5: Explore mean tree heights by location, region
    TreeHt_region_barplot = bar(comb_df_TreeHt_region.TreeHt_mean, orientation=:horizontal,
    yticks=(1:length(comb_df_TreeHt_region.TreeHt_mean), comb_df_TreeHt_region.Region),
    yflip=true,
    xlabel="Mean Tree Height (m)",
    ylabel="Region",
    lab="",
    size=(600, 600))
    #png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_Region_barplot")

    TreeHt_city_barplot = bar(comb_df_TreeHt_city.TreeHt_mean, orientation=:horizontal,
    yticks=(1:length(comb_df_TreeHt_city.TreeHt_mean), comb_df_TreeHt_city.City),
    yflip=true,
    xlabel="Mean Tree Height (m)",
    ylabel="City",
    lab="",
    size=(600, 600))
    #png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_City_barplot")


# Step 6: Explore tree species and mean height relationship
df_TreeDist_species = groupby(df_TreeDist_filt, :CommonName)
comb_df_TreeHt_species = combine(df_TreeDist_species, :TreeHt => mean)

TreeHt_species_barplot = bar(comb_df_TreeHt_species.TreeHt_mean, orientation=:horizontal,
yticks=(1:length(comb_df_TreeHt_species.TreeHt_mean), comb_df_TreeHt_species.CommonName),
yflip=true,
xlabel="Mean Tree Height (m)",
ylabel="Common Name",
lab="",
size=(1000, 2000))
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_Species_barplot")

# Step 7: Explore tree species and land use relationship
df_LandUse = select(df,["Region", "City", "CommonName", "TreeHt", "LandUse"])
df_LandUse_filt = filter(x -> x.LandUse > 0, df_LandUse)
df_LandUse_species = groupby(df_LandUse_filt, :CommonName)
comb_df_LandUse_species = combine(df_LandUse_species, :LandUse => mean)
comb_df_LandUse_species[!,:MeanInt_LandUse] = round.(comb_df_LandUse_species.LandUse_mean)


LandUse_species_barplot = bar(comb_df_LandUse_species.MeanInt_LandUse, orientation=:horizontal,
yticks=(1:length(comb_df_LandUse_species.MeanInt_LandUse), comb_df_LandUse_species.CommonName),
yflip=true,
xlabel="Mean Land Use (1=single family residential, 2=multi-family residential, 3=industrial/institutional/large commercial, 4=park/vacant/other, 5=small commercial, 6=transportation corridor)",
ylabel="Species Common Name",
lab="",
size=(1800, 1900))
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/MeanLandUse_Species_barplot")


# Step 8: Explore tree height and land use relationship
df_LandUse_TreeHt = groupby(df_LandUse_filt, :LandUse)
comb_df_LandUse_TreeHt = combine(df_LandUse_TreeHt, :TreeHt => mean)

LandUse_TreeHt_barplot = bar(comb_df_LandUse_TreeHt.TreeHt_mean, orientation=:horizontal,
yticks=(1:length(comb_df_LandUse_TreeHt.TreeHt_mean), comb_df_LandUse_TreeHt.LandUse),
yflip=true,
xlabel="Mean Tree Height (m)",
ylabel="Land Use (1=single family residential, 2=multi-family residential, 3=industrial/institutional/large commercial, 4=park/vacant/other, 5=small commercial, 6=transportation corridor)",
lab="",
size=(1200, 1200))
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/MeanTreeHt_LandUse_barplot")


#### Also, explore above relationships: BY REGION or BY CITY - do these within one specific city. Choose one.
# Land Use and Mean Tree Height in Sacramento 
df_LandUse_City = filter(:City => ==("Sacramento, CA"), df_LandUse_filt)
LandUse_TreeHt_City_barplot = bar(df_LandUse_City.TreeHt, orientation=:horizontal,
yticks=(1:length(df_LandUse_City.TreeHt), df_LandUse_City.LandUse),
yflip=true,
xlabel="Tree Height (m)",
ylabel="Land Use (1=single family residential, 2=multi-family residential, 3=industrial/institutional/large commercial, 4=park/vacant/other, 5=small commercial, 6=transportation corridor)",
lab="",
title="Tree Height vs Land Use in Sacramento, CA")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_LandUse_SacCA")


#### Next: explore carshade, leaf area relationship - exclude -1 non-obtained values.
df_Leaf = select(df,["Region", "City", "Leaf", "CarShade", "TreeHt"])
df_Leaf_filt = filter(x -> x.Leaf > 0, df_Leaf)
df_Leaf_filt = filter(c -> c.CarShade >= 0, df_Leaf_filt)

Leaf_CarShade_plot = scatter(df_Leaf_filt.Leaf, df_Leaf_filt.CarShade, xlabel="Leaf Area (m)", ylabel="Car Shade, (0=no autos, 1=1 auto, etc.)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/LeafArea_CarShade_plot")
#println(maximum(df_Leaf_filt.CarShade))

#### Next: explore leaf area, dbh, crown size relationship - exclude -1 non-obtained values.
df_dbh = select(df,["DBH", "CrnBase", "Leaf", "CrnHt", "TreeHt", "CdiaPar", "CDiaPerp"])
df_dbh_filt = filter(x -> (x.Leaf != -1) && (x.CrnBase != -1) && (x.CrnHt != -1) && (x.DBH != -1) && (x.CdiaPar != -1) && (x.CDiaPerp != -1), df_dbh)

Leaf_crnbase_plot = scatter(df_dbh_filt.Leaf, df_dbh_filt.CrnBase, xlabel="Leaf Area (m)", ylabel="Crown Height (m)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/LeafArea_CrownHt_Scatter")

Leaf_dbh_plot = scatter(df_dbh_filt.Leaf, df_dbh_filt.DBH, xlabel="Leaf Area (m)", ylabel="DBH (m)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/LeafArea_DBH_Scatter")

TreeHt_dbh_plot = scatter(df_dbh_filt.TreeHt, df_dbh_filt.DBH, xlabel="Tree Height (m)", ylabel="DBH (m)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_DBH_Scatter")

TreeHt_CdiaPar_plot = scatter(df_dbh_filt.TreeHt, df_dbh_filt.CdiaPar, xlabel="Tree Height (m)", ylabel="CdiaPar (m)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_CdiaPar_Scatter")

TreeHt_CDiaPerp_plot = scatter(df_dbh_filt.TreeHt, df_dbh_filt.CDiaPerp, xlabel="Tree Height (m)", ylabel="CDiaPerp (m)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_CDiaPerp_Scatter")

dbh_crnbase_plot = scatter(df_dbh_filt.DBH, df_dbh_filt.CrnBase, xlabel="DBH(m)", ylabel="Crown Height (m)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/DBH_CrownHt_Scatter")

dbh_CdiaPar_plot = scatter(df_dbh_filt.CdiaPar, df_dbh_filt.CrnBase, xlabel="CdiaPar (m)", ylabel="Crown Height (m)", lab="")
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/CdiaPar_CrownHt_Scatter")
