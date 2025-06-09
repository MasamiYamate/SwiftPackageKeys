# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SwiftPackageKeys is a Swift Package Manager framework that automatically generates encrypted Swift code from environment files (.env or .env.json) to securely manage API keys and sensitive configuration in iOS/macOS applications.

## Build Commands

```bash
# Build the KeyGenerator binary (required for development)
make build_key_generator

# The build script is located at:
# BuildTools/build_generator.sh
```

## Architecture

The project consists of three main components:

1. **Swift Package Manager Plugin** (`Plugins/EnvironmentKeyPlugin/`)
   - Implements `BuildToolPlugin` protocol
   - Executes KeyGenerator binary during prebuild phase
   - Automatically runs when building projects that depend on this package

2. **KeyGenerator Tool** (`KeyGenerator/Sources/`)
   - Standalone Swift binary that processes .env/.env.json files
   - Core components:
     - `EnvLoader`: Parses environment files from workspace
     - `KeyValueGenerator`: Generates Swift code from environment data
     - `Encryption`: Handles AES-GCM encryption/decryption
     - `EncryptionCodeGenerator`: Creates encryption-related Swift code

3. **Runtime Framework** (`Sources/SwiftPackageKeys/`)
   - Minimal runtime - actual functionality is generated at build time
   - Generated code creates `SwiftPackageKeys+Extension.swift` in derived data

## Data Flow

1. Plugin executes during build
2. KeyGenerator reads .env/.env.json from workspace root
3. Values encrypted with random AES-GCM key per build
4. Swift extension code generated with static properties
5. App accesses values through `SwiftPackageKeys.keyName.value` API

## Environment File Formats

**.env format:**
```
APIKEY_DEV=abcdefg123456
apiKeyProd=abcdefg654321
```

**.env.json format:**
```json
{
    "keys": [
        {
            "key": "KEY_NAME",
            "productionValue": "production_key_value",
            "stagingValue": "staging_key_value", 
            "debugValue": "debug_key_value"
        }
    ]
}
```

## Usage in Client Apps

```swift
import SwiftPackageKeys

// Access environment-appropriate value (auto-selected based on DEBUG flag)
let apiKey = SwiftPackageKeys.keyName.value

// Access specific environment values
let prodKey = SwiftPackageKeys.keyName.fetchValue(stage: .production)
let debugKey = SwiftPackageKeys.keyName.fetchValue(stage: .debug)
```

## Security Model

- AES-GCM encryption with randomly generated 256-bit keys per build
- Values stored as UInt8 arrays instead of plain strings for obfuscation  
- Generated code placed in derived data (not committed to version control)
- Environment-specific value selection based on compilation flags

## Package Configuration

- **Minimum Swift**: 5.7
- **Platforms**: macOS 10.15+, iOS 13+, watchOS 8+, tvOS 15+
- **Plugin**: EnvironmentKeyPlugin with build tool capability

## Sample App

Located in `SwiftPackageKeysSampleApp/` with example environment files and Xcode schemes demonstrating different environment configurations.