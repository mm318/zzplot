const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const nanovg_dep = b.dependency("nanovg_zon_name", .{
        .target = target,
        .optimize = optimize,
    });

    const zzplot = b.addModule("zzplot_build_name", .{
        .root_source_file = b.path("src/zzplot.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    zzplot.addImport("nanovg_import_name", nanovg_dep.module("nanovg"));
    zzplot.addIncludePath(.{ .cwd_relative = "../nanovg-zig/lib/gl2/include" });

    const zzplot_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/zzplot_test.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    const run_zzplot_tests = b.addRunArtifact(zzplot_tests);
    const test_step = b.step("test", "Run module tests");
    test_step.dependOn(&run_zzplot_tests.step);
}
