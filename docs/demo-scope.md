# Demo scope (13/1/2027)

Status: draft for team review. This file narrows [requirements](requirements.md) to what the demo on 13/1/2027 must show. Requirement IDs refer to that file; nothing here changes the requirement text, only what is built first.

## 1. Goal

The demo shows the two core ideas of the project brief end to end:

1. **Guided description**: a researcher describes a lesion step by step and attaches photos.
2. **Comparison**: the app finds published lesions similar to it, by matching form answers and by visual similarity of photos, and lets the researcher search and filter the published cases.

Everything else moves to after the demo.

## 2. In the demo

| Area | Requirements | Notes |
|---|---|---|
| Guided form | FR-10, FR-11, FR-13, FR-14, FR-15, FR-16 | All schema steps, controlled vocabularies with "uncertain" / "not observable", save and continue, list/edit/delete own cases, typed measurements, photo upload |
| Guidance text | FR-12 | Stretch goal: short help text per step if time allows |
| Search and filters | FR-20, FR-21, FR-22 | Keyword search, combinable filters, result list with thumbnail and citation, full record view |
| Similar cases (fields) | FR-23 | Ranked by number of matching structured fields, matched fields highlighted |
| Similar cases (images) | FR-24 | Image embeddings from a pretrained model, stored with pgvector; nearest published images to the user's photo |
| Image licences | FR-64 (display part), NFR-8 | Only images whose licence allows display are shown, with citation; only ML-permitted images get embeddings |
| Data loading | replaces FR-60 for now | One-off seed script loads the professor's dataset into the database and MinIO |
| Deployment | NFR-1, NFR-2, NFR-3, NFR-4 | One `docker compose up`; works offline, so the embedding model is bundled in `./models`, not downloaded at runtime |
| Quality | NFR-11 (partly), NFR-12 | Automated tests for similarity scoring and the seed script's validation; README with install steps |

Demo user stories: **US-1**, **US-2** (without on-photo measuring), **US-3**, **US-4**.

## 3. After the demo

| Area | Requirements | Why it can wait |
|---|---|---|
| Accounts and roles | FR-1, FR-2, FR-3, NFR-5, US-11 | Demo runs as a single local user |
| On-photo measuring | FR-17 | Typed measurements cover the demo |
| Suggested type and timing | FR-30, FR-31, FR-32, FR-33, US-5 | Rule set needs expert approval (Q2); classifier needs enough licensed images (R2). Research notes: [ml-techniques](ml-techniques.md) |
| LLM assistance | FR-40, FR-41, FR-42, FR-43, NFR-6, NFR-7, US-12 | Not needed to show the core idea; open privacy question (R4) |
| Reports | FR-50, FR-51, FR-52, FR-53, US-6 | Comes after the description and comparison work |
| Curation and publishing | FR-60 (import UI), FR-61, FR-62, FR-63, FR-65, FR-66, US-7, US-8, US-9, US-10 | Seed script replaces the import UI; no roles in the demo |
| Italian interface | FR-71, US-13 | English only for the demo |
| Traceability, editable vocabularies | NFR-9, NFR-10 | Vocabularies stay as database enums for now |

## 4. Plan

| Sprint | Dates | Goal |
|---|---|---|
| 1 | 23/11–3/12 | Request the dataset; agree its format; API and database running with the schema (done); form skeleton for the first steps |
| 2 | 4/12–21/12 | Complete guided form with photo upload; seed script with the dataset (or a sample); search and filters |
| 3 | 21/12–11/1 (winter break, more hours) | Field-based similarity; image embeddings and visual similarity; tests, README, demo script and rehearsal |
