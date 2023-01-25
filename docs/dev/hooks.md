```mermaid
graph TD
    Q(Query) --> PR(parser)
    PR --> PL(planner)
    PL --> E(Executor)
    E --> Result
    PR -->|post_parse_analyze_hook| PAR(pa_rewrite)
    PAR --> PL
```
