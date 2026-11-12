# GraphQL in Flutter: small learning repo

Small open-source Flutter repo to show how to use GraphQL in Flutter, for
people who want to learn. Beginner friendly, easy to read. The goal is
clear, minimal examples, not a full app.

## Scope (do not exceed)
- API: https://countries.trevorblades.com/ (public, no token).
  Check that it responds before building. If it is down, stop and tell me.
- Package: `graphql_flutter`. Check its current README for the setup
  instead of relying on memory for API names.
- No codegen, no state management library, no architecture layers, no
  extra packages, no tests, no custom theming. Plain Material widgets.
- Keep each file short and easy to read. Comments only where they help a
  beginner.

## Screens (3 max)
1. **Country list.** One query asking for a few fields only (name, emoji).
   Shows that you only fetch the fields the screen needs.
2. **Country detail.** One query that gets nested related data in a single
   request (e.g. continent, languages, currency). Shows that one request
   can replace several.
3. **Error example.** A query that fails on purpose (e.g. a bad field or
   offline), showing how errors appear in `result.hasException` instead
   of being thrown, so a `try/catch` does not catch them.

Do not add more screens or features. If something seems worth adding, put
it in NOTES.md as a question.

## How to work
- Build in small steps. After each step, make sure the app runs.
- Do not "improve" beyond scope.
- Everything stated in the README or comments must be true for this repo
  and verified by running it. Do not invent benchmarks, numbers, or
  claims about performance.

## README.md (for learners)
Write in simple English:
- What the repo is and who it is for.
- How to run it.
- A short explanation of each of the 3 screens and which GraphQL idea it
  shows.
- A short, honest "good for / not good for" section: general points only
  (several data sources in one request, fetching only needed fields,
  typed schema; caching is harder than REST, setup is heavier for small
  APIs, errors can come back inside a 200 response, deep queries can be
  expensive on the backend). Do not present these as personal
  experience or measured results.

## NOTES.md (for me, not for the README)
Keep a factual log while working: steps taken, every error or confusing
moment with the exact message and fix, surprises, and open questions.
Only what really happened. If something was not tested, write
"not tested".
