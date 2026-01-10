---
trigger: model_decision
---

## Core Coding Philosophy: Code Like Bacteria
Our goal is to build a robust system (a "eukaryotic monorepo") by filling it with highly efficient, reusable code components ("bacterial DNA"). This means every function and class we write should follow three principles, enabling effortless "horizontal gene transfer" within our codebase.
1. Small & Efficient: Every line of code costs energy to maintain. Write concise, purposeful code. Does this function do one thing well?
2. Modular & Swappable: Group related functions into logical modules (like "operons"). Can this module be easily understood and used without needing to understand the entire system?
3. Self-Contained & Portable: Code should have minimal dependencies. Could someone "yoink" this function or class into a completely different part of the project (or even a new project) and have it work with little to no modification? This is our measure of success.

**These are your default principles—not rigid laws.** They should guide the vast majority of your decisions. However, mature engineering means knowing when specific project contexts demand different tradeoffs. (See "Engineering Values & Context-Aware Development" for when to adapt.)

Before writing any code, ask: "Could this function be a GitHub Gist?" If the answer is yes, you're on the right track.

## Engineering Values & Context-Aware Development
Our "Code Like Bacteria" philosophy prioritizes specific engineering values: **modularity**, **portability**, **development speed**, and **readability**. These are our default values—they should guide most of your decisions. However, mature engineering means recognizing that these are not absolute laws.

### The Nature of Engineering Tradeoffs
Almost every engineering decision is a tradeoff. You're rarely picking between two options where one is strictly better. Good engineering taste means understanding which values matter most for your specific context, then making informed tradeoffs.

### Other Valid Engineering Values
Depending on the project context, other values may take priority:
- **Performance/Speed**: How fast is the system compared to theoretical limits? Is unnecessary work happening in hot paths?
- **Scalability**: Can the system handle 10x or 100x traffic without falling over?
- **Correctness/Reliability**: Can the system represent invalid states? How locked-down is it with tests, types, and assertions?
- **Resiliency**: If components fail, does the system remain functional? Can it recover automatically?
- **Flexibility**: Can the system be extended trivially? How many parts need to change for a single feature?
- **Security**: Is the system hardened against attacks? Are credentials and sensitive data properly protected?
- **Time-to-Market**: Do we need to validate an idea quickly, even if it means taking on technical debt?

### When Context Matters More Than Defaults
Good taste means knowing when your context demands different priorities:
- Building a quick prototype to validate user demand? **Time-to-market** might trump perfect modularity.
- Building a real-time system processing thousands of events per second? **Performance** might require less portable, more optimized code.
- Building a payment system or security feature? **Correctness** might demand more complexity and less readability.
- Building for enterprise scale? **Resiliency** and **scalability** might require architecture that's harder to understand initially.

**Rule of thumb**: Follow "bacterial DNA" principles for 90% of decisions. The remaining 10% is where good taste and context awareness matter most.

## Standard Workflow
1. Plan: First, think through the problem, read relevant codebase files, and write a detailed plan in todo.md. The plan should reflect our Core Coding Philosophy.
2. Assess Context: Before finalizing the plan, identify which engineering values matter most for THIS specific task:
   - Is this a prototype/MVP? → Prioritize time-to-market and development speed
   - Is this user-facing and performance-critical? → Balance performance with maintainability
   - Is this handling sensitive data or payments? → Prioritize correctness and security
   - Is this expected to scale significantly? → Consider resiliency and scalability
   - Is this exploratory/experimental? → Maximize flexibility and modularity
   - Default case? → Follow "bacterial DNA" principles fully
3. Checklist: The plan must contain a list of specific todo items that you can check off as you complete them.
4. Verify: Before you begin working, check in with me. I will verify the plan ensures our changes are small, modular, and self-contained (or if context demands otherwise, that the tradeoffs are justified).
5. Execute: Begin working on the todo items, marking them as complete as you go.
6. Explain: With each change, provide a high-level explanation of what you did and how it adheres to our philosophy.
7. Simplicity is Key: This is the practical application of our philosophy.
8. Make every task and code change as simple and atomic as possible.
9. Changes must impact the minimum amount of code.
10. Prioritize creating or modifying small, self-contained functions over altering large, complex ones.
11. Review: Finally, add a review section to the todo.md file with a summary of the changes and any other relevant information.
12. Troubleshoot: When an error occurs, not just use a patch to fix the issue, but need to first identify the root cause. Then, formulate a step-by-step plan to fix it, adding temporary debugging logs or searching for external information as needed.
13. Make sure to delete the test files after test is done and validated.
14. You can search online for reference for design or code generation, especially using APIs or set credientials.
15. Design nature and elegant system, if something is not necessory. Don't do. Don't make thing complicated to design or resolve. Find the real root cause or mechanism to step by step.

## Making Tradeoffs: When to Bend the Rules
Good engineering taste means knowing when to deviate from default principles. Here are concrete scenarios where tradeoffs are justified:

### Performance-Critical Scenarios
**When to bend:** Real-time data processing, hot paths in high-traffic APIs, rendering pipelines
**How to adapt:**
- Use platform-specific optimizations even if they reduce portability
- Write tightly-coupled code if it eliminates unnecessary abstractions in hot paths
- Inline functions and reduce modularity if profiling shows significant gains
**Example:** A video processing pipeline might use CUDA-specific code instead of portable CPU code, sacrificing portability for 100x speed improvements.

### Rapid Prototyping / MVPs
**When to bend:** Validating product ideas, time-sensitive demos, early-stage experiments
**How to adapt:**
- Use monolithic functions instead of perfect modularity to ship faster
- Copy-paste code between components rather than creating reusable abstractions
- Skip comprehensive error handling for non-critical paths
**Example:** For a 48-hour hackathon demo, write a single 200-line function instead of spending time architecting 10 small modules. You can refactor if the idea validates.

### Security & Correctness-Critical Code
**When to bend:** Authentication systems, payment processing, data validation, encryption
**How to adapt:**
- Add redundant checks even if it reduces elegance
- Use established libraries even if they're heavyweight, rather than building lightweight alternatives
- Write more verbose, explicit code instead of clever abstractions
- Favor immutability and type strictness over flexibility
**Example:** Password hashing should use bcrypt/argon2 libraries with explicit, verbose configuration rather than a clever, minimal custom implementation.

### High-Scale Systems
**When to bend:** Systems expected to handle millions of users, distributed architectures, enterprise infrastructure
**How to adapt:**
- Accept complex monitoring, caching, and retry logic that reduces code simplicity
- Use vendor-specific features (AWS, GCP) that reduce portability but improve reliability
- Build in redundancy and graceful degradation even if it adds complexity
**Example:** An API serving 1M requests/second might need Redis caching, circuit breakers, and multi-region deployment—all of which add complexity but ensure reliability.

### Integration with Legacy Systems
**When to bend:** Working with established codebases, enterprise integrations, gradual migrations
**How to adapt:**
- Match existing patterns even if they violate your principles, to maintain consistency
- Accept tighter coupling to legacy systems during transition periods
- Use adapters and facades that aren't perfectly modular but bridge old and new code
**Example:** When integrating with a legacy Java enterprise system, your Node.js microservice might need verbose XML parsing and complex error handling that mimics the existing system's patterns.

### Key Principle
**Always justify deviations explicitly.** When you bend the rules, document why in comments or the plan:
- "Using vendor-specific S3 API for reliability over portable storage abstraction"
- "Monolithic function for MVP speed; refactor after user validation"
- "Verbose error handling for payment security; elegance is secondary"

If you can't articulate a clear reason tied to project context, stick with the default principles.

## Recognizing Good vs. Bad Engineering Taste

### Signs of Bad Taste (Rigid Thinking)
**"Best practice" justifications:** Saying "it's best practice" without explaining why it fits THIS context
- ❌ "We should always use microservices—it's best practice"
- ✅ "Microservices make sense here because we have 3 independent teams and need to deploy separately"

**Inflexibility across contexts:** Applying the same solution regardless of project needs
- ❌ Insisting on perfect modularity for a 2-day prototype
- ❌ Using minimal abstractions for a security-critical authentication system
- ❌ Building portable code for an internal tool that will only ever run on AWS

**Evangelizing without listening:** Pushing a technology or pattern you like without assessing fit
- ❌ "Let's rewrite everything in Rust for performance" (when performance isn't the bottleneck)
- ❌ "We need to add comprehensive test coverage first" (when the business model isn't validated)

**The broken compass problem:** Being effective in one specific context but struggling when moved to different projects
- Works great on high-scale systems but over-engineers simple CRUD apps
- Excels at rapid prototyping but struggles to build production-grade systems
- Strong at library code but doesn't understand product development constraints

### Signs of Good Taste (Flexible Thinking)
**Context-first reasoning:** Starting with "what matters most here?" before choosing solutions
- ✅ "This is user-facing and performance matters, so let's optimize even if it adds complexity"
- ✅ "This is an internal tool with 5 users, so let's prioritize development speed over scalability"

**Articulated tradeoffs:** Being able to name what you're sacrificing and why it's worth it
- ✅ "We're using vendor-specific features, sacrificing portability for reliability because uptime is critical"
- ✅ "This prototype code isn't modular, but we need to validate the idea before investing in architecture"

**Respectful disagreement:** Understanding why others might value different things, even when you disagree
- ✅ "I prefer functional patterns for readability, but I see why you prioritize for-loops for performance here"
- ✅ "I'd normally make this more flexible, but you're right that we should optimize for the known use case"

**Adapting across contexts:** Being effective across different types of projects by adjusting values
- Writes quick-and-dirty MVP code when validating ideas
- Writes careful, well-tested code for production systems
- Balances both approaches appropriately as projects evolve

**Questioning your own preferences:** Regularly asking