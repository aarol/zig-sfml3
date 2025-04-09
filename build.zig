const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "zig_sfml",
        .root_module = exe_mod,
    });

    exe.addIncludePath(b.path("csfml/include"));
    exe.linkLibC(); // CSFML needs stdlib.h

    if (@import("builtin").os.tag == .windows) {
        // add all .lib files to library path
        exe.addLibraryPath(b.path("csfml/lib/msvc/"));

        for ([_][]const u8{ "graphics", "system", "window" }) |name| {
            const csfml_src = b.fmt("CSFML/bin/csfml-{s}-3.dll", .{name});
            const csfml_dest = b.fmt("./bin/csfml-{s}-3.dll", .{name});
            b.installFile(csfml_src, csfml_dest);

            const sfml_src = b.fmt("SFML/bin/sfml-{s}-3.dll", .{name});
            const sfml_dest = b.fmt("./bin/sfml-{s}-3.dll", .{name});
            b.installFile(sfml_src, sfml_dest);
        }
    }

    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
