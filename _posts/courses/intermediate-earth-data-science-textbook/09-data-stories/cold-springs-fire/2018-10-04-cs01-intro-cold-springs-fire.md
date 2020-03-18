---
layout: single
title: "An Overview of the Cold Springs Wildfire"
excerpt: "The Cold Springs wildfire burned a total of 528 acres of land between July 9, 2016 and July 14, 2016. Learn more about this wildfire and how scientists study wildfire using both field and remote sensing methods."
authors: ['Leah Wasser']
dateCreated: 2018-10-04
modified: 2020-03-18
category: [courses]
class-lesson: ['wildfire-overview-tb']
permalink: /courses/use-data-open-source-python/data-stories/cold-springs-wildfire/
nav-title: 'Cold Springs Wildfire'
week: 9
course: 'intermediate-earth-data-science-textbook'
chapter: 22
module-title: 'An Overview of the Impacts and Study of Wildfire'
module-nav-title: 'Wildfire Overview'
module-description: 'The Cold Springs wildfire burned 528 acres near Nederland, Colorado, in July 2016. Learn about how scientists study the impacts of wildfire using field surveys and remote sensing.'
module-type: 'class'
class-order: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  earth-science: ['fire']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-in-python/intro-wildfires/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter 22 - The Cold Springs Wildfire 

In this chapter, you will learn about the Cold Springs wildfire, which burned a total of 528 acres of land between July 9, 2016 and July 14, 2016. You will also learn how scientists study wildfire using both field and remote sensing methods.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At completing this chapter, you will be able to:

* List the causes and impacts of the 2016 Cold Springs wildfire in Colorado. 
* Explain how scientists use field measurements and remote sensing to study wildfire impacts.
* List two primary vegetation indices that are used to study wildfire impacts.
* List four primary sources of remote sensing data that can be used to study wildfire.

</div>


## What Causes Wildfires?

Wildfires can occur naturally or be triggered by humans. Research from Jennifer Balch of the University of Colorado Earth Lab has shown that humans are responsible for <a href="http://www.sciencemag.org/news/2017/09/who-starting-all-those-wildfires-we-are" target="_blank">starting 84% of wildfires.</a> The most common causes of human-induced fires are intentional acts of arson, campfires, debris burning, and discarded cigarettes.

Humans also increase the prevalence of wildfires indirectly through climate change. Warmer, drier conditions from climate change lead to drought. Specifically, spring is coming sooner, making mountain snow melt earlier and increasing the likelihood of drought later in the summer. These droughts make vegetation drier and a better fuel source for fire. A drier climate also leads to more lightening, which is the most common non-human source of fires.

Wildfires can be both devastating and rejuvenating for the environment. While they cause destruction, many ecosystems depend on them. They perform critical ecological tasks like facilitating vegetation growth and removing non-native species. When humans actively try to prevent natural fires, it can lead to larger fires due to fuel buildup. 

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/animals-fleeing-wildfire-montana-cold-springs-fire.jpg">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/animals-fleeing-wildfire-montana-cold-springs-fire.jpg" alt="Two elk flee from a wildfire into a river in this photo of Bitterroot National Forest, Montana.">
  </a>
  <figcaption>Two elk seek safety in a river in this photo of a wildfire in Bitterroot National Forest, Montana taken on August 6, 2000. The year 2000 was one of the worst fire seasons in a half century in the US. By August, when this photo was taken, an area greater than the size of Maryland had burned from wildfires in the country. Source: <a href="https://earthobservatory.nasa.gov/IOTD/view.php?id=843" target="_blank">John McColgan.</a>
  </figcaption>
</figure>


## Wildfire in the US 

Many fires have extreme impacts on humans. The deadliest fire in U.S. history was the Peshtigo Fire in northeastern Wisconsin in 1871. It killed about 2,500 people and burned 1.2 million acres of land. While the entire western U.S. is prone to wildfires, California is particularly vulnerable due to frequent droughts and coastal winds. 

One of the most destructive blazes in the world in recent history was the Cedar Fire in San Diego County, California in October 2003, killing 14 people, destroying 2,280 buildings, and burning 280,000 acres of land. The most destructive in Colorado was the Fourmile Canyon Fire in September 2010, which destroyed 168 homes and led to $217 million in insurance claims. 

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/los-angeles-day-fire-nasa-satellite-image-cold-springs-fire.jpg">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/los-angeles-day-fire-nasa-satellite-image-cold-springs-fire.jpg" alt="Remote sensing image of the Los Angeles Day Fire from NASA’s MASTER sensor.">
  </a>
  <figcaption>This image was taken with NASA’s aircraft-based MASTER sensor shows the Day Fire northwest of Los Angeles burning on September 19, 2006. Source: <a href="https://earthobservatory.nasa.gov/NaturalHazards/view.php?id=17339" target="_blank">NASA.</a>
  </figcaption>
</figure>

## About the Cold Springs Fire

The Cold Springs wildfire was first reported on July 9, 2016 along Hurricane Hill, approximately two miles northeast of Nederland, Colorado. 

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/map-nederland-cold-springs-fire.png">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/map-nederland-cold-springs-fire.png" alt="Map of Nederland, Colorado.">
  </a>
  <figcaption>Map showing the location of Nederland, Colorado, in relation to the Denver Metro Area. Source: Google Maps.
  </figcaption>
</figure>

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/map-extent-of-cold-springs-fire.jpg">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/map-extent-of-cold-springs-fire.jpg" alt="Map of the extent of the Cold Springs fire near Nederland, Colorado.">
  </a>
  <figcaption>This map shows the extent of the Cold Springs fire, just outside of Nederland, Colorado, at its peak on July 10th, 2016. Source: InciWeb.
  </figcaption>
</figure>

The human-started wildfire was officially extinguished on July 14, 2016. It burned a total of 528 acres of land, 430 acres on privately owned land and 98 on US Forest Service property. Eight homes were lost.

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/firefighters-on-scene-of-cold-springs-fire.jpg">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/firefighters-on-scene-of-cold-springs-fire.jpg" alt="Firefighters on the scene of the Cold Springs Fire.">
  </a>
  <figcaption>Firefighters on the scene of the Cold Springs Fire on July 11, 2016. The wildfire burned mainly in Ponderosa and lodgepole pine forests. The fire burned on a total of 528 acres and destroyed eight homes. Source: <a href="https://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">The Denver Post.</a>
  </figcaption>
</figure>

The cause of the Cold Springs wildfire has been attributed to a campfire that was not properly extinguished during a county-wide fire ban. Two transient men from Alabama were charged with fourth-degree arson. They were sentenced with two years of work release to be followed by four years of probation and must pay restitution of up to 1.25 million dollars. 

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/burned-trees-cold-springs-fire.jpg">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/burned-trees-cold-springs-fire.jpg" alt="Burned trees after the Cold Springs wildfire.">
  </a>
  <figcaption>A scene from the fire site taken on September 7th 2016, about two months after the Cold Springs wildfire. Source: Nate Mietkiewicz, Earth Lab.
  </figcaption>
</figure>


## Impacts of the Cold Springs Fire

In addition to the homes that were destroyed, the Cold Springs Fire had significant impacts on those close to it. Due to the proximity to the town of Nederland, nearly 2,000 people were forced to evacuate. At the height of the fire, officials drafted plans to evacuate residents as far east as Boulder.

<figure>
  <a href="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/burned-cars-cold-springs-fire.jpg">
    <img src="{{ site.url }}/images/earth-analytics/science/cold-springs-fire/burned-cars-cold-springs-fire.jpg" alt="Burned cars in Nederland, Colorado after the Cold Springs fire.">
  </a>
  <figcaption>An image of a burned Porsche and Ford Bronco at the site of a home decimated by the Cold Springs fire in Nederland, Colorado. Source: <a href="https://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">The Denver Post.</a>
  </figcaption>
</figure>
