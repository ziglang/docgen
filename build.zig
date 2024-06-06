const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const doctest_exe = b.addExecutable(.{
        .name = "doctest",
        .root_source_file = b.path("src/doctest.zig"),
        .target = target,
        .optimize = optimize,
    });

    const docgen_exe = b.addExecutable(.{
        .name = "docgen",
        .root_source_file = b.path("src/docgen.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(doctest_exe);
    b.installArtifact(docgen_exe);

    const doctest_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/doctest.zig"),
        .target = target,
        .optimize = optimize,
    });

    const docgen_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/docgen.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_doctest_unit_tests = b.addRunArtifact(doctest_unit_tests);
    const run_docgen_unit_tests = b.addRunArtifact(docgen_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_doctest_unit_tests.step);
    test_step.dependOn(&run_docgen_unit_tests.step);
}
