# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

WaveShield is a FiveM anti-cheat system that provides server-side and client-side protection against cheaters and exploiters. The codebase is primarily written in Lua with a Node.js build system.

## Build Commands

### Development
```bash
# Standard build (production)
build.bat

# Beta build with beta flag
build_beta.bat  

# Development build (no obfuscation)
build_dev.bat
```

### Build Process
The build system (`Builder/index.js`) performs the following:
1. Merges multiple Lua modules into single files for client and server
2. Obfuscates code using Luraph (unless --dev flag is used)
3. Builds web UI files from `waveshield-pkg` directory (requires Bun)
4. Creates ZIP archives in `Builds/` directory
5. Copies files to `waveshield-v3/apps/ingress-api/assets/` for distribution

### Testing
No test framework detected. Manual testing required after builds.

## Architecture

### Directory Structure
- `Source/Load/` - Core Lua modules (merged during build)
  - `core/` - Core functionality (encryption, shared utilities)
    - `client/` - Client-side core systems
    - `server/` - Server-side core systems (player management, logging)
  - `modules/` - Feature modules
    - `client/` - Client detection modules (anti-cheat checks)
    - `server/` - Server protection modules (event handlers, anti-backdoors)
    - `heartbeat/` - Client-server heartbeat system
    - `include/` - Exported API functions
- `Source/Public/` - Public distribution files (fxmanifest, package.json)
- `Source/Auth/` - Authentication module
- `Builder/` - Node.js build system
- `Builds/` - Generated build archives

### Key Components

#### Luraph SDK Integration
All modules include `luraphsdk.lua` which provides obfuscation macros like `LPH_NO_VIRTUALIZE` and `LPH_JIT_MAX`.

#### Player Management System
Server-side player tracking via classes:
- `cache.lua` - Data caching system
- `player.lua` - Individual player state
- `playerManager.lua` - Global player management

#### Event Security
- Secured event lists for client and server
- Event signature validation system
- Token-based event authorization

#### Module System
Modules are merged in specific order during build:
- Client modules handle detection (execution, teleport, godmode, etc.)
- Server modules handle validation and punishment
- Heartbeat system maintains client-server synchronization

### Build File Merging Order
Files are concatenated in the specific order defined in `Builder/index.js`:
- Client: SDK → initializer → shared → encryption → core systems → modules
- Server: SDK → initializer → shared → encryption → classes → core systems → modules
- Includes/Exports maintain separate merge paths

## Development Guidelines

### Code Conventions
- Use `LPH_NO_VIRTUALIZE()` wrapper for performance-critical functions
- Use `LPH_JIT_MAX()` for frequently called functions
- Follow existing event handler patterns
- Maintain separation between client/server/shared code

### Security Considerations
- All client-side code is obfuscated in production builds
- Event signatures prevent replay attacks
- Token system validates legitimate events
- Never expose server-side validation logic to clients

### Adding New Modules
1. Create module file in appropriate directory (`modules/client/` or `modules/server/`)
2. Add file path to merge list in `Builder/index.js`
3. Follow existing module patterns for event handling and exports
4. Test thoroughly before production deployment

### Dependencies
- Node.js for build system
- Bun for web UI builds (external `waveshield-pkg` directory)
- Luraph for code obfuscation
- FiveM server requirements (OneSync, server build 14317+)