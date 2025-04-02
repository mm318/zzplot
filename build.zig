const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zzplot_dep = b.dependency("zzplot_impl", .{
        .target = target,
        .optimize = optimize,
    });
    const zzplot_examples_dep = b.dependency("zzplot_examples", .{
        .target = target,
        .optimize = optimize,
    });

    b.modules.put("zzplot", zzplot_dep.module("zzplot_build_name")) catch @panic("OOM");

    const zzplot_lib = b.addLibrary(.{
        .name = "zzplot",
        .linkage = .static,
        .root_module = zzplot_dep.module("zzplot_build_name"),
    });
    zzplot_lib.installHeadersDirectory(zzplot_dep.artifact("test").getEmittedIncludeTree(), "", .{});
    b.installArtifact(zzplot_lib);

    for (zzplot_examples_dep.builder.install_tls.step.dependencies.items) |dep_step| {
        const inst = dep_step.cast(std.Build.Step.InstallArtifact) orelse continue;
        b.installArtifact(inst.artifact);
    }
}
