# Plan: Fix Future-Edge Combination Detection in klassR

## Objective

Prevent `update_klass()` from returning `NA` with `combine = FALSE` when a future graph transition incorrectly marks an otherwise valid code update as combined.

## Reproductions

Use the existing examples in `dev/issue-reproduction/klass_code_update.R` to demonstrate the issue:

- Lyngen: `5424 -> 5536` in 2024, followed by a future same-code name change in 2026.
- Trondheim: `1601 -> 5001` in 2018, followed by a future `5030 -> 5001` code combination in 2020.
- Unchanged Lyngen and Stavanger controls.

Expected behavior for historical lookups:

- Lyngen, target 2025: return `5536` with `combine = FALSE`.
- Trondheim, target 2019: return `5001` with `combine = FALSE`.
- Existing controls must remain unchanged.

## Investigation

1. Locate the implementation of `update_klass()`.
2. Trace how the supplied graph is traversed relative to `date`.
3. Identify where `combined` is calculated.
4. Determine whether edges with `changeOccurred > date` are included in traversal or combination detection.
5. Confirm whether the current logic treats all graph transitions alike, including name changes and code changes.

## Proposed Fix

Restrict traversal and combination detection to graph transitions valid at or before the requested target date.

The implementation should:

- Ignore edges with `changeOccurred > date`.
- Preserve transitions occurring exactly on `date`.
- Calculate `combined` from valid historical source-code relationships only.
- Avoid treating same-code node-version changes, such as name changes, as code combinations.

Prefer implementing this in the owning `klassR` abstraction rather than requiring callers to prune graph edges manually.

## Tests

Add focused tests for:

1. Lyngen future name change:
   - Original graph, target 2025, `combine = FALSE` returns `5536`.
2. Trondheim future code combination:
   - Original graph, target 2019, `combine = FALSE` returns `5001`.
3. Target-date boundary:
   - A transition occurring exactly on the target date is included.
4. Unchanged code with future node changes:
   - No false combination is reported.
5. Genuine historical combination:
   - A combination valid on or before the target date still returns `NA` with `combine = FALSE`.
6. `combine = TRUE`:
   - Existing behavior remains compatible.

## Validation

Run the package test suite and the reproduction script:

```r
Rscript klassr_code_update.R
````

Confirm that:

Historical valid updates no longer return false NA values.
Genuine combinations are still detected.
Future graph transitions do not affect earlier lookups.
No unrelated traversal behavior regresses.

## Acceptance Criteria
The fix is complete when all reproductions and regression tests pass, future edges cannot affect earlier lookups, and genuine combinations remain correctly identified.
