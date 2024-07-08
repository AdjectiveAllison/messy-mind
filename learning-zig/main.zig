const std = @import("std");
const Value = enum(u2) { zero, one, two };

/// MyCoolStruct is lame.
const MyCoolStruct = struct { q: f32, l: [5]u8, d: i32 };
/// No one knows how to do anything.
pub fn main() anyerror!void {
    std.debug.print("Hello, {s}!\n", .{"World"});

    const blah = [_]u8{ 'a', 'A', 'z', 'Z' };

    std.debug.print("{s}\n", .{blah});
    // std.debug.print(&blah, .{}); does the same thing.

    const length = blah.len;
    std.debug.print("{d}\n", .{length});

    // x += if (a) 1 else 2; -- if statements can be used kinda similar to elvis statements in other languages.

    //const timer = std.time.Timer;
    //timer.start()
    // var i: u8 = 0;
    // while (i < 100) {
    //     //const loopTime = timer.lap();
    //     i += 1; // zig has no ++
    //     //std.debug.print("Loop took {d} nano seconds to run.", .{loopTime});
    //     std.debug.print("{d}\n", .{i});
    //     //if (i == 72) break; -- this short hand is phenomenal.
    //     //break

    // }

    std.debug.print("{u}\n", .{96});
    for (blah, 0..) |character, index| {
        // below has formatting types for printing interpolation. u/c(utf8/ascii) work for u8 characters and s works for slices of u8.
        // https://github.com/ziglang/zig/blob/master/lib/std/fmt.zig
        std.debug.print("{u} character is at {d} index in string with {d} length\n", .{ character, index, length });
    }

    //this is unbelievably fast and cool.
    const x = fibonacci(38);

    std.debug.print("{d}\n", .{x});

    deferWeirdness();

    // crucial concept of errors:
    // try x is a shortcut for x catch |err| return err

    // switches are strange and you need to understand the difference between statement and expression.
    // I believe expression just modifies the input to the switch directly?

    if (1 == 3) {
        // I can force compiler to be angry if somewhere in code is reached and I didn't want it to ever be able to be reached. I fuckin love this :)
        unreachable;
    }

    std.debug.print("enum value 'two' is {d} int\n", .{@enumToInt(Value.two)});

    const superCoolStruct = MyCoolStruct{
        .d = 15,
        .l = [5]u8{ 'h', 'e', 'l', 'l', 'o' }, // Trying to do this as a slice left me having errors with syntax and pointers. I believe my struct did have a properly defined slice, but this was wrong.
        .q = 161,
    };

    std.debug.print("{}\n", .{superCoolStruct});

    // _ can be used as a visual seperator in integers.
    const oneBillion: u64 = 1_000_000_000;
    const permissions: u64 = 0o7_5_5; // octal

    std.debug.print("1_000_000_000 = {}\n", .{oneBillion});
    std.debug.print("0o7_5_5 = {}\n", .{permissions});

    // convert integers to a new type - illegal behavior if out of range.
    //@intCast(comptime DestType: type, int: anytype)

    //overflow wrapping operators are interesting.
    //var a: u8 = 255;
    //a +%= 1;
    //try expect(a == 0);

    // intToFloat is always legal
    //@intToFloat(comptime DestType: type, int: anytype)
    // floatToInt can be illegal if not a whole number.
    //@floatToInt(comptime DestType: type, float: anytype)

    // loops as expressions and breaking/continuing to labels is some powerful mumbo jumbo.

    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //const allocator = gpa.allocator();

    //const solidMath = try std.fmt.allocPrint(allocator, "{d} + {d} = {d}", .{ 27, 3, 12 });

    //defer allocator.free(solidMath);
    //std.debug.print("Look at this solid math:\n{s}\n", .{solidMath});

    // you're kinda bad at handling errors idk what language you came from.
    // testingFileCreation("blah.txt") catch |err| switch (err) {
    //     error.AccessDenied => {
    //         std.log.err("ERROR - You don't have write permissions you silly person: {any}", .{err});
    //     },
    //     else => {
    //         std.log.err("Unknown error writing file: {any}", .{err});
    //     },
    // };
}

// Idk how to handle errors yet so this function never returned propery because of my try on file create.
// fn testingFileCreation(filePath: []const u8) anyerror {
//     const file = try std.fs.cwd().createFile(
//         filePath,
//         .{ .read = true },
//     );

//     defer file.close();

//     const writtenContent = "Hello File!";
//     try file.writeAll(writtenContent);

//     var buffer: [writtenContent.len]u8 = undefined;
//     try file.seekTo(0);
//     const bytes_read = try file.readAll(&buffer);

//     std.debug.print("original content:\n {d} len\n{s}", .{ writtenContent.len, writtenContent });
//     std.debug.print("read content:\n {d} len\n{s}", .{ buffer.len, bytes_read });
// }

fn deferWeirdness() void {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    std.debug.print("multiple defers execute in reverse order.\n", .{});
    std.debug.print("That means 5 / 2 = 2.5 and 2.5 + 2 = 4.5 -- {any}\n", .{x == 4.5});
    // it looks like {} and {any} are the same thing for string fmt.
}

//u32 so big
fn fibonacci(n: u32) u32 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// fn testingForFun(stringThing: []u8, extendBy: u32) []u8 {
//     _ = extendBy;
//     const stringLength = stringThing.len;
//     _ = stringLength;
// }
