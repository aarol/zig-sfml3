const std = @import("std");

const sf = @cImport({
    @cInclude("CSFML/Graphics.h");
    @cInclude("CSFML/Window.h");
    @cInclude("CSFML/System.h");
});
pub fn main() !void {
    const mode = sf.sfVideoMode{
        .bitsPerPixel = 32,
        .size = .{ .x = 500, .y = 500 },
    };
    const window = sf.sfRenderWindow_create(mode, "SFML in Zig", sf.sfClose | sf.sfResize, sf.sfWindowed, null);
    defer sf.sfRenderWindow_destroy(window);

    const circle = sf.sfCircleShape_create();
    defer sf.sfCircleShape_destroy(circle);

    sf.sfCircleShape_setRadius(circle, 100);
    sf.sfCircleShape_setPosition(circle, .{ .x = 150, .y = 150 });
    sf.sfCircleShape_setFillColor(circle, sf.sfBlack);

    while (sf.sfRenderWindow_isOpen(window)) {
        var event: sf.sfEvent = undefined;
        // Process events
        while (sf.sfRenderWindow_pollEvent(window, &event)) {
            if (event.type == sf.sfEvtClosed) {
                sf.sfRenderWindow_close(window);
            }
        }

        // Render loop
        sf.sfRenderWindow_clear(window, sf.sfWhite);

        sf.sfRenderWindow_drawCircleShape(window, circle, null);

        sf.sfRenderWindow_display(window);
    }
}
