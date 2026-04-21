# Design System Specification: The Kinetic Pulse

## 1. Overview & Creative North Star
The "Kinetic Pulse" is the creative North Star of this design system. It is designed to capture the high-octane energy of urban India’s fitness revolution while maintaining the sophisticated restraint of a premium lifestyle brand. Unlike generic fitness apps that rely on cluttered grids and loud borders, this system utilizes **"Atmospheric Tension"**—a concept where space, depth, and bold typography do the heavy lifting.

We are moving away from "template" design. Expect intentional asymmetry, large-scale editorial type, and a focus on "The Glow"—where the primary orange-red acts as a light source within a dark, premium environment. This is not just a utility; it is a digital sanctuary for the high-performing urbanite.

---

## 2. Colors & Surface Architecture
Our palette centers on deep tonal shifts to create focus. The vibrancy of the orange-red is earned through the sobriety of the charcoal backgrounds.

### The Color Tokens
*   **Background / Surface:** Use `surface` (#111125) for the base canvas.
*   **Primary Action:** Use `primary_container` (#ff5637) for high-energy interactions. It carries the weight and "punch" required for a fitness motivator.
*   **Secondary/Tertiary:** Use `tertiary` (#64d4fc) sparingly for data visualization (e.g., hydration or recovery metrics) to provide a cooling contrast to the heat of the primary red.

### The "No-Line" Rule
**Explicit Instruction:** Prohibit 1px solid borders for sectioning. Boundaries must be defined solely through background color shifts. To separate a workout module from the main feed, place a `surface_container_low` section on top of a `surface` background. 

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. 
1.  **Base:** `surface_container_lowest` (#0c0c1f) for the deepest background elements.
2.  **Middle Ground:** `surface_container` (#1e1e32) for the general content area.
3.  **Foreground:** `surface_container_high` (#28283d) or `highest` (#333348) for active cards and interactive modules.

### The "Glass & Gradient" Rule
To achieve a "bespoke" feel, use Glassmorphism for floating elements (like a sticky "Start Workout" bar). Apply a semi-transparent `surface_variant` with a 20px backdrop blur. For Hero CTAs, apply a subtle linear gradient from `primary` (#ffb4a5) to `primary_container` (#ff5637) at a 135-degree angle to give the element "soul" and dimension.

---

## 3. Typography: The Editorial Voice
This system uses a high-contrast scale to create an editorial feel, reminiscent of high-end fitness magazines.

*   **Display (Lexend):** Use `display-lg` for massive, unapologetic motivation—"GO AGAIN." Lexend’s geometric nature feels engineered and modern.
*   **Headlines (Lexend):** Use `headline-lg` for section headers. These should be tight-tracked (e.g., -2%) to feel dense and powerful.
*   **Body & Labels (Manrope):** Manrope provides a technical, clean counterpoint to the aggression of Lexend. Use `body-md` for workout descriptions and `label-md` for technical stats.

**Hierarchy Strategy:** Always pair a `display-sm` heading with a `label-md` uppercase sub-header. The massive size difference creates the premium "boutique" look.

---

## 4. Elevation & Depth: Tonal Layering
We do not use shadows to create "pop"; we use light and tone.

*   **The Layering Principle:** Depth is achieved by "stacking." A `surface_container_highest` card sitting on a `surface_container_low` background creates a natural, soft lift.
*   **Ambient Shadows:** If an element must float (like a FAB), the shadow must be invisible to the untrained eye. Use the `on_surface` color at 6% opacity with a 32px blur and 16px Y-offset. It should feel like a soft ambient occlusion, not a "drop shadow."
*   **The "Ghost Border" Fallback:** If accessibility requires a container boundary, use the `outline_variant` token at **15% opacity**. This creates a "breath" of a line rather than a hard edge.

---

## 5. Components

### Buttons
*   **Primary:** `primary_container` background with `on_primary_container` text. Use `rounded-md` (0.375rem). The padding should be generous (16px top/bottom, 32px left/right) to feel substantial.
*   **Secondary:** `surface_variant` background with a "Ghost Border." 
*   **Tertiary:** Text-only, using `primary` color with `label-md` styling and 1.5px letter spacing.

### Cards & Lists
*   **The Divider Ban:** Strictly forbid 1px dividers between list items. Use 16px or 24px of vertical white space or a subtle shift from `surface_container` to `surface_container_high` to delineate content blocks.
*   **Content Grouping:** Use `rounded-xl` (0.75rem) for main cards to give a modern, approachable feel to the rugged charcoal palette.

### Input Fields
*   **State:** Default state is a `surface_container_highest` fill. 
*   **Focus:** Transition the background to `surface_bright` and add a 1px "Ghost Border" using the `primary` color at 40% opacity. Never use a solid 100% opaque border for focus.

### Additional Signature Components
*   **The Progress Pulse:** Use a `tertiary` (#64d4fc) thin-stroke circular glow for activity tracking. 
*   **Metric Chips:** Small, `surface_variant` capsules with `label-sm` text in `on_surface_variant`. These should feel like technical metadata on a high-end watch face.

---

## 6. Do’s and Don’ts

### Do
*   **Do** use asymmetrical layouts. A headline might be left-aligned while the supporting body text is indented by two columns.
*   **Do** allow for "Dead Space." Premium brands aren't afraid of empty screens.
*   **Do** use high-quality, high-contrast imagery of urban India (concrete, neon, sweat, motion-blur).

### Don’t
*   **Don’t** use pure white (#FFFFFF). Use `on_surface` (#e2e0fc) for text to prevent optical vibration on the dark background.
*   **Don’t** use 1px dividers or heavy shadows.
*   **Don’t** use standard "Success" green if you can help it. Use the `tertiary` blue for positive metrics to keep the "Urban Night" aesthetic consistent.
*   **Don’t** crowd the interface. If a screen feels "busy," increase the vertical spacing by 2x.