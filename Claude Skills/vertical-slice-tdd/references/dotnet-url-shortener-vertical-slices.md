# Example Vertical Slice Definition — URL Shortener (.NET / C# / xUnit)

This is a fully worked example of how to structure a small feature under the vertical-slice-TDD
workflow, written in a .NET idiom. The same feature is expressed in a Python idiom in
`python-url-shortener-vertical-slices.md`.

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

- CreateShortUrl_WithValidUrl_ReturnsCreatedResponse
- CreateShortUrl_WithValidUrl_PersistsMapping
- CreateShortUrl_WithValidUrl_ReturnsShortUrl

#### Expected Layers Touched

- ASP.NET Core API endpoint (Minimal API or Controller)
- Request validation (FluentValidation or DataAnnotations)
- Short-code generator (application service)
- Repository (EF Core or Dapper)
- Database (SQL Server, PostgreSQL, or in-memory for tests)
- OpenAPI documentation (Swashbuckle)

#### Documentation Updates Required

- API docs
- OpenAPI schema
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
- Error response contract (ProblemDetails)
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

- API endpoint (redirect action)
- Application service
- Repository
- Documentation

#### Documentation Updates Required

- Click-count behavior docs
- Data flow diagram, if present
