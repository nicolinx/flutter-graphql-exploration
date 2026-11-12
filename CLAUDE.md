# GraphQL in Flutter: mini experiment

Tiny Flutter project to try GraphQL for the first time and write down what
actually happens. The point is the notes, not the app. Keep everything small.

## Scope (do not exceed)
- One screen only: a list of countries (name, emoji flag, capital).
- Tapping an item is NOT needed. No navigation, no extra screens.
- API: https://countries.trevorblades.com/ (public, no token).
  Check that it responds before building. If it is down, stop and tell me.
- Package: `graphql_flutter`. One query, one `Query` widget (or the hooks
  equivalent, pick the simplest). No codegen, no state management library,
  no architecture layers, no tests, no extra packages.
- Plain Material widgets. No custom theming.

## How to work
- Build it in small steps. After each step, make sure the app runs before
  moving on.
- Use the latest stable `graphql_flutter` and check its README for the
  current setup. Do not rely on memory for API names.
- Do not "improve" anything beyond the scope. If something seems worth
  adding, put it in NOTES.md as a question instead.

## NOTES.md (most important output)
Keep a `NOTES.md` while working, in plain factual language:
1. **Steps**: what was done, in order (setup, client, query, UI).
2. **Problems**: every error, warning, or confusing moment, with the exact
   message and what fixed it. Include wrong turns, not just the final path.
3. **Surprises**: anything that behaved differently from what the docs or
   expectations suggested.
4. **Size**: rough number of lines for the GraphQL setup + query + UI.
5. **Open questions**: things not checked or not understood.

Only write what really happened in this project. Do not guess, do not
invent errors or results, do not add lessons or opinions. If something
wasn't tested, say "not tested".
