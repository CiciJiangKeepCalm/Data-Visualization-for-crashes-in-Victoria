
library(datasets)
library(xlsx)
library(shinyjs)
library(leaflet.extras)
library(htmltools)
library(V8)
library(shinythemes)
library(googleVis)

library(ggplot2)
library(plotly)

## read data
LIGHT_CONDITION <- read.csv('LIGHT_CONDITION.csv') 
myData <- read.csv('data.csv')
dataRegionYear <- read.csv('dataRegionYear.csv')
dataYear <- read.csv('dataYear.csv')
dataLight <- read.csv('dataLight.csv')
Severity <- read.csv('SEVERITY.csv')

Light_time <- read.csv('Light_time.csv')
type <- read.csv('type.csv')

type_time <- read.csv('type_time.csv')

# fonction allowing geolocalisation
jsCode <- '
shinyjs.geoloc = function() {
navigator.geolocation.getCurrentPosition(onSuccess, onError);
function onError (err) {
Shiny.onInputChange("geolocation", false);
}
function onSuccess (position) {
setTimeout(function () {
var coords = position.coords;
console.log(coords.latitude + ", " + coords.longitude);
Shiny.onInputChange("geolocation", true);
Shiny.onInputChange("lat", coords.latitude);
Shiny.onInputChange("long", coords.longitude);
}, 5)
}
};
'






