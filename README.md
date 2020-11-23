#### Inference of Phosphopeptide Binding Affinity from 14-3-3s by Qsar-based Prediction

##### Intro

The data used in this analysis is retrived from [the 14-3-3 microarray dataset](https://doi.org/10.1002/anie.200801395) published by Candy H. S. Lu, et.al. in `Angewandte Chemie International Edition`. 

>Lu, C., Sun, H., Abu Bakar, F., Uttamchandani, M., Zhou, W., Liou, Y.‐C. and Yao, S. (2008), Rapid Affinity‐Based Fingerprinting of 14‐3‐3 Isoforms Using a Combinatorial Peptide Microarray. Angewandte Chemie International Edition, 47: 7438-7441. https://doi.org/10.1002/anie.200801395

The amino acid descriptors ([DPPS](./data/DPPS), [G8](./data/G8), [HESH](./data/HESH), [VHSE](./data/VHSE), [zScale](./data/zScale)), the raw and [processed](./data/14_3_3_affinity.tsv) data can be found in the `data` folder.

##### 3rd party libraries used in the study.
+ tidyverse
+ glmnet
+ caret
+ plotmo
+ stringr
+ arrangements
