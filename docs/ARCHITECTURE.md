# SmoothFluent Architecture

SmoothFluent keeps the standalone loader small enough to use from a raw GitHub URL while exposing optional modules for Rojo projects.

src/Fluent.lua
: Dependency-free runtime bundle and public API.

src/Managers
: Save, interface, floating button, media, keybind, performance and command systems.

src/Utilities
: Signal and Janitor lifecycle helpers.

src/Themes
: Extra theme presets.

example
: Full showcase scripts.

The core implementation is independent. The reference library was used for API and feature comparison, while SmoothFluent uses its own implementation and file structure.
