# Image classifier: datasets and techniques (draft v0.1)

Status: research notes for team review. Supports FR-24, FR-31, FR-33, FR-64 and risk R2 in [requirements](requirements.md).

## 1. Summary

- No open photo dataset of **human** skeletal trauma was found (searched OpenAlex, Harvard Dataverse, Zenodo, Mendeley Data; November 2026).
- Open image datasets exist only for **animal bone surface modifications** (stereomicroscope close-ups). They can teach one distinction well: **cut mark vs taphonomic damage** (carnivore tooth marks, trampling). In our schema that is `trauma_category = sharp force` (`trauma_subtype = cut (incised)`) vs `not trauma` with `differential = taphonomic (carnivore gnawing)`.
- None of them has labels for blunt force, chop, fractures, projectile or timing. **Trauma category and timing must be learned and evaluated on the experts' images.**
- Plan: use external data only as auxiliary training data for the cut-vs-taphonomic task. Evaluate everything on the experts' images. If those stay under ~100 lesions, the classifier is evaluated but not relied on (R2).

## 2. External datasets

Licence and contents were checked against the repositories' public APIs. "Usable" refers to FR-64 (ML use allowed).

### 2.1 Recommended

| Dataset | Content | Licence | Notes |
|---|---|---|---|
| Domínguez-Rodrigo et al. 2020, Sci Rep — [doi:10.7910/DVN/62BRBP](https://doi.org/10.7910/DVN/62BRBP) | 672 files: 489 cut marks (`SF*`), 103 tooth scores (`LS*`), 63 trampling (`tmp*`), a few extras | CC0 | Best fit. Paper: [10.1038/s41598-020-75994-7](https://doi.org/10.1038/s41598-020-75994-7) |
| Pizarro-Monzo et al. 2023 — [doi:10.17632/3bm34bp6p4.1](https://doi.org/10.17632/3bm34bp6p4.1) | v1 has 1,009 images: 150 cut, 154 trampling, 629 carnivore (bears, hyenas, lions, wolves), 76 unidentified `T*` | CC BY 4.0 (attribution required) | Same lab as above: deduplicate before splitting to avoid leakage. Count differs from the 1,489 quoted elsewhere |
| Domínguez-Rodrigo et al. 2019, Sci Rep — [doi:10.7910/DVN/YHKWMR](https://doi.org/10.7910/DVN/YHKWMR) | Cut marks on fleshed vs defleshed bone, one 855 MB `.rar` plus notebooks | CC0 | Paper: [10.1038/s41598-019-55439-6](https://doi.org/10.1038/s41598-019-55439-6). Butchery order, not antemortem/perimortem/postmortem timing |

### 2.2 Possible extras (tooth marks only)

| Dataset | Content | Licence |
|---|---|---|
| [DVN/WUSGSW](https://doi.org/10.7910/DVN/WUSGSW) (2025 meta-learning paper) | 3 image datasets plus test sets, ~1.7 GB; classes to be checked after unpacking | CC0 |
| [DVN/MLDCIC](https://doi.org/10.7910/DVN/MLDCIC) (2024 Sci Rep) | 1,326 African carnivore tooth marks, plus trained DenseNet/EfficientNet models | CC0 |
| [DVN/IA02PI](https://doi.org/10.7910/DVN/IA02PI) (2021) | 589 tooth scores, 4 carnivores | CC0 |
| [DVN/BL5YSE](https://doi.org/10.7910/DVN/BL5YSE), [TDIEIT](https://doi.org/10.7910/DVN/TDIEIT), [77MZDL](https://doi.org/10.7910/DVN/77MZDL) (2024) | ~550 tooth marks each, same 4 classes; likely overlap with MLDCIC | CC0 |

### 2.3 Not usable

| Dataset | Reason |
|---|---|
| Abellán et al. 2022, crocodile vs cut marks — [DVN/9NOD8W](https://doi.org/10.7910/DVN/9NOD8W) | No licence; terms allow replication only, other use needs author permission |
| TaphoSource (2026) | 3D point clouds, not photos; ownership stays with each original author |
| Roc de les Orenetes confocal scans (Zenodo 7838035) | 12 GB of 3D data, no licence |
| "Sharp force trauma to a human skull" (Zenodo 10282407) | Single 3D model from CT; at most a demo case |

### 2.4 Limits shared by all external datasets

- **Domain shift**: animal bone, ×30 stereomicroscope, uniform lighting, tightly cropped. Our images are mostly overview/detail photos of human bone from publications.
- **No individual or publication IDs**, so the FR-33 split by individual and publication is impossible inside them. Train on them, test only on the experts' images.
- **Not stored as published cases.** They are not human trauma cases and would pollute search and similar-case comparison. Keep them as a separate training set outside the `lesion`/`image` tables.

## 3. Related human forensic ML work

None of these provides open images we can train on. They are useful as method references and for the report's related-work section. Data availability was checked where the full text was reachable; Springer and Wiley pages could not be read automatically, so those statements are unchecked.

| Paper | What it does | Relevance | Data |
|---|---|---|---|
| Marginedas et al. 2024, *Archaeol Anthropol Sci* — [10.1007/s12520-024-02083-5](https://doi.org/10.1007/s12520-024-02083-5) | Statistics and ML classify **fresh vs dry** fractures on human skull fragments from scored features: fracture type, trajectory, angle, cortical delamination, texture | Closest to our perimortem vs postmortem question. Supports a **feature-based** model on the schema's structured fields (FR-30) rather than images | Unchecked |
| Sciâdi Steiger & Borrini 2024, *J Forensic Sci* — [10.1111/1556-4029.15588](https://doi.org/10.1111/1556-4029.15588) | 350 stab marks on pig ribs, 7 knives, stereomicroscope with tangential light. 11 traits (kerf shape, cross-profile, feathering, shards, mounding); logistic regression, 63–85% (serrated) and 63–89% (bevel) | Sharp-force subtyping; trait list could extend the `mark` vocabularies. Finer than our `trauma_subtype` | Unchecked |
| Kyllonen et al. 2022, *Biology* — [10.3390/biology11050749](https://doi.org/10.3390/biology11050749) | Healing scored on radiographs of 942 children; gradient boosting and random forest estimate fracture age, all with "substantial imprecision" | Antemortem timing from healing features. Radiographs are out of scope, but the healing-stage logic matches `healing_stage` | Public scored database (tabular, not images): statsmachine.net radiographic database |
| Dempsey et al. 2022, *J Forensic Sci* — [10.1111/1556-4029.14996](https://doi.org/10.1111/1556-4029.14996) | 3D CNN on post-mortem CT of femoral fractures: pedestrian impact vs fall, ~63–66% validation accuracy | Shows image models on human trauma are still weak with small data. CT is out of scope | Closed access |
| Mata Tutor et al. 2021, *Legal Medicine* — [10.1016/j.legalmed.2021.101868](https://doi.org/10.1016/j.legalmed.2021.101868) | Morphological criteria to tell heat-induced fractures from sharp-force trauma | Possible differential / guidance text (FR-12) | Unchecked |
| Langley et al. 2026, *Forensic Sci Int* — [10.1016/j.forsciint.2026.113134](https://doi.org/10.1016/j.forsciint.2026.113134) | ML on microscopic characteristics of skeletal trauma | Possibly relevant; abstract not available | Closed access |

Takeaway: published human-trauma ML mostly uses **expert-scored features with simple models** (logistic regression, random forest), reaching 60–90%. A feature-based model on our structured fields is a realistic companion to, or fallback for, the image classifier.

## 4. Taphonomy computer-vision literature

All five checked to exist (open access). Claims below come from titles and abstracts, not full reads.

- Domínguez-Rodrigo et al. 2019, *Sci Rep* — cut marks on fleshed vs defleshed bone with CNNs ([10.1038/s41598-019-55439-6](https://doi.org/10.1038/s41598-019-55439-6)).
- Domínguez-Rodrigo et al. 2020, *Sci Rep* — AI classifies modern and ancient bone surface modifications ([10.1038/s41598-020-75994-7](https://doi.org/10.1038/s41598-020-75994-7)).
- *Applied Sciences* 2021 — GAN image augmentation for taphonomy ([10.3390/app11115237](https://doi.org/10.3390/app11115237)).
- Courtenay et al. 2024, *J Comput Appl Archaeol* — "Deep learning-based computer vision is not yet the answer to taphonomic equifinality" ([10.5334/jcaa.145](https://doi.org/10.5334/jcaa.145)). Main caution: models trained on uniform lab photos generalise poorly to other lighting and camera set-ups.
- *Biology Methods and Protocols* 2025 — deep learning and meta-learning reassessed for taphonomic agency ([10.1093/biomethods/bpaf057](https://doi.org/10.1093/biomethods/bpaf057)).

## 5. Techniques to use

| Technique | Why | Requirement |
|---|---|---|
| **Pretrained backbone, frozen, plus a small classifier head** (e.g. ResNet50 / ConvNeXt / DenseNet with ImageNet weights) | Standard in the taphonomy papers; works with hundreds of images | FR-31 |
| **Separate heads**: (a) cut vs taphonomic, trainable with external data; (b) trauma category and (c) timing, trained only on experts' images | External data has no category/timing labels | FR-31, FR-43 |
| **Strong lighting and contrast augmentation** (brightness, contrast, gamma, shadow direction, colour jitter, blur) | Courtenay 2024: lighting changes groove shadows and breaks lab-trained models; publication photos vary widely | FR-31 |
| **Scale normalisation** before cropping, using images with a scale bar (`has_scale`) and FR-17 calibration | Marks look similar across scales (large tooth score vs small rodent gnaw) | FR-17, FR-31 |
| **Use clean images only** (`clean_version_id`), filter by `usable in ('display_and_ml','ml_only')` | Drawn arrows/circles become shortcuts; licence rules | FR-64, FR-65 |
| **Keep 3-channel RGB input**, even for greyscale photos (R=G=B) | Needed for ImageNet-pretrained weights | FR-31 |
| **Grad-CAM heatmap** shown next to the suggestion | Lets the expert see which region drove the suggestion; fits "show reasons" | FR-32, NFR-9 |
| **Grouped split by individual and publication**, macro-F1 and confusion matrix, compared with the rule baseline | Prevents leakage between images of the same lesion/paper | FR-33 |
| **Deduplicate across external datasets** (perceptual hash) before splitting | 62BRBP and Mendeley come from the same lab | FR-33 |
| **Feature-based model** (logistic regression / random forest on structured fields) as a second baseline | Matches how human-trauma ML is done (Section 3); needs no images | FR-30, FR-33 |
| **Same backbone embeddings for visual similarity** | One model serves classifier and similar-case search | FR-24 |
| **Record model name, version and dataset version** with each suggestion | Traceability | NFR-9 |

## 6. Not planned

- **GAN or synthetic image augmentation**: extra scope for two people (R3), and synthetic images make evaluation harder to trust.
- **Few-shot / meta-learning (MAML)**: more complex than a frozen backbone with little expected gain at our scale.
- **3D, CT and radiograph models**: out of scope for this release.

## 7. Open questions

| # | Question |
|---|---|
| Q-ML1 | How many experts' images will be ML-permitted and clean? Decides whether FR-31 is evaluated only or shown to users. |
| Q-ML2 | Are external animal-bone images acceptable to the experts as auxiliary training data? |
| Q-ML3 | Can the experts provide full texts or data for the Springer/Wiley papers in Section 3 (institutional access)? |
