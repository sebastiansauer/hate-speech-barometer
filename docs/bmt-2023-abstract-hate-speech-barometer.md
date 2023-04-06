---
title: "The Social Media Hate Speech Barometer: Making of"
---



Hate speech, particularly on social media channels, 
is a pressing cybersecurity concern and can even threaten the very foundations of societal stability.
While there is a growing body of literature on how to detect and mitigate hate speech, 
applied researchers lack a state-of-the-art 
yet easily accessible infrastructure to build their own hate speech detection pipelines. 
We aim to provide an example of such an infrastructure that can serve as a template for other researchers.
The infrastructure we present is based on the latest machine learning technologies available in the R environment:
The Tidymodels framework and its extension Tidytext,
project management approach are the building blocks of our proposed infrastructure.
In short, our data pipeline starts with downloading and preprocessing tweets, using various methods to convert text into numerical information. We then apply state-of-the-art supervised machine learning pipelines, drawing on a range of learning algorithms and incorporating new tuning capabilities.
The focus of this paper is to explain the setup and rationale of the infrastructure.
Our infrastructure is freely available on Github at https://github.com/sebastiansauer/hate-speech-barometer.





