#import Pkg; 
#Pkg.add("PlutoUI")
#Pkg.add("DataFrames")
#Pkg.add("Plots")
#Pkg.add("RDatasets")
#Pkg.add("Statistics")
#Pkg.add("StatsPlots")
#Pkg.add("CSV")
#Pkg.add("StatsBase")
#Pkg.add("PlotlyJS")

using PlutoUI
using DataFrames
using Plots
#using PlotlyJS
using RDatasets
using Statistics
using StatsPlots
using CSV
using StatsBase

# Question of study 3): What are the correlations between tree type, land use, height, leaf area, carshade for urban tree planning by region/city.

df = CSV.read("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/TreeData/Data/TS3_Raw_tree_data.csv", DataFrame)
#print(df)





################ Explore Tree Height distributions ######################
df0 = select(df,["Region", "City", "CommonName", "TreeHt"])
df00 = filter(x -> x.TreeHt > 0, df0)

o = countmap(df.CommonName)
pcount = plot(o, st=:bar, xlabel="Common Name", ylabel="Class Count", label="", size=(1400,900))
png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_CommonName_count")

# try grouping by city, or by region
df0_city = groupby(df00, :City)
cdf0_city = combine(df0_city, :TreeHt => mean)
df0_region = groupby(df00, :Region)
cdf0_reg = combine(df0_region, :TreeHt => mean)

#reeHt_plot = histogram(df00.TreeHt, label="", xlabel="Tree Height (m)", ylabel="Count")
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_TreeHt_Histogram")

    TreeHt_region_barplot = bar(cdf0_reg.TreeHt_mean,orientation=:horizontal,
    yticks=(1:length(cdf0_reg.TreeHt_mean), cdf0_reg.Region),
    yflip=true,
    xlabel="Mean Tree Height (m)",
    ylabel="Region",
    lab="",
    size=(600, 600))
    #png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_TreeHt_Region")

    TreeHt_city_barplot = bar(cdf0_city.TreeHt_mean, orientation=:horizontal,
    yticks=(1:length(cdf0_city.TreeHt_mean), cdf0_city.City),
    yflip=true,
    xlabel="Mean Tree Height (m)",
    ylabel="City",
    lab="",
    size=(600, 600))
    #png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_TreeHt_City")

# Violin and Boxplot? 
#TreeHt_city_boxplot = violin(:City, :TreeHt, lab="", df00)
#TreeHt_city_boxplot = boxplot!(:City, :TreeHt, alpha=.4, lab="",df)




########### Explore species and mean height relationship ##############
df0_species = groupby(df00, :CommonName)
comb_df_TreeHt_species = combine(df0_species, :TreeHt => mean)

TreeHt_species_barplot = bar(comb_df_TreeHt_species.TreeHt_mean, orientation=:horizontal,
yticks=(1:length(comb_df_TreeHt_species.TreeHt_mean), comb_df_TreeHt_species.CommonName),
yflip=true,
xlabel="Mean Tree Height (m)",
ylabel="Common Name",
lab="",
size=(1000, 2000))
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/TreeHt_Species_barplot")




############## Explore tree species and land use relationship #################
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
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/MeanLandUse_Species_barplot")


# Explore tree height and land use relationship
#df_LandUse_TreeHt = groupby(df_LandUse_filt, :LandUse)
#comb_df_LandUse_TreeHt = combine(df_LandUse_TreeHt, :TreeHt => mean)

#LandUse_TreeHt_barplot = bar(comb_df_LandUse_TreeHt.TreeHt_mean, orientation=:horizontal,
#yticks=(1:length(comb_df_LandUse_TreeHt.TreeHt_mean), comb_df_LandUse_TreeHt.LandUse),
#yflip=true,
#xlabel="Mean Tree Height (m)",
#ylabel="Land Use (1=single family residential, 2=multi-family residential, 3=industrial/institutional/large commercial, 4=park/vacant/other, 5=small commercial, 6=transportation corridor)",
#lab="",
#size=(1200, 1200))
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/MeanTreeHt_LandUse_barplot")





########### Explore carshade, leaf area #########
#df_Leaf = select(df,["Region", "City", "Leaf", "CarShade", "TreeHt"])
#df_Leaf_filt = filter(x -> x.Leaf > 0, df_Leaf)
#df_Leaf_filt = filter(c -> c.CarShade >= 0, df_Leaf_filt)

#Leaf_CarShade_plot = scatter(df_Leaf_filt.Leaf, df_Leaf_filt.CarShade, xlabel="Leaf Area (m)", ylabel="Car Shade, (0=no autos, 1=1 auto, etc.)", lab="")
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/LeafArea_CarShade_plot")
#println(maximum(df_Leaf_filt.CarShade))




######### leaf area, dbh, crown, Cdia relationships ############
df1 = select(df,["DBH", "CrnBase", "Leaf", "CrnHt", "TreeHt", "AvgCdia", "City"])
df11 = filter(x -> (x.Leaf != -1) && (x.CrnBase != -1) && (x.CrnHt != -1) && (x.DBH != -1) && (x.AvgCdia != -1), df1)

#df11g = groupby(df11, :City)
#df12 = combine(df11g, :CrnBase => mean, :Leaf => mean)
#p_leaf_crn_city = plot(df12, x=:Leaf_mean, y=:CrnBase_mean, xlabel="Leaf Area (m)", ylabel="Crown Height (m)")
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/Leafmean_CrownHt_Scatter")

    df12= filter(x -> (x.City =="Santa Monica, CA"), df11)
    df12= groupby(df12,:TreeHt)
    df12= combine(df12,:DBH=>mean)
    pp12= plot(df12.TreeHt, df12.DBH_mean, st= [:scatter],xlabel= "Tree Height", ylabel= "Average DBH", lab="Santa Monica, CA")
    cor(df12.TreeHt, df12.DBH_mean)


    df13= filter(x -> (x.City =="Berkeley, CA"), df11)
    df13= groupby(df13,:TreeHt)
    df13= combine(df13,:DBH=>mean)
    pp13= plot!(df13.TreeHt, df13.DBH_mean, st= [:scatter],xlabel= "Tree Height", ylabel= "Average DBH", lab="Berkeley, CA")
    cor(df13.TreeHt, df13.DBH_mean)

    
    df14= filter(x -> (x.City =="Fort Collins, CO"), df11)
    df14= groupby(df14,:TreeHt)
    df14= combine(df14,:DBH=>mean)
    pp14= plot!(df14.TreeHt, df14.DBH_mean, st= [:scatter],xlabel= "Tree Height", ylabel= "Average DBH", lab="Fort Collins, CO")
    cor(df14.TreeHt, df14.DBH_mean)


    df15= filter(x -> (x.City =="Longview, WA"), df11)
    df15= groupby(df15,:TreeHt)
    df15= combine(df15,:DBH=>mean)
    pp15= plot!(df15.TreeHt, df15.DBH_mean, st= [:scatter],xlabel= "Tree Height", ylabel= "Average DBH", lab="Longview, WA")
    cor(df15.TreeHt, df15.DBH_mean)


    df16= filter(x -> (x.City =="Boise, ID"), df11)
    df16= groupby(df16,:TreeHt)
    df16= combine(df16,:DBH=>mean)
    pp16= plot!(df16.TreeHt, df16.DBH_mean, st= [:scatter],xlabel= "Tree Height", ylabel= "Average DBH", lab="Boise, ID")
    cor(df16.TreeHt, df16.DBH_mean)


    df17= filter(x -> (x.City =="Queens, NY"), df11)
    df17= groupby(df17,:TreeHt)
    df17= combine(df17,:DBH=>mean)
    pp17= plot!(df17.TreeHt, df17.DBH_mean, st= [:scatter],xlabel= "Tree Height", ylabel= "Average DBH", lab="Queens, NY", legend=:bottomright)
    cor(df17.TreeHt, df17.DBH_mean)

    #png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_TreeHt_AvgDBH_Cities_Scatter")

    #pp_all = plot(pp12, pp13, pp14, pp15, pp16, pp17, size = (800,800), legend=:bottomright)
    #png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_TreeHt_AvgDBH_CitiesSubplots_Scatter")


Leaf_dbh_plot = marginalhist(df11.Leaf, df11.DBH, bins=50, xlabel="Leaf Area (m)", ylabel="DBH (m)", lab="")
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_MargHist_LeafArea_DBH")
cor(df11.Leaf, df11.DBH)

dbh_crnbase_plot = marginalhist(df11.DBH, df11.CrnBase, bins=50, xlabel="DBH(m)", ylabel="Crown Height (m)", lab="")
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_MargHist_DBH_CrownHt")
cor(df11.DBH, df11.CrnBase)


dbh_TreeHt_plot = marginalhist(df11.DBH, df11.TreeHt, bins=50, xlabel="DBH(m)", ylabel="Tree Height (m)", lab="")
#plw = @df df marginalhist(:DBH, :TreeHt,
#bins=20,
#xlabel="DBH (m)",
#ylabel="Tree Height (m)",)
cor(df.DBH, df.TreeHt)
#png("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/Analysis_Emma/Output/E_MargHist_DBH_Ht")
