# Requirements specification (draft v0.1)

Status: draft for team review. Priorities use MoSCoW (Must / Should / Could / Won't) and describe the full product. The demo on 13/1/2027 covers only a subset: see [demo scope](demo-scope.md).

Related: [demo scope](demo-scope.md), [data schema](data-schema.md), [image classifier: datasets and techniques](ml-techniques.md).

## 1. Purpose

Skeletal trauma is hard to interpret: the analyst must decide what kind of trauma it is, when it happened (antemortem, perimortem, postmortem) and whether it is trauma at all, because taphonomic damage, anatomical variation and disease can look similar.

The app supports this work in two ways (from the project brief):

1. **Guide** users in describing and measuring a skeletal lesion and recording its type and timing.
2. **Compare**: show images of comparable published cases, based on the user's answers or keyword searches.

The app assists; **the expert always decides**. Every suggestion can be overridden or answered with "uncertain".

## 2. Users and roles

| Role | Who | Can |
|---|---|---|
| User | Researchers (anthropologists, archaeologists) and forensic experts | Describe own lesions in the guided form, attach photos, search and compare published cases, see suggestions, edit and export reports, submit a case for publication |
| Curator | Domain experts who maintain the reference database | Everything a user can, plus: import and edit published cases, review submitted cases (edit, approve, reject), manage image licences |
| Administrator | Team member or lab lead | Create accounts and assign roles |

Users only see their own unpublished cases. Published cases are visible to all logged-in users.

## 3. Functional requirements

### 3.1 Accounts

| ID | Requirement | Priority |
|---|---|---|
| FR-1 | Users log in with username and password. | Must |
| FR-2 | Each account has one role: user, curator or administrator. Pages and actions are restricted by role. | Must |
| FR-3 | Administrators create, deactivate and change the role of accounts. | Must |

### 3.2 Guided lesion description

| ID | Requirement | Priority |
|---|---|---|
| FR-10 | A user creates a case and describes one or more lesions through a step-by-step form following the schema categories: individual, anatomical location, documentation, morphology (per mark), measurements, timing and healing, interpretation. | Must |
| FR-11 | Choice fields offer the controlled vocabularies from the data schema, and always offer "uncertain" / "not observable" where applicable. | Must |
| FR-12 | Each step shows short guidance text explaining the terms (e.g. what perimortem features look like), based on the Scianò et al. (2020) criteria. | Should |
| FR-13 | Users can save a partly completed case and continue later. | Must |
| FR-14 | Users can list, reopen, edit and delete their own cases. | Must |
| FR-15 | Users enter measurements as numbers in millimetres or degrees, per mark or per lesion. | Must |
| FR-16 | Users attach photos (JPEG/PNG) to a lesion. | Must |
| FR-17 | Users measure on a photo: calibrate against the photo's scale bar, then click two points to get a length in mm, which is saved as a measurement. | Should |

### 3.3 Search and comparison

| ID | Requirement | Priority |
|---|---|---|
| FR-20 | Users search published cases by keyword across text fields and citation. | Must |
| FR-21 | Users filter published cases by bone, side, portion, timing, trauma category and subtype, lesion pattern and timing features. | Must |
| FR-22 | Results show a thumbnail, key fields and the citation; opening a result shows the full record and its images with attribution. | Must |
| FR-23 | From a user's lesion, the app lists the most similar published lesions, ranked by how many structured fields match, and shows which fields matched. | Must |
| FR-24 | Similarity also uses visual similarity of images (image embeddings). | Could |

### 3.4 Suggested type and timing

| ID | Requirement | Priority |
|---|---|---|
| FR-30 | The app suggests trauma category and timing from the user's answers using explicit rules (e.g. healing present suggests antemortem), shows the rules that fired, and returns "uncertain" when rules conflict or answers are missing. | Must |
| FR-31 | An image classifier (pretrained model plus small trained classifier) suggests trauma category and timing from the lesion photo, with a confidence score. | Should |
| FR-32 | Suggestions are clearly labelled as suggestions. The user's own interpretation is stored separately and is what the report uses. | Must |
| FR-33 | The classifier is evaluated with macro-F1 and a confusion matrix, splitting train/test by individual and publication, and compared with the rule-based baseline. | Should |

### 3.5 LLM assistance

All LLM output is a draft that a person must confirm or edit before it is saved.

| ID | Requirement | Priority |
|---|---|---|
| FR-40 | The LLM drafts report text from the structured lesion description. | Should |
| FR-41 | The LLM suggests keywords/tags from free-text fields; the user accepts or rejects each tag. | Should |
| FR-42 | Curators can paste publication text and the LLM drafts a case record in the schema, which the curator corrects before saving. | Could |
| FR-43 | LLM output is never used as a training label for the classifier. | Must |

### 3.6 Reports

| ID | Requirement | Priority |
|---|---|---|
| FR-50 | The app generates a report draft for a case: structured description, measurements, photos, the user's interpretation, and comparable published cases with citations. | Must |
| FR-51 | The user edits the report text in the app before export. | Must |
| FR-52 | The report exports to PDF. | Must |
| FR-53 | The report exports to DOCX. | Should |

### 3.7 Curation and publishing

| ID | Requirement | Priority |
|---|---|---|
| FR-60 | Curators import published cases from the experts' dataset (spreadsheet), with validation errors reported per row. | Must |
| FR-61 | Curators create and edit published cases through the same form. | Must |
| FR-62 | Users submit a saved case for publication. | Must |
| FR-63 | Curators review submitted cases: edit fields, then approve (case becomes published) or reject with a comment visible to the submitter. | Must |
| FR-64 | Each image has a licence. Images whose licence does not allow display are not shown; only images allowed for ML are used in training. | Must |
| FR-65 | Images with drawn annotations (arrows, circles) can have a clean version; only clean versions are used for similarity and training. | Should |
| FR-66 | Every change to a published case records who made it and when. | Must |

### 3.8 Language

| ID | Requirement | Priority |
|---|---|---|
| FR-70 | The interface is in English. | Must |
| FR-71 | The interface is also available in Italian, switchable by the user. Vocabulary terms are translated; data from publications stays in its original language. | Should |

## 4. Non-functional requirements

| ID | Requirement | Priority |
|---|---|---|
| NFR-1 | **Deployment**: the whole system starts on a laptop with one command (Docker Compose). The demo does not depend on hosting. | Must |
| NFR-2 | **Offline core**: form, search, comparison, rule-based suggestion and reports work without internet. Only LLM features need it. | Must |
| NFR-3 | **Browser**: current desktop Chrome and Firefox. | Must |
| NFR-4 | **Performance**: search and similar-case results return within 2 seconds for 1,000 published lesions. | Should |
| NFR-5 | **Security**: passwords stored hashed; all actions checked against the user's role on the server, not only hidden in the UI. | Must |
| NFR-6 | **Privacy**: before LLM features send a description to the hosted provider, the user is told what is sent. Personal data (names, case numbers) is not sent. A user can choose not to use LLM features for a case. | Must |
| NFR-7 | **Secrets**: the LLM API key is read from configuration, never committed to the repository. | Must |
| NFR-8 | **Copyright**: every published image shows its source citation; licence rules (FR-64) are enforced by the server. | Must |
| NFR-9 | **Traceability**: every suggestion shown (rule, classifier or LLM) records its source and version with the case. | Should |
| NFR-10 | **Maintainability**: vocabularies are stored as data so curators can extend them without code changes. | Should |
| NFR-11 | **Testing**: automated tests for rules, similarity scoring, import validation and role checks; manual test script for the main user stories. | Must |
| NFR-12 | **Documentation**: installation manual in the README; the report covers requirements, user stories, architecture, testing and validation. | Must |

## 5. User stories

**US-1 Describe a lesion** (Must) — As a researcher, I want to describe a lesion step by step, so that I record everything relevant in standard terms.
- Given I am logged in, when I create a case, I am led through each schema category in order.
- I can answer "uncertain" or "not observable" wherever a value may be unknown.
- I can save at any step and continue later from the same step.

**US-2 Attach and measure photos** (Must; on-photo measuring Should) — As a researcher, I want to attach photos and record measurements, so that my description is documented.
- I can upload JPEG/PNG photos to a lesion and see them in the case.
- I can type measurements in mm per mark or per lesion.
- (Should) After calibrating on the scale bar, I click two points and the length in mm is saved as a measurement.

**US-3 Search published cases** (Must) — As a researcher, I want to search published cases by keyword and filters, so that I find comparable lesions.
- Searching "cut mark femur" returns lesions matching those words.
- Filters narrow results and can be combined.
- Each result shows an image (if licence allows), key fields and the citation.

**US-4 See similar cases** (Must) — As a researcher, I want to see published lesions similar to mine, so that I can compare morphology and interpretation.
- From my lesion, I see a ranked list of published lesions with the matched fields highlighted.
- I can open each one to see its full record and images.

**US-5 Review a suggestion** (Must; classifier Should) — As a researcher, I want a suggested trauma type and timing with its reasons, so that I can check my own interpretation.
- I see the rule-based suggestion with the rules that produced it, or "uncertain".
- (Should) I also see the classifier suggestion with a confidence score.
- I record my own interpretation; the suggestion never overwrites it.

**US-6 Produce a report** (Must; DOCX and LLM text Should) — As a researcher, I want an editable report draft, so that I can document the analysis quickly.
- I can generate a draft from my case, edit the text, and export it to PDF.
- (Should) I can export to DOCX, and ask the LLM to draft the narrative text, which I then edit.

**US-7 Submit for publication** (Must) — As a forensic expert, I want to submit my case to the reference database, so that others can compare against it.
- I can submit a saved case; its status shows "submitted".
- I see the curator's decision and any rejection comment.

**US-8 Review submissions** (Must) — As a curator, I want to correct and approve submitted cases, so that the reference database stays reliable.
- I see a list of submitted cases.
- I can edit fields, then approve (case becomes published) or reject with a comment.
- The change history shows who changed what and when.

**US-9 Import the experts' dataset** (Must) — As a curator, I want to import published cases from a spreadsheet, so that the database is filled without retyping.
- Valid rows are imported; invalid rows are listed with the reason.
- Importing the same file twice does not create duplicates.

**US-10 Manage licences** (Must) — As a curator, I want to set each image's licence, so that the app only shows and uses images we are allowed to.
- Images without display permission are not shown to users.
- Only ML-permitted, clean images are used for training.

**US-11 Manage accounts** (Must) — As an administrator, I want to create accounts with roles, so that only the right people can curate.

**US-12 Draft a case from a paper** (Could) — As a curator, I want the LLM to draft a record from publication text, so that entering new cases is faster.
- The draft opens in the form, and nothing is saved until I confirm.

**US-13 Use the app in Italian** (Should) — As an Italian lab user, I want the interface in Italian.

## 6. Constraints and assumptions

- Team of 2; delivery 12/1/2027, demo 13/1/2027; three sprints (23/11–3/12, 4/12–21/12, 21/12–11/1). The demo is limited to the guided form, search and similar cases ([demo scope](demo-scope.md)).
- The published dataset (target 100+ lesions) comes from the Bologna/Ferrara experts and has been requested through the professor. The team does not enter it manually; for the demo it is loaded with a seed script.
- The LLM is a hosted API (Claude or OpenAI); its cost must stay within a student budget.
- The image classifier needs enough licensed, ML-permitted images; with few images it may only be evaluated, not relied on.

## 7. Out of scope for this release (Won't)

- Public hosting (the demo runs locally).
- Tablet and mobile layouts.
- Two-curator review and full version history with revert.
- Measurement on radiographs or CT data.
- Automatic decisions: the app never finalises an interpretation.

## 8. Risks and open questions

| # | Item | Impact | Mitigation / question |
|---|---|---|---|
| R1 | Experts' dataset arrives late, is smaller than 100, or uses a different structure | Search demo, classifier | Ask experts now for format and date; build import against a sample; seed 5–10 cases ourselves as fallback |
| R2 | Too few licensed images for a classifier | FR-31, FR-33 | Classifier is Should; rule-based suggestion (Must) remains |
| R3 | Scope is large for 2 people (classifier, LLM, Italian UI, photo measuring) | Deadline | Demo limited to form, search and similar cases ([demo scope](demo-scope.md)); everything else after the demo |
| R4 | Sending forensic case descriptions to a hosted LLM may conflict with lab rules | NFR-6 | Ask the experts whether hosted processing is acceptable for forensic cases |
| Q1 | Who will be curators and administrators during the demo? | Accounts | Ask the experts |
| Q2 | Are the rule-based timing criteria acceptable as written by the team, or must the experts write/approve them? | FR-30 | Ask the experts |
| Q3 | Which Italian terminology should be used for vocabularies? | FR-71 | Ask the experts |
