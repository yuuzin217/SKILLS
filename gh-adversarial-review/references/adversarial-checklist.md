# Adversarial Verification Checklist

Falsification prompts only. Follow staged reading in `SKILL.md`: start with ≤3 prioritized sections; add sections only for concrete cross-cutting risk or an untestable material claim; do not widen for loose topical resemblance. Ungrounded answers are hypotheses—promote only under `SKILL.md` gates (`confirmed` / `strongly supported`).

## Requirements and invariants

- Which acceptance criterion fails if an explicitly out-of-scope input still reaches the new path?
- Which invariant breaks when a prerequisite the PR treats as already true is false (missing row, unset flag, partial backfill)?
- What single realistic request makes two stated requirements conflict (e.g. “always succeed” vs “never double-apply”)?
- Can the PR’s happy-path story hold while a quieter guarantee (ordering, uniqueness, retention) fails?
- If prior review called the change “safe,” which concrete scenario forces that conclusion to be withdrawn?

## Boundary values and representations

- What breaks at zero, empty, max-int/max-decimal, DST/timezone edges, or off-by-one windows the tests never set?
- Can two values that compare equal in one representation (string trim, float, money minor units, Unicode normalization) diverge after persistence or API round-trip?
- Does truncation, rounding, or serialization drop or reorder fields the invariant depends on?
- Which sentinel (`null`, omitted key, `0`, epoch, empty array) takes a branch the claim treats as impossible?
- For time, money, or quota math: which input makes sign, precision, or period-boundary logic disagree with the stated formula?

## State transitions

- Can an event arrive for a state the handler no longer allows (duplicate create, update-after-delete, cancel-after-complete)?
- Can a legal transition be applied twice and leave durable state that violates the model?
- What if the transition is accepted locally but a dependent projection or cache still shows the prior state?
- Can retry, an admin tool, or a direct write reach an intermediate state the API never exposes?
- What if a destructive transition runs while a reader or worker still holds the pre-destruction snapshot?

## Concurrency and ordering

- Can two concurrent updates produce a lost update?
- Can both racers’ read-modify-write succeed when the claim requires a single winner?
- What if messages, webhooks, or jobs are reordered, duplicated, or delayed past the assumed window?
- Can a stale read decide a write that overwrites a newer committed value?

## Retries and idempotency

- What happens if the database commit succeeds but acknowledgment fails?
- Can a retried request with the same business intent create a second side effect because the idempotency key is missing, scoped too narrowly, or recorded too late?
- What if the client retries with a different request id but the same payload, or the same id with a mutated payload?
- Does “at least once” delivery plus non-idempotent work falsify an “exactly once” claim in the PR or tests?

## Partial failures

- Can an external side effect succeed while local persistence fails?
- If local persistence succeeds and the external call fails, what inconsistent user-visible or durable state remains (and is compensation/replay defined)?
- Can a multi-step workflow commit step N and crash before step N+1, leaving a state no recovery path repairs?
- What if one replica or shard applies the change and another never does?

## Authorization and tenant isolation

- Can authorization be bypassed through a child resource, nested ID, batch endpoint, or alternate verb on the same object?
- What if the caller authenticates as tenant A but a secondary field names tenant B’s resource?
- Can a role that may read still trigger a mutating side path (export, reindex, webhook replay, admin debug)?
- Does a shared file, queue message, or cache key leak or mutate across tenants when only the top-level row is filtered?

## Data integrity and transactions

- What if two writes that must be atomic are split across transactions, connections, or services?
- Can a constraint enforced only in application code still be violated by a concurrent writer or bulk job?
- What remains after rollback following a non-transactional side effect (email sent, charge captured, object uploaded)?
- Can pre-migration rows violate the invariant the new code now assumes for every record?

## Compatibility, migrations, deployment, and rollback

- Can old and new application versions safely run at the same time?
- If the migration runs forward but the app rolls back, what reads/writes fail or corrupt against the interim schema?
- What breaks if expand/contract order is inverted (code expects a column/flag before it exists, or drops it while old code still writes)?
- What if dual-write or dual-read is only half-applied during deploy?

## Resource exhaustion and performance

- What happens when batch, fan-out, or recursion size is 10×–100× the example in the PR?
- Can a single request hold locks, connections, or memory long enough to stall unrelated work sharing the pool?
- What if retries, webhooks, or pagination that never terminates cleanly hammer a path treated as “cheap”?
- Does pagination, filtering, or aggregation degrade to a full scan on the hot tenant or table this change targets?

## Observability and recovery

- What failure leaves no useful log, metric, or trace until user impact accumulates?
- What if the alerting condition uses the same signal the bug corrupts?
- Can a poisoned message, row, or object block the consumer forever with no dead-letter or quarantine path?
- After manual repair, can replay or catch-up reintroduce the same corruption?

## Test validity

- Would the regression test still pass if the protected branch were removed?
- Does a mock provide stronger guarantees than the production dependency?
- Can the test pass by asserting on mocks, call counts, or snapshots while the real invariant is unchecked?
- Does setup seed only the happy-path fixture, so boundary, race, or failure-injection paths cannot fail the suite?
- If CI is green, which claim is actually proved—and which claims remain untested assertions in the PR text?
