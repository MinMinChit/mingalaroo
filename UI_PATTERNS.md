# 🎨 UI Patterns & Effects Library
This document serves as the "Recipe Book" for the project's special effects. Use this to reference established animations and behaviors, ensuring consistency and ease of reuse.

## 1. Parallax Scroll Background
**Effect**: The background image moves slower than the scrolling content, creating a sense of depth.
- **Where it lives**: `hero_section.dart` (lines 57-71)
- **Key Parameters (Business Logic)**:
  - **Scroll Factor** (0.25): Determines how much the image scales/moves relative to scroll. Lower = subtler depth, Higher = dramatic separation.
  - **Initial Scale** (1.4): The starting zoom level. Must be > 1.0 to allow room for movement without showing edges.
  - **Clamp** (0.0 - 1.0): Limits the effect so it doesn't scale infinitely.

## 2. Watercolor Reveal
**Effect**: An image transitions from "Grayscale + Blurred" to "Color + Sharp" to simulate a painting coming to life.
- **Where it lives**: `hero_section.dart` (lines 79-95)
- **Key Parameters**:
  - **Saturation Duration** (3000ms): Time to go from Black & White to Color.
  - **Blur Duration** (3000ms): Time to go from blurry to sharp.
  - **Initial Blur** (2, 2): The starting fuzziness in X and Y directions.

## 3. 3D Hover Tilt & Gloss
**Effect**: An element tilts in 3D space following the mouse cursor, accompanied by a moving "gloss" reflection.
- **Where it lives**: `spouse_name_section.dart` (lines 94-146)
- **Key Parameters**:
  - **Max Tilt** (0.5): The maximum rotation angle (in radians) at the edges of the element.
  - **Perspective** (0.001): The "lens" intensity. higher (0.005) = fisheye/extreme 3D, lower (0.0001) = isometric/flat 3D.
  - **Recenter Speed**: (Currently instantaneous) - Could be smoothed out for a "heavy" feel.

## 4. Velvet Curtain Reveal
**Effect**: A dual-panel curtain that pulls back with a realistic fabric curve and shadow edge.
- **Where it lives**: `services/curtain_animation.dart`
- **Key Parameters**:
  - **Animation Curve** (Curves.easeInOutCubic): Starts slow, speeds up, ends slow. Essential for the "heavy fabric" feel.
  - **Fold Width**: Controlled by the `LinearGradient` stops (lines 137-146).
  - **Opening Ratio**: The `Interval` (0.0-0.8 vs 0.4-1.0) controls the lag between the bottom opening and the top opening.

## 5. Infinite Marquee
**Effect**: A row of images that scrolls infinitely in one direction.
- **Where it lives**: `poem_section.dart` (lines 91-143)
- **Key Parameters**:
  - **Speed** (50s - 85s): Total time for one loop. Slower for background ambience.
  - **Direction**: Controlled by `isMovingRight`.
  - **Repetition Count**: Currently 4x constraints. Must be enough to fill 2x screen width to avoid gaps.

## 6. Typewriter Text
**Effect**: Text appears one character at a time.
- **Where it lives**: `poem_section.dart` (lines 145-194)
- **Key Parameters**:
  - **Typing Duration** (4000ms): Total time to type the whole block.
  - **Cursor**: (Not currently implemented, but often paired).
  - **Resolution**: Updates per frame.

## 7. Floating "Bobbing" Animation
**Effect**: An element gently floats up and down endlessly.
- **Where it lives**: `hero_section.dart` and `story_section.dart`
- **Key Parameters**:
  - **Bob Distance** (15px): How far it moves up/down.
  - **Cycle Duration** (2s - 3s): How fast it breathes.
  - **Curve** (Curves.easeInOut): Essential for the smooth turn-around at top and bottom.

## 8. Particle Celebration
**Effect**: Confetti and flowers explode from a clicked point.
- **Where it lives**: `magic_btn.dart`
- **Key Parameters**:
  - **Particle Count** (200): Density of the explosion.
  - **Gravity** (0.1 - 0.3): How heavy the particles feel.
  - **Drag** (0.93): Air resistance. Lower = floaty/slow down fast. Higher = shoot far.

## 9. Emoji Cursor
**Effect**: Replaces the system mouse pointer with a large emoji.
- **Where it lives**: `emoji_cursor.dart`
- **Key Parameters**:
  - **Emoji Size** (42px): Visual impact.
  - **Offset** (-8, -8): Centers the emoji on the actual click point (hotspot).

## 10. Expanding Letter Spacing
**Effect**: Text "breathes" in by expanding the space between letters.
- **Where it lives**: `hero_section.dart` (lines 235-246)
- **Key Parameters**:
  - **Spacing Range** (0 -> 5.0): The expansion amount.
  - **Opacity Fade**: Usually paired with a FadeIn to mask the initial jerky layout shift.
