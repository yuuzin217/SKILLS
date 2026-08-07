# PR Review Checklist

Domain-specific review prompts. Follow staged reading in `SKILL.md`: start with ≤3 prioritized sections; add sections only for concrete cross-cutting risk or material finding verification; do not widen for loose topical resemblance. Ungrounded answers stay hypotheses—promote only under the formal finding gate in `SKILL.md`.

## Requirements and contracts

- Does the implementation satisfy stated acceptance criteria and linked issue scope?
- Do public API, event, or schema changes match documented contracts and caller expectations?
- Are implicit guarantees (ordering, uniqueness, retention, idempotency) preserved where callers depend on them?
- Does behavior diverge from PR description or issue text in a user-visible way?
- Are feature flags, rollout guards, or compatibility shims consistent with the stated rollout plan?

## Correctness and control flow

- Are all branches—including error, empty, and early-return paths—handled correctly?
- Can unreachable or dead branches hide missing handling for realistic inputs?
- Do boolean conditions, comparisons, and null/undefined checks match intended semantics?
- Are off-by-one, boundary, and loop-termination errors present at realistic inputs?
- Does control flow assume state that may not hold after concurrent or retried operations?

## Authorization and authentication

- Is every mutating and sensitive read path guarded by appropriate auth checks?
- Can a caller access or modify another principal's or tenant's data via alternate routes, nested IDs, or batch endpoints?
- Are role/permission checks applied at the correct layer—not only on the entry handler?
- Do service-to-service or background paths inherit the same authorization constraints as user-facing paths?
- Are session, token, or API-key validation failures handled without leaking protected data?

## Input validation and trust boundaries

- Are external inputs validated at trust boundaries before use in queries, commands, or side effects?
- Can malformed, oversized, or unexpected types bypass validation via nested objects or alternate encodings?
- Is user-controlled data safely parameterized in SQL, shell, path, URL, or template contexts?
- Are defaults and optional fields safe when omitted, null, or empty?
- Does the code trust client-supplied identifiers that should be server-derived or verified?

## Data integrity and transactions

- Are related writes that must succeed or fail together enclosed in a single transaction where required?
- Can partial updates leave durable state inconsistent with invariants?
- Are uniqueness, foreign-key, and check constraints relied on correctly—or only assumed in application code?
- Can concurrent writers violate invariants that lack database-level enforcement?
- After rollback or failure, is durable state still coherent with external side effects?

## Schema and migrations

- Are migrations backward-compatible with the currently deployed application version during rollout?
- Do expand/contract steps follow a safe order relative to code deployment?
- Can existing rows violate assumptions the new code makes about every record?
- Are default values, nullability, and indexes correct for new query patterns?
- Is there a documented or safe rollback path if migration and deploy diverge?

## Concurrency and ordering

- Can concurrent requests produce lost updates, duplicate creates, or inconsistent reads?
- Are shared resources protected where read-modify-write sequences are non-atomic?
- Can message, event, or job ordering assumptions be violated by retries, redelivery, or parallel workers?
- Does code assume a happens-before relationship that the runtime does not guarantee?
- Can stale reads lead to incorrect writes or authorization decisions?

## Retries and idempotency

- If work is retried after partial success, can side effects be applied more than once?
- Are idempotency keys, deduplication, or uniqueness guards present where at-least-once delivery applies?
- Is the idempotency record written at the correct point relative to irreversible effects?
- Can client retries with the same or different request identifiers produce duplicate outcomes?
- Do background jobs acknowledge only after durable, idempotent completion?

## Error handling and partial failures

- Are errors propagated with enough context for callers without exposing secrets?
- On failure mid-workflow, is cleanup, compensation, or retry behavior defined and correct?
- Can an external call succeed while local persistence fails—or the reverse—leaving inconsistent state?
- Are swallowed, generic, or misclassified errors masking recoverable vs fatal failures?
- Do finally/defer/cleanup paths run correctly when earlier steps fail?

## Compatibility and API changes

- Do response shape, status codes, and error formats remain compatible for existing clients?
- Are breaking changes versioned, flagged, or documented as required?
- Can old clients send payloads the new server mishandles—or new clients talk to an old server during deploy?
- Are serialized formats (JSON field names, enums, timestamps) stable across versions?
- Do stored blobs, cache entries, or queued messages remain readable after the change?

## Deployment and rollback

- Can old and new code safely run concurrently during rolling deploy?
- Does the change require coordinated deploy of multiple services, config, or migrations?
- If rollback occurs after a forward migration, what reads/writes fail or corrupt?
- Are environment-specific settings, secrets, and feature flags updated in the correct order?
- Does the change affect startup, health checks, or readiness in a way that blocks deploy?

## Resource usage and performance

- Can realistic input size, batch size, or fan-out cause unacceptable latency, memory, or connection use?
- Are N+1 queries, unbounded scans, or unbounded in-memory aggregation introduced?
- Can locks, long transactions, or blocking I/O on hot paths stall unrelated work?
- Are caches, pools, and rate limits sized appropriately for the new behavior?
- Does pagination or streaming terminate correctly under load?

## Observability and recovery

- Are failures logged with actionable context without leaking sensitive data?
- Will operators detect new failure modes via existing metrics, alerts, or traces?
- Is there a recovery path for poison messages, stuck jobs, or partially applied state?
- Do new code paths emit signals needed to debug production incidents?
- Can manual repair or replay safely fix state without reintroducing the defect?

## Test validity and coverage

- Do tests assert the behavior under review—not only mocks or implementation details?
- Would tests fail if the defect were present (regression signal)?
- Are critical paths, error paths, and boundary conditions covered proportionally to risk?
- Do tests depend on ordering, timing, or environment assumptions that hide flakes or races?
- Does CI exercise the changed surface, or only unrelated suites?

## Configuration and generated artifacts

- Are config defaults safe in all supported environments?
- Do generated files, lockfiles, or vendored updates match intentional dependency changes?
- Can misconfiguration in production bypass safeguards present in development?
- Are secrets, credentials, or internal endpoints excluded from committed config?
- Do build/codegen outputs stay in sync with source definitions?
