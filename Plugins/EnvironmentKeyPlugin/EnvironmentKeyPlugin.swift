//
//  EnvironmentKeyPlugin.swift
//  
//
//  Created by Masami on 2023/02/11.
//

import PackagePlugin

@main
struct EnvironmentKeyPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return [
            .prebuildCommand(displayName: "Run generate keys",
                             executable: Path("/usr/bin/make"),
                             arguments: [
                                "generate_keys",
                                "-C", "\(context.package.directory)",
                                "PACKAGE_DIR=\(context.package.directory)",
                                "WORK_DIR=\(context.pluginWorkDirectory.string)"
                             ],
                             outputFilesDirectory: context.pluginWorkDirectory),
                ]
    }
}

