const std = @import("std");
const LocalFileServer = @import("file_server.zig").LocalFileServer;
const WebViewApp = @import("webview.zig").WebViewApp;

// Define logging options
pub const log_level: std.log.Level = .debug;
pub const log_scope_levels = [_]std.log.ScopeLevel{
    .{ .scope = .file_server, .level = .info },
    .{ .scope = .webview, .level = .debug },
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Get the absolute path of the current working directory
    var cwd_buf: [std.fs.max_path_bytes]u8 = undefined;
    const cwd = try std.process.getCwd(&cwd_buf);

    const root_dir = try std.fs.path.join(allocator, &[_][]const u8{ cwd, "web" });
    defer allocator.free(root_dir);

    const port = 8080;

    std.log.info("Starting server with root directory: {s}", .{root_dir});

    var server = try LocalFileServer.init(allocator, root_dir, port);
    defer server.deinit();

    // Start the server in a separate thread
    var server_thread = try std.Thread.spawn(.{}, LocalFileServer.start, .{server});

    // Small delay to ensure server is up
    std.time.sleep(std.time.ns_per_s);

    var webview_app = try WebViewApp.init(allocator, port, log_level == .debug);
    defer webview_app.deinit(allocator);

    webview_app.run() catch |err| {
        std.log.err("Error running WebView: {}", .{err});
        webview_app.stop();
    };

    std.log.info("WebView closed, stopping server", .{});
    server.stop();

    // Join the server thread
    server_thread.join();

    std.log.info("Server thread joined", .{});
    std.log.info("Main function ending", .{});
}
