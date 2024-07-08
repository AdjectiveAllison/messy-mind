const std = @import("std");
const httpz = @import("httpz");

// Global variable to store the root directory
var g_root_dir: []const u8 = undefined;

pub const LocalFileServer = struct {
    allocator: std.mem.Allocator,
    server: httpz.ServerCtx(void, void),
    should_stop: std.atomic.Value(bool),

    const log = std.log.scoped(.file_server);

    pub fn init(allocator: std.mem.Allocator, root_dir: []const u8, port: u16) !*LocalFileServer {
        log.info("Initializing LocalFileServer", .{});
        var self = try allocator.create(LocalFileServer);
        self.* = .{
            .allocator = allocator,
            .server = try httpz.Server().init(allocator, .{ .port = port }),
            .should_stop = std.atomic.Value(bool).init(false),
        };

        // Set the global root directory
        g_root_dir = root_dir;

        var router = self.server.router();
        router.get("/*", serveFile);
        log.info("LocalFileServer initialized", .{});

        return self;
    }

    pub fn start(self: *LocalFileServer) !void {
        log.info("Starting server listen loop", .{});
        while (!self.should_stop.load(.seq_cst)) {
            self.server.listen() catch |err| {
                log.err("Server listen error: {}", .{err});
                if (err == error.Unexpected) {
                    if (self.should_stop.load(.seq_cst)) {
                        break;
                    }
                }
                return err;
            };
        }
        log.info("Server listen loop ended", .{});
    }

    pub fn stop(self: *LocalFileServer) void {
        log.info("Stopping server", .{});
        self.should_stop.store(true, .seq_cst);
        self.server.stop();
        log.info("Server stop called", .{});
    }

    pub fn deinit(self: *LocalFileServer) void {
        log.info("Deinitializing LocalFileServer", .{});
        self.server.deinit();
        self.allocator.destroy(self);
    }
};

fn serveFile(req: *httpz.Request, res: *httpz.Response) !void {
    const path = req.url.path;

    LocalFileServer.log.debug("Serving file: {s}", .{path});
    // Construct the full file path
    var full_path = try std.fs.path.join(res.arena, &[_][]const u8{ g_root_dir, path });

    // Ensure the path is absolute
    if (!std.fs.path.isAbsolute(full_path)) {
        var abs_path_buf: [std.fs.max_path_bytes]u8 = undefined;
        full_path = try std.fs.realpath(full_path, &abs_path_buf);
    }

    LocalFileServer.log.debug("Full path: {s}", .{full_path});

    // If path ends with '/', append 'index.html'
    if (std.mem.endsWith(u8, full_path, "/")) {
        full_path = try std.fs.path.join(res.arena, &[_][]const u8{ full_path, "index.html" });
        LocalFileServer.log.debug("Appended index.html: {s}", .{full_path});
    }

    // Try to open the file
    const file = std.fs.openFileAbsolute(full_path, .{}) catch |err| {
        switch (err) {
            error.FileNotFound => {
                res.status = 404;
                res.body = "File not found";
                LocalFileServer.log.debug("File not found: {s}", .{full_path});
                return;
            },
            else => {
                res.status = 500;
                res.body = "Internal server error";
                LocalFileServer.log.debug("Error opening file: {s}, error: {any}", .{ full_path, err });
                return;
            },
        }
    };
    defer file.close();

    LocalFileServer.log.debug("File opened successfully", .{});

    // Read the file content
    const file_content = file.readToEndAlloc(res.arena, 10 * 1024 * 1024) catch |err| {
        res.status = 500;
        res.body = "Error reading file";
        LocalFileServer.log.debug("Error reading file: {s}, error: {any}", .{ full_path, err });
        return;
    };

    LocalFileServer.log.debug("File content read, size: {d} bytes", .{file_content.len});

    // Set content type based on file extension
    const ext = std.fs.path.extension(full_path);
    res.content_type = httpz.ContentType.forExtension(ext);

    LocalFileServer.log.debug("Content type set: {any}", .{res.content_type});

    // Set the response body
    res.body = file_content;

    LocalFileServer.log.debug("Response body set, serving file complete", .{});
}
