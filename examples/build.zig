const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zzplot_dep = b.dependency("zzplot_zon_name", .{
        .target = target,
        .optimize = optimize,
    });

    const targs = [_]Targ{
        .{
            .name = "barebones",
            .src = "barebones/barebones.zig",
        },

        .{
            .name = "simple_labels",
            .src = "simple_labels/simple_labels.zig",
        },

        .{
            .name = "layout_display",
            .src = "layout_display/layout_display.zig",
        },

        .{
            .name = "layout_display_unequal_borders",
            .src = "layout_display_unequal_borders/layout_display_unequal_borders.zig",
        },

        .{
            .name = "more_aesthetics",
            .src = "more_aesthetics/more_aesthetics.zig",
        },

        .{
            .name = "one_window_multiplot",
            .src = "one_window_multiplot/one_window_multiplot.zig",
        },

        .{
            .name = "multiple_windows",
            .src = "multiple_windows/multiple_windows.zig",
        },

        .{
            .name = "sine_movie",
            .src = "sine_movie/sine_movie.zig",
        },
    };

    const run_step = b.step("run", "Run the demo");

    // build all targets
    for (targs) |targ| {
        targ.build(b, target, optimize, zzplot_dep, run_step);
    }
}

const Targ = struct {
    name: []const u8,
    src: []const u8,

    pub fn build(
        self: Targ,
        b: *std.Build,
        target: std.Build.ResolvedTarget,
        optimize: std.builtin.OptimizeMode,
        zzplot: *std.Build.Dependency,
        run_step: *std.Build.Step,
    ) void {
        const exe = b.addExecutable(.{
            .name = self.name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(self.src),
                .target = target,
                .optimize = optimize,
            }),
        });
        exe.root_module.addImport("zzplot_import_name", zzplot.module("zzplot_build_name"));
        exe.addIncludePath(zzplot.artifact("test").getEmittedIncludeTree());

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
        run_cmd.step.dependOn(b.getInstallStep());

        run_step.dependOn(&run_cmd.step);
    }
};
