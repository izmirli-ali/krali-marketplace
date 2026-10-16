---
name: krali-arastirma
description: Use when a user asks to research any brand or business, audit its web or social presence, analyze competitors or public Reels, inspect Meta Ad Library creatives, identify evidence-backed audience hypotheses, or build a reference-video library.
---

# KRALİ Araştırma

Use the KRALİ Araştırma tools as the system of record. Do not replace the staged workflow with a free-form answer.

1. Call `system_status` before starting. If paused, explain that the owner stopped new research and do not work around it.
2. Start or resume exactly one research session. After every material tool call, call `get_next_research_step` and follow its returned required action.
3. Ask no more than two short intake questions per turn. Confirm the brief before deep research.
4. Research the brand with multiple independent public sources. Separate observed facts, partial access, hypotheses, unverified matches, and blocked access. Never invent metrics.
5. Propose competitors by type, obtain the user's confirmation, and keep commercial benchmarks separate from aspirational and creative-reference accounts.
6. Inspect Meta Ad Library for the brand and fixed commercial benchmarks. Record active creatives or a dated no-active-ads result. Never infer age, gender, reach, device use, or local demand from ordinary commercial ads.
7. Ask whether the user can provide aggregated first-party advertising, Instagram Insights, CRM, or survey results. Record supplied aggregates with `record_audience_evidence`; if none exist, record `UNAVAILABLE` and keep audience conclusions explicitly hypothetical.
8. For visual Instagram/Reels analysis, obtain explicit consent for public read-only inspection. Normal Chat must not claim playback. Call `get_visual_work_packet` and use that compact packet—not the full conversation—as the Work handoff. Only after the user confirms that the public browser context is ready may `confirm_visual_browser_readiness` be called.
9. In Work, inspect the latest two public Reels from the brand and the latest two from every fixed benchmark. A user may additionally provide any older or different public Reel with `add_reference_seed`; analyze that extra Reel to the same standard without raising the mandatory two-Reel quota.
10. Use the connected browser read-only. Do not like, follow, comment, save, share, message, enter DMs, inspect private accounts, download media, or read unrelated tabs. Record `full_playback` only after the complete video was actually played with duration, start/end, and at least three timestamped scene notes.
11. Keep visual work bounded: QUICK targets 8 references, STANDARD 15, and DEEP 20. Do not require a separate broad-pool, shortlist, saturation, or final re-watch stage. When a suitable reference is discovered, play it once in full and immediately record its evidence, hook, visual language, edit rhythm, sound/speech, CTA, brand adaptation, shooting note, planned content slot, and production scores.
12. Label every Reel evidence record with its real role: `BRAND`, `COMPETITOR`, `REFERENCE`, or `USER_EXTRA`. External reference videos must never satisfy the brand's own Reel quota.
13. Keep the requested content-category and Turkey/global quotas. Re-check each final link when it is recorded. User-supplied examples may be assessed as adaptable, unsuitable, or inaccessible; do not force them into the library.
14. Run the quality gate. Do not claim completion while any check is incomplete. Build report context only after `READY`.
15. In the final summary, map brand, audience, positioning, and content-pillar claims to their own evidence IDs. Audience claims must use structured audience evidence, including an `UNAVAILABLE` record when data is absent.
16. Return the completed research-library URL and state any access, playback, data, or freshness limitations.

The MCP server cannot technically prove which browser tab was active or launch Work invisibly from Normal Chat. Treat Work/browser readiness as a user-confirmed boundary. The compact Work packet reduces repeated context; it does not remove model usage or bypass account limits.
