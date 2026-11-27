CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE sex_enum AS ENUM (
    'male',
    'probable male',
    'female',
    'probable female',
    'indeterminate',
    'NR',
    'NA'
);

CREATE TYPE age_category_enum AS ENUM (
    'fetus',
    'infant',
    'child',
    'adolescent',
    'young adult',
    'middle adult',
    'old adult',
    'adult (unspecified)',
    'NR',
    'NA'
);

CREATE TYPE bone_enum AS ENUM (
    'frontal',
    'parietal',
    'occipital',
    'temporal',
    'sphenoid',
    'zygomatic',
    'maxilla',
    'nasal',
    'mandible',
    'hyoid',
    'cervical vertebra',
    'thoracic vertebra',
    'lumbar vertebra',
    'sacrum',
    'coccyx',
    'rib',
    'sternum',
    'clavicle',
    'scapula',
    'humerus',
    'radius',
    'ulna',
    'carpal',
    'metacarpal',
    'hand phalanx',
    'os coxae',
    'femur',
    'patella',
    'tibia',
    'fibula',
    'tarsal',
    'metatarsal',
    'foot phalanx',
    'NR',
    'NA'
);

CREATE TYPE side_enum AS ENUM (
    'left',
    'right',
    'midline',
    'bilateral',
    'NR',
    'NA'
);

CREATE TYPE portion_enum AS ENUM (
    'proximal epiphysis',
    'proximal metaphysis',
    'diaphysis proximal third',
    'diaphysis middle third',
    'diaphysis distal third',
    'diaphysis (unspecified)',
    'distal metaphysis',
    'distal epiphysis',
    'NR',
    'NA'
);

CREATE TYPE aspect_enum AS ENUM (
    'anterior',
    'posterior',
    'medial',
    'lateral',
    'superior',
    'inferior',
    'proximal',
    'distal',
    'ectocranial',
    'endocranial',
    'internal',
    'external',
    'NR',
    'NA'
);

-- 3. Examination & Lesion Morphology
CREATE TYPE examination_method_enum AS ENUM (
    'macroscopic',
    'magnification (lens)',
    'stereomicroscope',
    'SEM',
    'radiograph',
    'CT',
    'micro-CT',
    'histology',
    'NR',
    'NA'
);

CREATE TYPE lesion_pattern_enum AS ENUM (
    'cut mark',
    'chop mark',
    'puncture',
    'depressed fracture',
    'linear fracture',
    'comminuted fracture',
    'radiating fracture',
    'concentric fracture',
    'penetrating defect',
    'projectile wound',
    'perforation',
    'other',
    'NR',
    'NA'
);

CREATE TYPE cross_section_enum AS ENUM (
    'V-shaped',
    'U-shaped',
    'flat-bottomed',
    'W-shaped',
    'irregular',
    'NR',
    'NA'
);

CREATE TYPE margin_enum AS ENUM (
    'sharp',
    'irregular',
    'roughened',
    'smoothed',
    'bevelled',
    'polished',
    'NR',
    'NA'
);

-- 4. Timing, Healing & Differential Diagnosis
CREATE TYPE timing_enum AS ENUM (
    'antemortem',
    'perimortem',
    'postmortem',
    'uncertain',
    'NR',
    'NA'
);

-- Healing stages after Scianò et al. (2020)
CREATE TYPE healing_stage_enum AS ENUM (
    'none',
    '1 hematoma',
    '2 cellular proliferation / periostitis',
    '3 soft callus',
    '4 hard callus',
    '5 remodelling',
    'NR',
    'NA'
);

CREATE TYPE timing_feature_enum AS ENUM (
    -- perimortem
    'irregular edges',
    'hinging fragments',
    'cortical flakes along margins',
    'smoothed margins',
    'radiating fractures',
    'concentric fractures',
    'staining preserved along margins',
    'plastic deformation',
    -- postmortem
    'lighter-coloured margins',
    'regular fragments',
    'gnawing / carnivore punctures',
    'other taphonomic evidence',
    -- antemortem
    'periosteal reaction',
    'callus',
    'rounded/remodelled margins',
    'bridging',
    'NR',
    'NA'
);

CREATE TYPE trauma_category_enum AS ENUM (
    'blunt force',
    'sharp force',
    'sharp-blunt',
    'projectile',
    'not trauma',
    'uncertain',
    'NR',
    'NA'
);

CREATE TYPE trauma_subtype_enum AS ENUM (
    -- sharp force
    'cut (incised)',
    'stab/puncture',
    'saw',
    -- sharp-blunt
    'chop',
    -- blunt force
    'depressed fracture',
    'linear fracture',
    'comminuted fracture',
    'other',
    -- projectile
    'gunshot',
    'arrowhead',
    'NR',
    'NA'
);

CREATE TYPE differential_enum AS ENUM (
    'taphonomic (carnivore gnawing)',
    'taphonomic (rodent gnawing)',
    'taphonomic (root etching)',
    'taphonomic (excavation damage)',
    'taphonomic (dry-bone breakage)',
    'taphonomic (weathering)',
    'anatomical variation',
    'bone disease',
    'NR',
    'NA'
);

-- 5. Measurements, Media & Licensing
CREATE TYPE quantity_enum AS ENUM (
    'length',
    'width',
    'depth',
    'diameter',
    'area',
    'fracture line extent',
    'callus length',
    'callus width',
    'displacement',
    'angulation',
    'rotation',
    'distance from landmark',
    'NR',
    'NA'
);

CREATE TYPE image_view_enum AS ENUM (
    'overview',
    'detail',
    'cross-section',
    'radiograph',
    'CT slice',
    'micrograph',
    'NR',
    'NA'
);

CREATE TYPE licence_enum AS ENUM (
    'CC BY',
    'CC BY-NC',
    'CC BY-NC-ND',
    'publisher permission',
    'all rights reserved',
    'unknown',
    'NR',
    'NA'
);

CREATE TYPE yes_no_nr_enum AS ENUM ('yes', 'no', 'NR');
CREATE TYPE yes_no_enum AS ENUM ('yes', 'no');
CREATE TYPE record_source_enum AS ENUM ('published', 'user_case');
CREATE TYPE cause_of_death_enum AS ENUM ('yes', 'possible', 'no', 'uncertain', 'NR');
CREATE TYPE interpretation_by_enum AS ENUM ('source_authors', 'expert', 'user');
CREATE TYPE measurement_unit_enum AS ENUM ('mm', 'deg', 'mm2');
CREATE TYPE measurement_status_enum AS ENUM ('reported', 'NR', 'NA');
CREATE TYPE image_usable_enum AS ENUM ('display_and_ml', 'display_only', 'ml_only', 'none');

CREATE TABLE publication (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    citation text NOT NULL,
    authors text,
    year int,
    title text,
    journal text,
    doi text UNIQUE
);

CREATE TABLE individual (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    publication_id uuid REFERENCES publication (id) ON DELETE SET NULL,
    label text,
    sex sex_enum,
    age_category age_category_enum,
    age_text text,
    site text,
    country text,
    chronology_text text,
    chronology_start_year int,
    chronology_end_year int,
    other_trauma text,
    CONSTRAINT chk_chronology_range CHECK (
        chronology_start_year IS NULL
        OR chronology_end_year IS NULL
        OR chronology_start_year <= chronology_end_year
    )
);

CREATE TABLE lesion (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    individual_id uuid NOT NULL REFERENCES individual (id) ON DELETE CASCADE,
    record_source record_source_enum NOT NULL,
    case_ref text,

    -- Anatomical location
    bone bone_enum,
    side side_enum,
    portion portion_enum,
    aspects aspect_enum[],
    joint_involvement yes_no_nr_enum DEFAULT 'NR',
    location_text text,

    -- Documentation
    examination_methods examination_method_enum[],
    preservation_text text,

    -- Morphology
    lesion_pattern lesion_pattern_enum,
    mark_count int,
    mark_count_status measurement_status_enum NOT NULL DEFAULT 'NR',
    fragmentation yes_no_nr_enum DEFAULT 'NR',
    deformation yes_no_nr_enum DEFAULT 'NR',
    morphology_text text,

    -- Timing and healing
    timing timing_enum,
    healing_present yes_no_nr_enum DEFAULT 'NR',
    healing_stage healing_stage_enum,
    timing_features timing_feature_enum[],
    complications_text text,

    -- Classification and interpretation
    trauma_category trauma_category_enum,
    trauma_subtype trauma_subtype_enum,
    differential differential_enum[],
    instrument_text text,
    dynamics_text text,
    vascular_involvement_text text,
    cause_of_death cause_of_death_enum DEFAULT 'NR',
    sequence_text text,
    interpretation_by interpretation_by_enum,
    interpretation_text text,

    CONSTRAINT chk_mark_count_status CHECK (
        (mark_count_status = 'reported' AND mark_count IS NOT NULL AND mark_count >= 0)
        OR (mark_count_status <> 'reported' AND mark_count IS NULL)
    ),
    CONSTRAINT chk_healing_stage_when_no_healing CHECK (
        healing_present <> 'no'
        OR healing_stage IS NULL
        OR healing_stage IN ('NA', 'none')
    )
);

CREATE TABLE mark (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    lesion_id uuid NOT NULL REFERENCES lesion (id) ON DELETE CASCADE,
    label text,
    orientation_text text,
    cross_section cross_section_enum,
    floor_text text,
    margins margin_enum[],
    flaking yes_no_nr_enum DEFAULT 'NR',
    description_text text
);

CREATE TABLE measurement (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    lesion_id uuid NOT NULL REFERENCES lesion (id) ON DELETE CASCADE,
    mark_id uuid REFERENCES mark (id) ON DELETE CASCADE,
    quantity quantity_enum NOT NULL,
    value numeric,
    unit measurement_unit_enum NOT NULL,
    status measurement_status_enum NOT NULL DEFAULT 'NR',
    note text,
    CONSTRAINT chk_measurement_value_status CHECK (
        (status = 'reported' AND value IS NOT NULL)
        OR (status <> 'reported' AND value IS NULL)
    )
);

CREATE TABLE image (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    lesion_id uuid NOT NULL REFERENCES lesion (id) ON DELETE CASCADE,
    publication_id uuid REFERENCES publication (id) ON DELETE SET NULL,
    figure_ref text,
    bucket text NOT NULL,
    object_key text NOT NULL,
    file_path text,
    view image_view_enum DEFAULT 'NR',
    has_scale yes_no_enum,
    has_annotations yes_no_enum,
    clean_version_id uuid REFERENCES image (id) ON DELETE SET NULL,
    licence licence_enum DEFAULT 'unknown',
    licence_note text,
    usable image_usable_enum NOT NULL DEFAULT 'none',
    CONSTRAINT uq_image_bucket_object UNIQUE (bucket, object_key),
    CONSTRAINT chk_image_not_self_clean CHECK (
        clean_version_id IS NULL OR clean_version_id <> id
    )
);

CREATE INDEX idx_individual_publication_id ON individual (publication_id);
CREATE INDEX idx_lesion_individual_id ON lesion (individual_id);
CREATE INDEX idx_lesion_filters ON lesion (
    bone,
    side,
    portion,
    timing,
    trauma_category,
    trauma_subtype,
    lesion_pattern
);
CREATE INDEX idx_mark_lesion_id ON mark (lesion_id);
CREATE INDEX idx_measurement_lesion_id ON measurement (lesion_id);
CREATE INDEX idx_measurement_mark_id ON measurement (mark_id);
CREATE INDEX idx_image_lesion_id ON image (lesion_id);
CREATE INDEX idx_image_publication_id ON image (publication_id);
CREATE INDEX IF NOT EXISTS idx_image_clean_version_id ON image (clean_version_id);
