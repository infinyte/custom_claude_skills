# Vertical Slice Examples

Two worked examples using the same feature — a URL Shortener API — in two different stacks.
The first is written in a .NET / C# / xUnit idiom. The second is written in a Python / FastAPI /
pytest idiom. They exist to show that the workflow is stack-agnostic; adapt the naming and layer
vocabulary to your repository's conventions.

---

## Example 1 — URL Shortener API (.NET-flavored)

### Feature

Allow a client to create a shortened URL through a REST API.

### Requirements

- REQ-001: The system shall allow a client to submit a valid long URL and receive a short code.
- REQ-002: The system shall persist the mapping between the short code and the long URL.
- REQ-003: The system shall return the short URL in the response.
- REQ-004: The system shall reject requests where the URL is missing or not a valid absolute HTTP/HTTPS URL.
- REQ-005: The system shall increment a click counter each time a short code is resolved.

### Acceptance Criteria

- AC-001: Given a valid long URL, when the request is submitted, then the mapping is persisted and a short URL is returned.
- AC-002: Given a request with a missing or malformed URL, when submitted, then a validation error is returned.
- AC-003: Given a resolved short code, when the client is redirected, then the click count for that code is incremented.

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

- CreateShortUrl_WithValidUrl_ReturnsCreatedResponse
- CreateShortUrl_WithValidUrl_PersistsMapping
- CreateShortUrl_WithValidUrl_ReturnsShortUrl

#### Expected Layers Touched

- API endpoint
- Request validation
- Short-code generator
- Repository
- Database
- OpenAPI documentation

#### Documentation Updates Required

- API docs
- OpenAPI file
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

- CreateShortUrl_MissingUrl_Returns400
- CreateShortUrl_NotAbsoluteUrl_Returns400
- CreateShortUrl_UnsupportedScheme_ReturnsValidationError

#### Expected Layers Touched

- API endpoint
- Validation layer
- Error response contract
- OpenAPI documentation

#### Documentation Updates Required

- API error response docs
- OpenAPI validation schema

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

- ResolveShortCode_WhenExists_IncrementsClickCount
- ResolveShortCode_MultipleHits_AccumulatesCount
- ResolveShortCode_WhenUnknown_ReturnsNotFoundAndDoesNotIncrement

#### Expected Layers Touched

- API endpoint
- Application service
- Repository
- Documentation

#### Documentation Updates Required

- Click-count behavior docs
- Data flow diagram, if present

---

## Example 2 — URL Shortener API (Python / FastAPI-flavored)

Same feature, same slices, restated in a Python idiom so the test names and layer vocabulary map
cleanly to a `FastAPI` + `pytest` project.

### VS-001 - Create Short URL Happy Path

#### Test Plan

- test_create_short_url_with_valid_url_returns_201
- test_create_short_url_with_valid_url_persists_mapping
- test_create_short_url_with_valid_url_returns_short_url_in_body

#### Expected Layers Touched

- FastAPI route
- Pydantic request/response models
- Short-code generator
- Repository (SQLAlchemy or equivalent)
- Database
- OpenAPI schema (auto-generated)

### VS-002 - Invalid URL Rejection

#### Test Plan

- test_create_short_url_missing_url_returns_422
- test_create_short_url_not_absolute_returns_422
- test_create_short_url_unsupported_scheme_returns_validation_error

#### Expected Layers Touched

- FastAPI route
- Pydantic validators
- Error response contract
- OpenAPI schema

### VS-003 - Click Counting

#### Test Plan

- test_resolve_short_code_when_exists_increments_click_count
- test_resolve_short_code_multiple_hits_accumulates_count
- test_resolve_short_code_when_unknown_returns_404_and_does_not_increment

#### Expected Layers Touched

- FastAPI route
- Application service
- Repository
- Documentation

---

## Notes on Adapting to Other Stacks

The workflow is language-agnostic. When adapting:

- Keep the slice as the smallest independently testable increment of observable behavior.
- Choose test names that read like specifications in your language's idiomatic style.
- Map "layers touched" to your stack's conventions (controllers vs. routes, repositories vs. DAOs,
  handlers vs. services, etc.).
- Keep tracking files (`FEATURES.md`, `todo.md`, `implemented.md`) identical regardless of stack.
