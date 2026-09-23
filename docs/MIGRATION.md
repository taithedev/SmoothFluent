# Migration Guide

SmoothFluent keeps familiar concepts such as CreateWindow, Tabs, Sections, Options, Flags, theme switching, and managers.

The implementation is independent, so internal modules should not be assumed to be interchangeable.

Recommended migration:
1. Replace the loader.
2. Recreate the Window/Tab/Section layout.
3. Replace undocumented internal imports.
4. Test each element individually.
5. Use docs/API.md for differences.

## Why not a file-for-file copy?

The upstream Fluent-modded repository contains original source code and assets under its own licensing and credits. SmoothFluent mirrors useful public organization and developer experience where practical, while keeping its implementation independently maintained.