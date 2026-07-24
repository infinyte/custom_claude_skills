# Example Vertical Slice Definition — URL Shortener (Python / FastAPI / pytest)

Same feature as `dotnet-url-shortener-vertical-slices.md`, restated in a Python idiom so the test
names, layer vocabulary, and dependency choices map to a real FastAPI project.

## Feature

Allow a client to shorten a long URL through a REST API and track click counts on the resulting
short link.

## Requirements

- REQ-001: The system shall allow a client to submit a valid long URL and receive a short code.
- REQ-002: The system shall persist the mapping between the short code and the long URL.
- REQ-003: The system shall return the short URL in the response.
- REQ-004: The system shall reject requests where the URL is missing or not a valid absolute HTTP/HTTPS URL.
- REQ-005: The system shall increment a click counter each time a short code is resolved.

## Acceptance Criteria

- AC-001: Given a valid long URL, when the request is submitted, then the mapping is persisted and a short URL is returned.
- AC-002: Given a request with a missing or malformed URL, when submitted, then a validation error is returned.
- AC-003: Given a resolved short code, when the client is redirected, then the click count for that code is incremented.

## Vertical Slices

### VS-001 - Create Short URL Happy Path

#### Goal

Allow creation of a short URL for a valid long URL through the API.

#### User / Business Value

Users can generate a shareable short link from a long URL.

#### Requirements Covered

- REQ-001
- REQ-002
- REQ-003

#### Acceptance Criteria Covered

- AC-001

#### Test Plan

- test_create_short_url_with_valid_url_returns_201
- test_create_short_url_with_valid_url_persists_mapping
- test_create_short_url_with_valid_url_returns_short_url_in_body

#### Expected Layers Touched

- FastAPI route (`POST /shorten`)
- Pydantic request/response models
- Short-code generator (service)
- Repository (SQLAlchemy or equivalent)
- Database (SQLite for tests, Postgres in prod)
- Auto-generated OpenAPI schema

#### Documentation Updates Required

- API docs (`docs/api.md`)
- OpenAPI schema (regenerate if committed)
- Short-URL creation sequence diagram, if present

### VS-002 - Invalid URL Rejection

#### Goal

Reject invalid or malformed URL submissions.

#### User / Business Value

Clients receive immediate feedback when their input is not a usable URL.

#### Requirements Covered

- REQ-004

#### Acceptance Criteria Covered

- AC-002

#### Test Plan

- test_create_short_url_missing_url_returns_422
- test_create_short_url_not_absolute_returns_422
- test_create_short_url_unsupported_scheme_returns_validation_error

#### Expected Layers Touched

- FastAPI route
- Pydantic validators (`HttpUrl`, custom `field_validator`)
- Error response contract (RFC 7807 / FastAPI default 422)
- OpenAPI schema

#### Documentation Updates Required

- API error response docs
- OpenAPI validation schema (regenerate if committed)

### VS-003 - Click Counting

#### Goal

Increment a click counter each time a short code is resolved.

#### User / Business Value

Owners of a short link can see how often it is used.

#### Requirements Covered

- REQ-005

#### Acceptance Criteria Covered

- AC-003

#### Test Plan

- test_resolve_short_code_when_exists_increments_click_count
- test_resolve_short_code_multiple_hits_accumulates_count
- test_resolve_short_code_when_unknown_returns_404_and_does_not_increment

#### Expected Layers Touched

- FastAPI route (`GET /{code}` redirect)
- Application service
- Repository
- Documentation

#### Documentation Updates Required

- Click-count behavior docs
- Data flow diagram, if present
