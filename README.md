In this repository you can find all you need to go through the study and analyze the data. 
To reproduce the analysis, the following softwares are needed:
- R and Rstudio
- Matlab

Additional tools can be found at the [eyelink support pages](https://www.sr-research.com/support/thread-7769.html), where they can be downlaoded after registration. 

To analyze eyetracking data, it is worth to 
## Background and hypotheses
This paradigm aims at exploring the relationship between prediction error and memory formation. Participants watch a truck that delivers some goods across the city. On every trial, the truck appears on a different locations, and in the end the delivered item appears. The third truck and the image both appear most of the time at roughly the same place, so that participants will learn over time to predict where the item will be delivered. However, some time the third position will differ to some extent, creating prediction errors of varying degrees: low, high, and medium prediction error. Thus, we manipulate the distance of the actual position of the target object from the most likely position.

After participants finish the previous task (encoding task), they will work on some distractor tasks, and finally on a surprise recognition task. In this last task, we 
ask them to recognize old objects among distractors, asking also how confident they are in this decision. In addition, we ask them to report the location in which the item was shown to them in the encoding task. 

Our hypothesis is that the degree of prediction error will affect the likelihood of remembering the objects and the location in which the objects were presented.  

### Suggested readings:
Van Kesteren, M. T. R., Ruiter, D. J., Fernández, G., & Henson, R. N. (2012). How schema and novelty augment memory formation. Trends in Neurosciences, 35(4), 211–219. https://doi.org/10.1016/j.tins.2012.02.001
Greve, A., Cooper, E., Tibon, R., & Henson, R. N. (2019). Knowledge is power: Prior knowledge aids memory for both congruent and incongruent events, but in different ways. Journal of Experimental Psychology: General, 148(2), 325–341. https://doi.org/10.1037/xge0000498

## Methods
A precise number of trials was selected to balance the number of object in every kind. 
A presentation of the rationale, methods, and hypotheses can be found in the file **PE_continuous.pdf**. 
In general, we have trials in which the trajectory of the truck can be predicted, and trials in which the trajectory is random. The trials that can be predicted always started from one precise location in the circle. While the second location of the track was always the opposite of the second one, the third location was probabilistic, in a way that it occurred with higher probability in a location distributed around a position that was a 90 degree rotation of the last location. The presentation of the last position of the truck in the most frequent location occurred around 65% of the predictable trials, while both the medium and the high occurred around 18% each. The singletons occurred on 15% if the trials. We also needed filler trials to keep the contingencies.
In total, we had 5 types of objects:
- Low PE trials - trials for which the location of the object shown is centered at the most frequent position;
- High PE trials - trials in which the location of the object shown is centered at the opposite side of the most frequent position;
- Med PE trials - trials in which the location of the object shown is centered at 90 degree rotation of the most frequent position. For half of these trials, the center  was a clockwise rotation of the most frequent location, for the remaining trials, the center was a counterclockwise rotation;
-  Singletons - trials in which the trajectory of the track was not predictable. For these trials, the first location of the truck was randomly chosen on each trial from the three positions that were not related to the location of the first truck for the predicted trials (the remaining three quadrants). 
- Fillers - the fillers were trials in which the object was repeated several times. Memory for these object was not tested. 
Fillers - the fillers were trials in which the object was repeated several times. Memory for these object was not tested. 

The number of objects by condition is shown in [this table](https://docs.google.com/spreadsheets/d/10szpl7Acpfk214BrrkESz3qWiMNZlOYykrZ2BMouk8s/edit?usp=drivesdk)

- stimuli: objects

286 trial-unique stimuli were selected from the O-MIND dataset ([https://github.com/DuncanLab/OMINDS](https://github.com/DuncanLab/OMINDS)), half of them can be typically be found indoor, half outdoor. We matched memorability, nameability, and  emotionality among categories (indoor/ outdoor) and encoding/recognition sets. To select the object, we set tmemorability to 100, nameability to 100, and emotionality to 0. 6 objects were the fillers.

### Randomization
The sequence location is randomize for each participant, with the only constraint that the difference between the center of the location of the low PE trials in the firsta session and in the second session should differe of 90 degrees (rotation of 90 deg clockwise or conuterclockwise)

## Pavlovia links
Try out the task at the following links. 

- Encoding task 

[https://run.pavlovia.org/lisco/precont/](https://run.pavlovia.org/lisco/precont/)

- Recognition task

[https://pavlovia.org/lisco/precont_recognition](https://pavlovia.org/lisco/precont_recognition)

### pilot data
Pilot data subdivided in behavioural (beh) and eyetracking (et)

### pilot analysis 
Analysis of the pilot data:
- beh: Behvioural
- et: Eyetracking