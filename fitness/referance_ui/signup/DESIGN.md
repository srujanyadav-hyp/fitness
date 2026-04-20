# Design System Specification: The Electric Void

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Electric Void."** 

This is an editorial-first, high-fidelity dark mode experience designed to feel like a high-end cinematic interface. We are moving away from the "flat web" by leaning into deep, atmospheric layering and high-energy focal points. The system thrives on the tension between the vastness of the dark slate backgrounds (`#0D1110`) and the sharp, radioactive precision of the mint green accents (`#5DCAA5`). 

To break the "template" look, designers must prioritize **intentional asymmetry**. Use large, overlapping typography and components that bleed off the grid to create a sense of motion. This is not a utility dashboard; it is a high-performance environment where every pixel feels curated and alive.

---

## 2. Colors & Surface Architecture

### The "No-Line" Rule
Standard 1px solid borders for sectioning are strictly prohibited. In this design system, boundaries are defined through **Tonal Transitions**. To separate a sidebar from a main content area, transition from `surface-container-low` to `surface`. This creates a sophisticated, "carved" look rather than a segmented "box" look.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of semi-translucent materials. 
- Use `surface-container-lowest` (`#0b0f0e`) for the deepest background elements.
- Use `surface-container-high` (`#272b2a`) for interactive cards.
- **Nesting Logic:** When placing a card inside a section, the card should always be one tier higher than its parent container to create a natural, "floating" sense of importance.

### The "Glass & Gradient" Rule
Flat colors lack soul. To achieve a high-fidelity finish:
- **Glassmorphism:** For floating menus or modals, use `surface` at 60% opacity with a `backdrop-filter: blur(20px)`. 
- **Signature Gradients:** For primary CTAs, use a linear gradient from `primary` (`#7ae6c0`) to `primary-container` (`#5dcaa5`) at a 135-degree angle. This adds a "lithium glow" effect that static hex codes cannot replicate.

---

## 3. Typography
The typography strategy creates an energetic hierarchy that balances tech-forward aggression with premium stability.

*   **Headings (Lexend):** These are your "vocal" elements. Use `display-lg` and `headline-lg` with tight letter-spacing (-2%) to create an authoritative, cinematic presence. Lexend’s geometric nature should be used to anchor the layout, often placed in unexpected, asymmetrical positions.
*   **Body & Titles (Manrope):** This is your "high-trust" layer. Manrope provides a clean, functional counterpoint to the energetic Lexend. Use `body-lg` for editorial copy to ensure maximum readability against the dark background.
*   **Scale Contrast:** Don't be afraid of "The Great Divide"—pairing a `display-lg` headline with a tiny `label-sm` metadata tag creates a sophisticated, high-fashion editorial rhythm.

---

## 4. Elevation & Depth

### The Layering Principle
Depth is achieved through **Tonal Layering** rather than structural lines.
1. **Base:** `background` (#101413)
2. **Sectioning:** `surface-container-low` (#181c1b)
3. **Interactive Elements:** `surface-container-high` (#272b2a)

### Ambient Shadows
When an element must float (like a dropdown), use a "Mint-Tinted Shadow." Instead of a black shadow, use a highly diffused (40px blur) shadow using `primary` at 8% opacity. This simulates the light of the mint accents reflecting off the dark slate surfaces.

### The "Ghost Border"
If a border is required for accessibility, it must be a **Ghost Border**. Use the `outline-variant` token at 15% opacity. This creates a suggestion of a boundary without breaking the atmospheric immersion.

---

## 5. Components

### Buttons
- **Primary:** High-energy mint gradient (`primary` to `primary-container`). On hover, add a 4px outer glow using the `primary` color.
- **Secondary:** Transparent background with a `Ghost Border` and `primary` text.
- **Tertiary:** Pure text using `primary` color, with an animated underline that expands from the center on hover.

### Cards
Cards must never have a 100% opaque border. Use `surface-container-highest` for the background and a `backdrop-filter: blur(10px)` if placed over complex backgrounds. Use vertical whitespace (32px or 48px) to separate card groups rather than dividers.

### Input Fields
Avoid the "four-sided box." Use a `surface-container-lowest` background with a 2px bottom-border in `outline-variant`. Upon focus, the border should animate to `primary` and a faint mint glow should radiate from the base.

### Glass Modals
Floating overlays must use a `surface-variant` background with 40% opacity. The border should be a 1px "inner-glow" style using `primary-fixed-dim` at 20% opacity to catch the "light" of the interface.

---

## 6. Do's and Don'ts

### Do
- **Do** use generous whitespace. The "Void" needs room to breathe.
- **Do** lean into the "glow." Use mint accents for data visualization and critical calls to action.
- **Do** use asymmetrical layouts where images or text blocks overlap across container boundaries.

### Don't
- **Don't** use pure white (#FFFFFF) for text; use `on-surface` (#e0e3e1) to reduce eye strain and maintain the cinematic tone.
- **Don't** use standard 1px solid dividers. If you need to separate content, use a background color shift or a 64px gap.
- **Don't** use "drop shadows" that are black and heavy. Keep shadows tinted and ethereal.