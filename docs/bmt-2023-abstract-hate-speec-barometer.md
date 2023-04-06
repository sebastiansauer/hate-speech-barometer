---
title: The Social Media Hate Speech Barometer: Making of
---



Hate Speech, particularly on the Social Media channels, 
is a pressing concern for cyber security, and it may even threaten the foundations of societal stability.
Whereas there exists a growing literature body on how to detect and fence off hate speech, 
applied researchers lack a state-of-the-art, 
yet easily accessible infrastructure to build their own hate speech detection pipelines. 
We aim to provide an example of such an infrastructure which may serve as a template for other researchers.
The infrastructure which we present builds on the most recent technologies of machine learning available in the R environment:
The Tidymodels framework, along with its Tidytext extension,
laid in the Targets project management approach are the building blocks of our proposed infrastructure.
In short, our data pipeline starts at downloading and preprocessing tweets, applying different methods to convert text to numeric information. We then apply state-of-the-art supervised machine learning pipelines, drawing on an array of learning algorithms, and also include recent tuning options.
The focus of this paper is to explain the setup and rationale of the infrastructure.
Our infrastructure is freely available on Github at 

