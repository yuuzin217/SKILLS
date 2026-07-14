# Development Rules

## Architectural Principles
When creating or modifying code, you must strictly apply the following design principles:

1. **Separation of Concerns (UI and Logic)**
   - UI components (React components, page files, etc.) must only handle visual rendering and UI state management.
   - Do not write complex logic inlining within UI components. Extract all data normalization, advanced filtering, and business rules into shared utilities (e.g., `lib/utils.ts`) or dedicated logic files.

2. **Single Responsibility Principle (SRP)**
   - Each file, class, and function must have only one clear responsibility or role.
   - Ensure that UI components bear no responsibility for data processing or business rule validation.

3. **DRY Principle (Don't Repeat Yourself)**
   - Consolidate duplicate logic and knowledge into a single, reusable location. Prioritize modular design for maximum reusability.


# Global User Preferences

## Shell Configuration
- **WSL Execution Strategy:** Always prefer executing commands inside WSL instead of Windows PowerShell or Cmd.
- **Execution Strategy:** When running commands, prefix them with `wsl -- ` or run them directly via WSL.
  - **Correct Pattern:** `wsl -- YOUR_COMMAND_HERE`
  - **Reasoning:** The workspace resides in WSL (`\\wsl.localhost\Ubuntu-24.04...`). Running commands via `wsl --` ensures that they are executed natively inside the WSL Linux environment, preserving paths and runtime compatibility.


# Operational Guidelines

## Language Requirement
- **Output Language:** All final outputs, explanations, and code comments (unless standard English documentation/syntax is required) must be delivered in natural, professional Japanese. 
- *Note: Internal reasoning and intermediate analysis may be performed in the language optimal for the core model's performance, but the user-facing response must be fully Japanese.*

## Execution Rules
- **High-Context Brief Integration:** Expect comprehensive briefs containing full context, constraints, and edge cases in the first message. Synthesize this information immediately. However, to ensure code quality and prevent incomplete generations, present your execution plan first, and execute complex tasks in explicit, phased steps rather than forced single-turn completions.
- **Autonomous Self-Verification:** You must rigorously verify your own work, outputs, and logic before reporting back. Run internal sanity checks for potential errors and edge cases. Do not mark a task as "done" or output placeholder code (e.g., "// TODO: implement later") until it is genuinely verified and robust.
- **Objective-Oriented Processing:** Focus on high-effort, deep-reasoning execution. Adapt your processing depth dynamically based on the complexity of the core problem.
- **Minimalist Instruction Compliance:** Do not rely on or expect over-detailed, rigid step-by-step instructions from the user. Rely on your core reasoning capabilities and architectural best practices to determine the optimal execution path based on the high-level objective.
- **Continuous Learning Accumulation:** Structure key insights, structural changes, and hard-learned constraints discovered during the session so they can be seamlessly appended to a persistent memory file (`.md`) across sessions.
