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
            .prebuildCommand(
                displayName: "Run generate keys",
                executable: Path("\(context.package.directory)/KeyGenerator/KeyGenerator"),
                arguments: [
                    "\(context.package.directory)",
                    "\(context.pluginWorkDirectory.string)"
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            ),
        ]
    }
}

