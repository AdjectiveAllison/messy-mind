const std = @import("std");
const WebView = @import("webview").WebView;

pub const WebViewApp = struct {
    webview: WebView,
    server_port: u16,
    running: bool,

    const log = std.log.scoped(.webview);

    pub fn init(allocator: std.mem.Allocator, server_port: u16, debug: bool) !*WebViewApp {
        log.info("Initializing WebViewApp", .{});
        const self = try allocator.create(WebViewApp);
        const w = WebView.create(debug, null);
        w.setTitle("WebView FFI Example");
        w.setSize(800, 600, WebView.WindowSizeHint.None);
        self.* = .{
            .webview = w,
            .server_port = server_port,
            .running = true,
        };
        return self;
    }

    pub fn run(self: *WebViewApp) !void {
        log.info("Starting WebView", .{});
        var url_buffer: [100:0]u8 = undefined;
        const url = try std.fmt.bufPrintZ(&url_buffer, "http://localhost:{d}", .{self.server_port});
        log.debug("Navigating to URL: {s}", .{url});
        self.webview.navigate(url);

        // Bind JavaScript to Zig functions
        self.webview.bind("jsToZig", jsToZig, self);
        self.webview.bind("logToZig", logToZig, self);

        // Set up a timer to call zigToJs every 5 seconds
        var timer = try std.time.Timer.start();
        var interval: u64 = 0;

        while (self.running) {
            self.webview.run();
            const elapsed = timer.read();
            if (elapsed > interval + std.time.ns_per_s * 5) {
                interval = elapsed;
                self.webview.dispatch(zigToJs, self);
            }
        }
    }

    pub fn stop(self: *WebViewApp) void {
        self.running = false;
        self.webview.terminate();
    }

    pub fn deinit(self: *WebViewApp, allocator: std.mem.Allocator) void {
        log.info("Deinitializing WebViewApp", .{});
        self.webview.destroy();
        allocator.destroy(self);
    }

    fn zigToJs(w: WebView, arg: ?*anyopaque) void {
        _ = arg;
        const js = "receivedFromZig('Hello, JavaScript!');";
        w.eval(js);
        log.debug("Sent message to JavaScript: {s}", .{js});
    }

    fn jsToZig(seq: [:0]const u8, req: [:0]const u8, arg: ?*anyopaque) void {
        const self: *WebViewApp = @ptrCast(@alignCast(arg.?));
        log.debug("Received from JavaScript: {s}", .{req});
        const response = "{\"message\":\"Message received by Zig!\"}";
        log.debug("Sending response to JavaScript: {s}", .{response});
        self.webview.ret(seq, 0, response);
    }

    fn logToZig(seq: [:0]const u8, req: [:0]const u8, arg: ?*anyopaque) void {
        const self: *WebViewApp = @ptrCast(@alignCast(arg.?));
        log.warn("JavaScript log: {s}", .{req});
        const response = "null";
        log.debug("Sending response to JavaScript log: {s}", .{response});
        self.webview.ret(seq, 0, response);
    }
};
